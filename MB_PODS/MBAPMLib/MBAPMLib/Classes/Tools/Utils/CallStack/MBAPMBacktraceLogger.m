//
//  MBAPMBacktraceLogger.m
//  MBAPMBacktraceLogger
//
//  Created by xp on 20201103.
//

#import "MBAPMBacktraceLogger.h"
#import <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <sys/types.h>
#include <limits.h>
#include <string.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>
#import "MBAPMLogDef.h"
#import "MBThreadStackModel.h"

#pragma -mark DEFINE MACRO FOR DIFFERENT CPU ARCHITECTURE
#if defined(__arm64__)
#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(3UL))
#define MBAPM_THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
#define MBAPM_THREAD_STATE ARM_THREAD_STATE64
#define MBAPM_FRAME_POINTER __fp
#define MBAPM_STACK_POINTER __sp
#define MBAPM_INSTRUCTION_ADDRESS __pc
#define MBAPM_NORMALISE_INSTRUCTION_VALUE 0x0000000fffffffff

#elif defined(__arm__)
#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(1UL))
#define MBAPM_THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
#define MBAPM_THREAD_STATE ARM_THREAD_STATE
#define MBAPM_FRAME_POINTER __r[7]
#define MBAPM_STACK_POINTER __sp
#define MBAPM_INSTRUCTION_ADDRESS __pc
#define MBAPM_NORMALISE_INSTRUCTION_VALUE 0xffffffffffffffff


#elif defined(__x86_64__)
#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define MBAPM_THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
#define MBAPM_THREAD_STATE x86_THREAD_STATE64
#define MBAPM_FRAME_POINTER __rbp
#define MBAPM_STACK_POINTER __rsp
#define MBAPM_INSTRUCTION_ADDRESS __rip
#define MBAPM_NORMALISE_INSTRUCTION_VALUE 0xffffffffffffffff

#elif defined(__i386__)
#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define MBAPM_THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
#define MBAPM_THREAD_STATE x86_THREAD_STATE32
#define MBAPM_FRAME_POINTER __ebp
#define MBAPM_STACK_POINTER __esp
#define MBAPM_INSTRUCTION_ADDRESS __eip
#define MBAPM_NORMALISE_INSTRUCTION_VALUE 0xffffffffffffffff

#endif

#define CALL_INSTRUCTION_FROM_RETURN_ADDRESS(A) (DETAG_INSTRUCTION_ADDRESS((A)) - 1)

#if defined(__LP64__)
#define TRACE_FMT         "%-4d%-31s 0x%016lx %s + %lu"
#define POINTER_FMT       "0x%016lx"
#define POINTER_SHORT_FMT "0x%lx"
#define MBAPM_NLIST struct nlist_64
#else
#define TRACE_FMT         "%-4d%-31s 0x%08lx %s + %lu"
#define POINTER_FMT       "0x%08lx"
#define POINTER_SHORT_FMT "0x%lx"
#define MBAPM_NLIST struct nlist
#endif

typedef struct MBAPMStackFrameEntry{
    const struct MBAPMStackFrameEntry *const previous;
    const uintptr_t return_address;
} MBAPMStackFrameEntry;

static mach_port_t main_thread_id;

@implementation MBAPMSymbolicatedBacktraceStack

@end

@implementation MBAPMStackImageInfo

@end

@implementation MBAPMBacktraceLogger

+ (void)load {
    main_thread_id = mach_thread_self();
}

#pragma -mark Implementation of interface
+ (NSString *)mbapm_backtraceOfNSThread:(NSThread *)thread {
    return _mbapm_backtraceOfNSThread(thread);
}

+ (NSString *)mbapm_backtraceOfCurrentThread {
    return _mbapm_backtraceOfNSThread([NSThread currentThread]);
}

+ (NSString *)mbapm_backtraceOfMainThread {
    return _mbapm_backtraceOfThread((thread_t)main_thread_id);
}

+ (MBThreadStackModel *)mbapm_backtraceOfThread:(thread_t)thread {
    return _mbapm_backtraceModelOfThread((thread_t)thread);
}

+ (MBAPMBacktraceStack *)mbapm_backtraceAddressOfMainThread {
    thread_t mainThread = (thread_t)main_thread_id;
    return mbapm_backtraceAddressesOfThread(mainThread);
}

