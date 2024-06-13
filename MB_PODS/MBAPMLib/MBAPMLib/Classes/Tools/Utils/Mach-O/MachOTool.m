//
//  MachOTool.m
//  MBAPMLib
//
//  Created by xp on 2021/7/19.
//

#import "MachOTool.h"
#import "MBAPMLogDef.h"
#import <mach/mach.h>
#import <mach/vm_map.h>
#import <mach-o/loader.h>
#import <mach-o/fat.h>
#import <mach-o/dyld.h>
#import "MBAPMSymbolDefines.h"
#import "MBAPMLogDef.h"


@implementation MachOTool

+ (void)readAllClassesAndCategories {
    uintptr_t imageVMAddrSlide = 0;
    const uint32_t imageCount = _dyld_image_count();
    uint32_t mainImageIndex = -1;
    NSString *mainImagePath = getExecutablePath();
    MBAPMDebug(@"mainImagePath : %@", mainImagePath);
    for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
        const char *name = _dyld_get_image_name(iImg);
        NSString *imageName = [NSString stringWithUTF8String:name];
        MBAPMDebug(@"imageName : %@", imageName);
        if([imageName containsString: mainImagePath]) {
            mainImageIndex = iImg;
            break;
        }
    }
    MBAPMDebug(@"mainImageIndex = %d", mainImageIndex);
    if (mainImageIndex == -1) {
        return;
    }
    imageVMAddrSlide = (uintptr_t)_dyld_get_image_vmaddr_slide(mainImageIndex);
    MBAPMDebug(@"find image name = %@, imageVMAddrSlide=%ld", mainImagePath, imageVMAddrSlide);
    const struct mach_header* mach_header = _dyld_get_image_header(mainImageIndex);
    uintptr_t cmdPtr = mbapm_getfirstCmdAfterHeader(mach_header);
    if(cmdPtr == 0) {
        MBAPMError(@"mach_header is invalid");
        return;
    }
    struct section_64 *classList = nil, *nlcatList= nil;
    for (int i = 0; i < mach_header->ncmds; i++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if (loadCmd->cmd == LC_SEGMENT_64) {
            struct segment_command_64 *segmentCommand = (struct segment_command_64 *)cmdPtr;
            NSString *segName = [NSString stringWithFormat:@"%s",segmentCommand->segname];
            //遍历查找classlist
            if ([segName isEqualToString:SEGMENT_DATA] ||
                [segName isEqualToString:SEGMENT_DATA_CONST]) {
                //遍历所有的section header
                uintptr_t sectionPtr = (uintptr_t)(segmentCommand+1);
                for (int j = 0; j < segmentCommand->nsects; j++) {
                    struct section_64 *sectionHeader = (struct section_64 *)sectionPtr;
                    NSString *secName = [[NSString alloc] initWithUTF8String:sectionHeader->sectname];
                    MBAPMDebug(@"sectionName = %@", secName);
                    if ([secName isEqualToString:DATA_CLASSLIST_SECTION] ||
                        [secName isEqualToString:CONST_DATA_CLASSLIST_SECTION]) {
                        classList = sectionHeader;
                    }
                    if ([secName isEqualToString:DATA_CATLIST_SECTION]) {
                        nlcatList = sectionHeader;
                    }
                    sectionPtr += sizeof(struct section_64);
                }
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    if (classList == nil) {
        MBAPMError(@"class list can't be found");
        return;
    }
    if (nlcatList == nil) {
        MBAPMError(@"nlcatlist can't be found");
        return;
    }
    MBAPMDebug(@"find class count = %llu", classList->size/8);
    for (int i = 0; i < classList->size / 8 ; i++) {
        MBAPMDebug(@"find class index = %d", i);
        @autoreleasepool {
            const uintptr_t classAddress = classList->addr + imageVMAddrSlide + 8*i;
            unsigned long long *classAddressValue = (unsigned long long *) malloc(8);
            memset(classAddressValue, 0, 8);
            kern_return_t result =  mbapm_parser_mach_copyMem((void *)classAddress, classAddressValue, 8);
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get class address fails");
                free(classAddressValue);
                return;
            }
            MBAPMDebug(@"class address=%llu", *classAddressValue);
            unsigned long long targetClassAddress = *classAddressValue;
            struct class64 *targetClass = (struct class64 *)malloc(sizeof(struct class64));
            memset(targetClass, 0, sizeof(struct class64));
            result = mbapm_parser_mach_copyMem((void *)targetClassAddress, targetClass, sizeof(struct class64));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get target class fails");
                free(classAddressValue);
                free(targetClass);
                return;
            }
            MBAPMDebug(@"target class isa=%llu", targetClass->isa);
            unsigned long long targetClassInfoAddress = (targetClass->data/8)*8;
            struct class64Info *targetClassInfo = (struct class64Info *)malloc(sizeof(struct class64Info));
            memset(targetClassInfo, 0, sizeof(struct class64Info));
            result = mbapm_parser_mach_copyMem((void *)targetClassInfoAddress, targetClassInfo, sizeof(struct class64Info));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get target class info fails");
                free(classAddressValue);
                free(targetClass);
                free(targetClassInfo);
                return;
            }
            MBAPMDebug(@"target class info name=%llu", targetClassInfo->name);
            struct class64 *metaClass = (struct class64 *)malloc(sizeof(struct class64));
            memset(metaClass, 0, sizeof(struct class64));
            result = mbapm_parser_mach_copyMem((void *)targetClass->isa, metaClass, sizeof(struct class64));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get target meta class fails");
                free(classAddressValue);
                free(targetClass);
                free(targetClassInfo);
                free(metaClass);
                return;
            }
            MBAPMDebug(@"target meta class info address=%llu", metaClass->data);
            unsigned long long metaClassInfoAddress = (metaClass->data/8)*8;
            struct class64Info *metaClassInfo = (struct class64Info *)malloc(sizeof(struct class64Info));
            memset(metaClassInfo, 0, sizeof(struct class64Info));
            result = mbapm_parser_mach_copyMem((void *)metaClassInfoAddress, metaClassInfo, sizeof(struct class64Info));
            
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get target meta class info fails");
                free(classAddressValue);
                free(targetClass);
                free(targetClassInfo);
                free(metaClass);
                free(metaClassInfo);
                return;
            }
            