+ (NSString *)mbapm_backtraceOfAllThread {
    thread_act_array_t threads;
    mach_msg_type_number_t thread_count = 0;
    const task_t this_task = mach_task_self();
    
    kern_return_t kr = task_threads(this_task, &threads, &thread_count);
    if(kr != KERN_SUCCESS) {
        return @"Fail to get information of all threads";
    }
    
    NSMutableString *resultString = [NSMutableString stringWithFormat:@"Call Backtrace of %u threads:\n", thread_count];
    for(int i = 0; i < thread_count; i++) {
        [resultString appendString:_mbapm_backtraceOfThread(threads[i])];
    }
    return [resultString copy];
}

+ (MBAPMSymbolicatedBacktraceStack *)mbapm_backtraceOfMainThreadWithStack:(MBAPMBacktraceStack *)stack {
    Dl_info symbolicatedBacktrace[stack->count];
    mbapm_symbolicate(stack->stack, symbolicatedBacktrace, (int)stack->count, 0);
    NSMutableString *resultString = [NSMutableString stringWithFormat:@"Call Backtrace of main thread:\n"];
    NSString *keyFunction = nil;
    NSString *mainImageName = [MBAPMBacktraceLogger getMainImageName];
    for (int i = 0; i < stack->count; ++i) {
        NSString *stackItem = [NSString stringWithFormat:@"%@", mbapm_logBacktraceEntry(i, stack->stack[i], &symbolicatedBacktrace[i])];
        if (!keyFunction && [stackItem containsString:mainImageName]) {
            keyFunction = stackItem;
        }
        [resultString appendFormat:@"%@", stackItem];
    }
    [resultString appendFormat:@"\n"];
    MBAPMSymbolicatedBacktraceStack *symbolicatedBacktraceStack = [[MBAPMSymbolicatedBacktraceStack alloc]init];
    symbolicatedBacktraceStack.wholeStack = resultString;
    symbolicatedBacktraceStack.keyFunction = keyFunction?:@"";
    return symbolicatedBacktraceStack;
}

#pragma -mark Get call backtrace of a mach_thread
NSString *_mbapm_backtraceOfNSThread(NSThread *thread) {
    return _mbapm_backtraceOfThread(mbapm_machThreadFromNSThread(thread));
}


NSString *_mbapm_backtraceOfThread(thread_t thread) {
    MBAPMBacktraceStack *backtraceStack = mbapm_backtraceAddressesOfThread(thread);
    if (backtraceStack->stack == NULL) {
        return @"";
    }
    if (backtraceStack->count == 0) {
        if (backtraceStack != NULL) {
            if(backtraceStack->stack != NULL) {
                free(backtraceStack->stack);
            }
            free(backtraceStack);
        }
    }
    NSMutableString *resultString = [[NSMutableString alloc] initWithFormat:@"Backtrace of Thread %u:\n", thread];
    int backtraceLength = (int)backtraceStack->count;
    Dl_info symbolicated[backtraceLength];
    mbapm_symbolicate(backtraceStack->stack, symbolicated, backtraceLength, 0);
   if (backtraceStack != NULL) {
        if(backtraceStack->stack != NULL) {
            free(backtraceStack->stack);
        }
        free(backtraceStack);
    }
    for (int i = 0; i < backtraceLength; ++i) {
        [resultString appendFormat:@"%@", mbapm_logBacktraceEntry(i, backtraceStack->stack[i], &symbolicated[i])];
    }
    [resultString appendFormat:@"\n"];
    return [resultString copy];
}

MBThreadStackModel *_mbapm_backtraceModelOfThread(thread_t thread) {
    
    MBThreadStackModel *model = [MBThreadStackModel new];
    
    uintptr_t backtraceBuffer[50];
    int i = 0;
    _STRUCT_MCONTEXT machineContext;
    if(!mbapm_fillThreadStateIntoMachineContext(thread, &machineContext)) {
        return model;
    }
    
    const uintptr_t instructionAddress = mbapm_mach_instructionAddress(&machineContext);
    backtraceBuffer[i] = instructionAddress;
    ++i;
    
    uintptr_t linkRegister = mbapm_mach_linkRegister(&machineContext);
    if (linkRegister) {
        backtraceBuffer[i] = linkRegister & MBAPM_NORMALISE_INSTRUCTION_VALUE;
        i++;
    }
    
    if(instructionAddress == 0) {
        mbapm_thread_resume(thread);
        return model;
    }
    
    MBAPMStackFrameEntry frame = {0};
    const uintptr_t framePtr = mbapm_mach_framePointer(&machineContext);
    if(framePtr == 0 ||
       mbapm_mach_copyMem((void *)framePtr, &frame, sizeof(frame)) != KERN_SUCCESS) {
        return model;
    }
    
    for(; i < 50; i++) {
        backtraceBuffer[i] = frame.return_address & MBAPM_NORMALISE_INSTRUCTION_VALUE;
        if(backtraceBuffer[i] == 0 ||
           frame.previous == 0 ||
           mbapm_mach_copyMem(frame.previous, &frame, sizeof(frame)) != KERN_SUCCESS) {
            break;
        }
    }

    int backtraceLength = i;
    Dl_info symbolicated[backtraceLength];
    mbapm_symbolicate(backtraceBuffer, symbolicated, backtraceLength, 0);

    MBThreadStackPerModel *curModel = nil;
//    NSLog(@"堆栈太少 backtraceLength:%d", backtraceLength);
    for (int i = backtraceLength - 1; i >= 0; i--) {
        MBThreadStackPerModel *perModel = mbapm_logBacktraceEntryModel(i, backtraceBuffer[i], &symbolicated[i]);
        perModel.level = backtraceLength - i;
        perModel.weight = 1;
        
        if (curModel) {
            perModel.superNode = curModel;
            curModel = perModel;
        } else {
            curModel = perModel;
            model.stackModel = curModel;
        }
        [model.stackPerModelArray addObject:curModel];
    }
    return model;
}

#pragma -mark Get backtrace stack addresses
MBAPMBacktraceStack* mbapm_backtraceAddressesOfThread(thread_t thread)
{
    MBAPMBacktraceStack *backtraceStack = NULL;
    size_t stackBytes = sizeof(uintptr_t) * 50;
    uintptr_t *backtraceBuffer = (uintptr_t *) malloc(stackBytes);
    if (backtraceBuffer == NULL) {
        return NULL;
    }
    memset(backtraceBuffer, 0, stackBytes);
    int i = 0;
    if (!mbapm_thread_suspend(thread)) {
        return backtraceStack;
    }
    
    _STRUCT_MCONTEXT machineContext;
    if(!mbapm_fillThreadStateIntoMachineContext(thread, &machineContext)) {
        mbapm_thread_resume(thread);
        return backtraceStack;
    }
    
    const uintptr_t instructionAddress = mbapm_mach_instructionAddress(&machineContext);
    backtraceBuffer[i] = instructionAddress;
    ++i;
    
    uintptr_t linkRegister = mbapm_mach_linkRegister(&machineContext);
    if (linkRegister) {
        backtraceBuffer[i] = linkRegister & MBAPM_NORMALISE_INSTRUCTION_VALUE;
        i++;
    }
    
    if(instructionAddress == 0) {
        mbapm_thread_resume(thread);
        return backtraceStack;
    }
    
    MBAPMStackFrameEntry frame = {0};
    const uintptr_t framePtr = mbapm_mach_framePointer(&machineContext);
    if(framePtr == 0 ||
       mbapm_mach_copyMem((void *)framePtr, &frame, sizeof(frame)) != KERN_SUCCESS) {
        mbapm_thread_resume(thread);
        return backtraceStack;
    }
    
    for(; i < 50; i++) {
        backtraceBuffer[i] = frame.return_address & MBAPM_NORMALISE_INSTRUCTION_VALUE;
        if(backtraceBuffer[i] == 0 ||
           frame.previous == 0 ||
           mbapm_mach_copyMem(frame.previous, &frame, sizeof(frame)) != KERN_SUCCESS) {
            break;
        }
    }
    backtraceStack = (MBAPMBacktraceStack *) malloc(sizeof(MBAPMBacktraceStack));
    backtraceStack->stack = backtraceBuffer;
    backtraceStack->count = i;
    mbapm_thread_resume(thread);
    return backtraceStack;
}