//            unsigned long long methodListOffset = targetClassInfo->baseMethods;
            unsigned long long classMethodListOffset = metaClassInfo->baseMethods;
            
            MBAPMDebug(@"class method list offset=%lld", classMethodListOffset);

            //类名最大50字节
            uint8_t * buffer = (uint8_t *)malloc(CLASSNAME_MAX_LEN + 1); buffer[CLASSNAME_MAX_LEN] = '\0';
            result = mbapm_parser_mach_copyMem((void *)targetClassInfo->name, buffer, CLASSNAME_MAX_LEN);
            NSString * className = NSSTRING(buffer);
            MBAPMDebug(@"get target class name = %@", className);
            //释放分配的内存
            free(buffer);
            free(classAddressValue);
            free(targetClass);
            free(targetClassInfo);
            free(metaClass);
            free(metaClassInfo);
        }
    }
    MBAPMDebug(@"find category count = %llu", nlcatList->size/8);
    for (int i = 0; i < nlcatList->size / 8 ; i++) {
        MBAPMDebug(@"find categor index = %d", i);
        @autoreleasepool {
            const uintptr_t categoryAddress = nlcatList->addr + imageVMAddrSlide + 8*i;
            MBAPMDebug(@"category address=%lu", categoryAddress);
            unsigned long long *categoryAddressValue = (unsigned long long *) malloc(8);
            memset(categoryAddressValue, 0, 8);
            kern_return_t result =  mbapm_parser_mach_copyMem((void *)categoryAddress, categoryAddressValue, 8);
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get class address fails");
                free(categoryAddressValue);
                return;
            }
            MBAPMDebug(@"category address value=%llu", *categoryAddressValue);
            struct category64 *targetCategory = (struct category64 *)malloc(sizeof(struct category64));
            memset(targetCategory, 0, sizeof(struct category64));
            result = mbapm_parser_mach_copyMem((void *)categoryAddressValue, targetCategory, sizeof(struct category64));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"get target category fails");
                free(categoryAddressValue);
                free(targetCategory);
                return;
            }
            MBAPMDebug(@"category class address = %llu", targetCategory->cls);
            if (targetCategory->cls == 0) {
                free(categoryAddressValue);
                free(targetCategory);
                continue;
            }
            
            unsigned long long targetClassAddress = (targetCategory->cls/8)*8;
            struct class64 *targetClass = (struct class64 *)malloc(sizeof(struct class64));
            memset(targetClass, 0, sizeof(struct class64));
            result = mbapm_parser_mach_copyMem((void *)targetClassAddress, targetClass, sizeof(struct class64));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"category get target class fails");
                free(categoryAddressValue);
                free(targetCategory);
                free(targetClass);
                return;
            }
            MBAPMDebug(@"category target class isa=%llu", targetClass->isa);
            unsigned long long targetClassInfoAddress = (targetClass->data/8)*8;
            struct class64Info *targetClassInfo = (struct class64Info *)malloc(sizeof(struct class64Info));
            memset(targetClassInfo, 0, sizeof(struct class64Info));
            result = mbapm_parser_mach_copyMem((void *)targetClassInfoAddress, targetClassInfo, sizeof(struct class64Info));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"category get target class info fails");
                free(categoryAddressValue);
                free(targetCategory);
                free(targetClass);
                free(targetClassInfo);
                return;
            }
            MBAPMDebug(@"category target class info name=%llu", targetClassInfo->name);
            struct class64 *metaClass = (struct class64 *)malloc(sizeof(struct class64));
            memset(metaClass, 0, sizeof(struct class64));
            result = mbapm_parser_mach_copyMem((void *)targetClass->isa, metaClass, sizeof(struct class64));
            if (result != KERN_SUCCESS) {
                MBAPMError(@"category get target meta class fails");
                free(categoryAddressValue);
                free(targetCategory);
                free(targetClass);
                free(targetClassInfo);
                free(metaClass);
                return;
            }
            MBAPMDebug(@"category target meta class info address=%llu", metaClass->data);
            unsigned long long metaClassInfoAddress = (metaClass->data/8)*8;
            struct class64Info *metaClassInfo = (struct class64Info *)malloc(sizeof(struct class64Info));
            memset(metaClassInfo, 0, sizeof(struct class64Info));
            result = mbapm_parser_mach_copyMem((void *)metaClassInfoAddress, metaClassInfo, sizeof(struct class64Info));
            
            if (result != KERN_SUCCESS) {
                MBAPMError(@"category get target meta class info fails");
                free(categoryAddressValue);
                free(targetCategory);
                free(targetClass);
                free(targetClassInfo);
                free(metaClass);
                free(metaClassInfo);
                return;
            }
            