bool mbapm_thread_suspend(thread_t thread)
{
    if (thread_suspend(thread) != KERN_SUCCESS) {
        MBAPMDebug(@"suspend thread fail");
        return false;
    }
    return true;
}

bool mbapm_thread_resume(thread_t thread)
{
    if (thread_resume(thread) != KERN_SUCCESS) {
        MBAPMDebug(@"resume thread fail");
        return false;
    }
    return true;
}



#pragma -mark Convert NSThread to Mach thread
thread_t mbapm_machThreadFromNSThread(NSThread *nsthread) {
    char name[256];
    mach_msg_type_number_t count;
    thread_act_array_t list;
    task_threads(mach_task_self(), &list, &count);
    
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    NSString *originName = [nsthread name];
    [nsthread setName:[NSString stringWithFormat:@"%f", currentTimestamp]];
    
    if ([nsthread isMainThread]) {
        return (thread_t)main_thread_id;
    }
    
    for (int i = 0; i < count; ++i) {
        pthread_t pt = pthread_from_mach_thread_np(list[i]);
        if ([nsthread isMainThread]) {
            if (list[i] == main_thread_id) {
                return list[i];
            }
        }
        if (pt) {
            name[0] = '\0';
            pthread_getname_np(pt, name, sizeof name);
            if (!strcmp(name, [nsthread name].UTF8String)) {
                [nsthread setName:originName];
                return list[i];
            }
        }
    }
    
    [nsthread setName:originName];
    return mach_thread_self();
}

#pragma -mark GenerateBacbsrackEnrty
NSString* mbapm_logBacktraceEntry(const int entryNum,
                                  const uintptr_t address,
                                  const Dl_info* const dlInfo) {
    char faddrBuff[20];
    char saddrBuff[20];
    
    const char* fname = mbapm_lastPathEntry(dlInfo->dli_fname);
    if(fname == NULL) {
        sprintf(faddrBuff, POINTER_FMT, (uintptr_t)dlInfo->dli_fbase);
        fname = faddrBuff;
    }
    
    uintptr_t offset = address - (uintptr_t)dlInfo->dli_saddr;
    const char* sname = dlInfo->dli_sname;
    if(sname == NULL) {
        sprintf(saddrBuff, POINTER_SHORT_FMT, (uintptr_t)dlInfo->dli_fbase);
        sname = saddrBuff;
        offset = address - (uintptr_t)dlInfo->dli_fbase;
    }
    return [NSString stringWithFormat:@"%-30s  0x%08" PRIxPTR " 0x%lx + %lu\n" ,fname, (uintptr_t)address, (uintptr_t)dlInfo->dli_fbase, offset];
}

MBThreadStackPerModel* mbapm_logBacktraceEntryModel(const int entryNum,
                                  const uintptr_t address,
                                  const Dl_info* const dlInfo) {
    MBThreadStackPerModel *model = [[MBThreadStackPerModel alloc] init];
    char faddrBuff[20];
    char saddrBuff[20];

    const char* fname = mbapm_lastPathEntry(dlInfo->dli_fname);
    if(fname == NULL) {
        sprintf(faddrBuff, POINTER_FMT, (uintptr_t)dlInfo->dli_fbase);
        fname = faddrBuff;
    }

    uintptr_t offset = address - (uintptr_t)dlInfo->dli_saddr;
    const char* sname = dlInfo->dli_sname;
    if(sname == NULL) {
        sprintf(saddrBuff, POINTER_SHORT_FMT, (uintptr_t)dlInfo->dli_fbase);
        sname = saddrBuff;
        offset = address - (uintptr_t)dlInfo->dli_fbase;
    }
//    model.fname = [NSString stringWithFormat:@"%s", fname];
//    model.address = address;
//    model.sAddress = (uintptr_t)dlInfo->dli_fbase;
//    model.sname = [NSString stringWithFormat:@"%s", sname];
//    model.offset = offset;
    model.stack = [NSString stringWithFormat:@"%s 0x%08" PRIxPTR " 0x%lx + %lu", fname, address, (uintptr_t)dlInfo->dli_fbase, address - (uintptr_t)dlInfo->dli_fbase];
    return model;
}

const char* mbapm_lastPathEntry(const char* const path) {
    if(path == NULL) {
        return NULL;
    }
    
    char* lastFile = strrchr(path, '/');
    return lastFile == NULL ? path : lastFile + 1;
}