//            unsigned long long methodListOffset = targetClassInfo->baseMethods;
            unsigned long long classMethodListOffset = metaClassInfo->baseMethods;
            
            MBAPMDebug(@"category class method list offset=%lld", classMethodListOffset);

            //类名最大50字节
            uint8_t * buffer = (uint8_t *)malloc(CLASSNAME_MAX_LEN + 1); buffer[CLASSNAME_MAX_LEN] = '\0';
            result = mbapm_parser_mach_copyMem((void *)targetClassInfo->name, buffer, CLASSNAME_MAX_LEN);
            NSString * className = NSSTRING(buffer);
            MBAPMDebug(@"category get target class name = %@", className);
            //释放分配的内存
            free(buffer);
            free(categoryAddressValue);
            free(targetCategory);
            free(targetClass);
            free(targetClassInfo);
            free(metaClass);
            free(metaClassInfo);
            
            
            

//            //类名最大50字节
//            uint8_t * buffer = (uint8_t *)malloc(CLASSNAME_MAX_LEN + 1); buffer[CLASSNAME_MAX_LEN] = '\0';
//            result = mbapm_parser_mach_copyMem((void *)targetCategory->name, buffer, CLASSNAME_MAX_LEN);
//            NSString * categoryName = NSSTRING(buffer);
//            MBAPMDebug(@"get category class name = %@", categoryName);
//            //释放分配的内存
//            free(buffer);
        }
    }
    
}

uintptr_t mbapm_getfirstCmdAfterHeader(const struct mach_header* const header) {
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

kern_return_t mbapm_parser_mach_copyMem(const void *const src, void *const dst, const size_t numBytes){
    vm_size_t bytesCopied = 0;
    kern_return_t result = vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)numBytes, (vm_address_t)dst, &bytesCopied);
    return result;
}

static NSString* getExecutablePath() {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSDictionary* infoDict = [mainBundle infoDictionary];
    NSString* bundlePath = [mainBundle bundlePath];
    NSString* executableName = infoDict[@"CFBundleExecutable"];
    return [bundlePath stringByAppendingPathComponent:executableName];
}

@end