#pragma -mark HandleMachineContext
bool mbapm_fillThreadStateIntoMachineContext(thread_t thread, _STRUCT_MCONTEXT *machineContext) {
    mach_msg_type_number_t state_count = MBAPM_THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(thread, MBAPM_THREAD_STATE, (thread_state_t)&machineContext->__ss, &state_count);
    return (kr == KERN_SUCCESS);
}

uintptr_t mbapm_mach_framePointer(mcontext_t const machineContext){
    return machineContext->__ss.MBAPM_FRAME_POINTER;
}

uintptr_t mbapm_mach_stackPointer(mcontext_t const machineContext){
    return machineContext->__ss.MBAPM_STACK_POINTER;
}

uintptr_t mbapm_mach_instructionAddress(mcontext_t const machineContext){
    return machineContext->__ss.MBAPM_INSTRUCTION_ADDRESS & MBAPM_NORMALISE_INSTRUCTION_VALUE;
}

uintptr_t mbapm_mach_linkRegister(mcontext_t const machineContext){
#if defined(__i386__) || defined(__x86_64__)
    return 0;
#else
    return machineContext->__ss.__lr;
#endif
}

kern_return_t mbapm_mach_copyMem(const void *const src, void *const dst, const size_t numBytes){
    vm_size_t bytesCopied = 0;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)numBytes, (vm_address_t)dst, &bytesCopied);
}

#pragma -mark Symbolicate
void mbapm_symbolicate(const uintptr_t* const backtraceBuffer,
                       Dl_info* const symbolsBuffer,
                       const int numEntries,
                       const int skippedEntries){
    int i = 0;
    
    if(!skippedEntries && i < numEntries) {
        mbapm_dladdr(backtraceBuffer[i], &symbolsBuffer[i]);
        i++;
    }
    
    for(; i < numEntries; i++) {
        mbapm_dladdr(CALL_INSTRUCTION_FROM_RETURN_ADDRESS(backtraceBuffer[i]), &symbolsBuffer[i]);
    }
}

bool mbapm_dladdr(const uintptr_t address, Dl_info* const info) {
    info->dli_fname = NULL;
    info->dli_fbase = NULL;
    info->dli_sname = NULL;
    info->dli_saddr = NULL;
    const uint32_t idx = mbapm_imageIndexContainingAddress(address);
    if(idx == UINT_MAX) {
        return false;
    }
    const struct mach_header* header = _dyld_get_image_header(idx);
    info->dli_fname = _dyld_get_image_name(idx);
    info->dli_fbase = (void*)header;

    const uintptr_t imageVMAddrSlide = (uintptr_t)_dyld_get_image_vmaddr_slide(idx);
    const uintptr_t addressWithSlide = address - imageVMAddrSlide;
    const uintptr_t segmentBase = mbapm_segmentBaseOfImageIndex(idx) + imageVMAddrSlide;
    if(segmentBase == 0) {
        return false;
    }
    // Find symbol tables and get whichever symbol is closest to the address.
    const MBAPM_NLIST* bestMatch = NULL;
    uintptr_t bestDistance = ULONG_MAX;
    uintptr_t cmdPtr = mbapm_firstCmdAfterHeader(header);
    if(cmdPtr == 0) {
        return false;
    }
    for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if(loadCmd->cmd == LC_SYMTAB) {
            const struct symtab_command* symtabCmd = (struct symtab_command*)cmdPtr;
            const MBAPM_NLIST* symbolTable = (MBAPM_NLIST*)(segmentBase + symtabCmd->symoff);
            const uintptr_t stringTable = segmentBase + symtabCmd->stroff;
            
            for(uint32_t iSym = 0; iSym < symtabCmd->nsyms; iSym++) {
                // If n_value is 0, the symbol refers to an external object.
                if(symbolTable[iSym].n_value != 0) {
                    uintptr_t symbolBase = symbolTable[iSym].n_value;
                    uintptr_t currentDistance = addressWithSlide - symbolBase;
                    if((addressWithSlide >= symbolBase) &&
                       (currentDistance <= bestDistance)) {
                        bestMatch = symbolTable + iSym;
                        bestDistance = currentDistance;
                    }
                }
            }
            if(bestMatch != NULL) {
                info->dli_saddr = (void*)(bestMatch->n_value + imageVMAddrSlide);
                info->dli_sname = (char*)((intptr_t)stringTable + (intptr_t)bestMatch->n_un.n_strx);
                if(*info->dli_sname == '_') {
                    info->dli_sname++;
                }
                // This happens if all symbols have been stripped.
                if(info->dli_saddr == info->dli_fbase && bestMatch->n_type == 3) {
                    info->dli_sname = NULL;
                }
                break;
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return true;
}

uintptr_t mbapm_firstCmdAfterHeader(const struct mach_header* const header) {
    switch(header->magic) {
        case MH_MAGIC:
        case MH_CIGAM:
            return (uintptr_t)(header + 1);
        case MH_MAGIC_64:
        case MH_CIGAM_64:
            return (uintptr_t)(((struct mach_header_64*)header) + 1);
        default:
            return 0;  // Header is corrupt
    }
}

+ (MBAPMStackImageInfo *_Nullable)mbapm_imageInfoFromStackAddress:(unsigned long)stackAddress {
    uint32_t index = mbapm_imageIndexContainingAddress(stackAddress);
    if (index == UINT_MAX) {
        return nil;
    }
    // name
    const char *name = _dyld_get_image_name(index);
    NSString *imagePath = [NSString stringWithUTF8String:name];
    NSArray *imagePathStrArray = [imagePath componentsSeparatedByString:@"/"];
    NSString *imageName = [imagePathStrArray lastObject];
    if (!imageName) {
        return nil;
    }
    // adress
    const struct mach_header* header = _dyld_get_image_header((unsigned)index);
    
    MBAPMStackImageInfo *info = [[MBAPMStackImageInfo alloc] init];
    info.imageAddress = (mach_vm_address_t)header;
    info.imageName = imageName;
    info.instructionAddr = stackAddress;
    return info;
}

uint32_t mbapm_imageIndexContainingAddress(const uintptr_t address) {
    const uint32_t imageCount = _dyld_image_count();
    const struct mach_header* header = 0;
    
    for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
        header = _dyld_get_image_header(iImg);
        if(header != NULL) {
            // Look for a segment command with this address within its range.
            uintptr_t addressWSlide = address - (uintptr_t)_dyld_get_image_vmaddr_slide(iImg);
            uintptr_t cmdPtr = mbapm_firstCmdAfterHeader(header);
            if(cmdPtr == 0) {
                continue;
            }
            for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
                const struct load_command* loadCmd = (struct load_command*)cmdPtr;
                if(loadCmd->cmd == LC_SEGMENT) {
                    const struct segment_command* segCmd = (struct segment_command*)cmdPtr;
                    if(addressWSlide >= segCmd->vmaddr &&
                       addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                    
                }
                else if(loadCmd->cmd == LC_SEGMENT_64) {
                    const struct segment_command_64* segCmd = (struct segment_command_64*)cmdPtr;
                    if(addressWSlide >= segCmd->vmaddr &&
                       addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                cmdPtr += loadCmd->cmdsize;
            }
        }
    }
    return UINT_MAX;
}

uintptr_t mbapm_segmentBaseOfImageIndex(const uint32_t idx) {
    const struct mach_header* header = _dyld_get_image_header(idx);
    
    // Look for a segment command and return the file image address.
    uintptr_t cmdPtr = mbapm_firstCmdAfterHeader(header);
    if(cmdPtr == 0) {
        return 0;
    }
    for(uint32_t i = 0;i < header->ncmds; i++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if(loadCmd->cmd == LC_SEGMENT) {
            const struct segment_command* segmentCmd = (struct segment_command*)cmdPtr;
            if(strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return segmentCmd->vmaddr - segmentCmd->fileoff;
            }
        }
        else if(loadCmd->cmd == LC_SEGMENT_64) {
            const struct segment_command_64* segmentCmd = (struct segment_command_64*)cmdPtr;
            if(strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return (uintptr_t)(segmentCmd->vmaddr - segmentCmd->fileoff);
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return 0;
}

+ (NSString *)getMainImageName {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSDictionary* infoDict = [mainBundle infoDictionary];
    NSString* executableName = infoDict[@"CFBundleExecutable"];
    return executableName;
}

@end
