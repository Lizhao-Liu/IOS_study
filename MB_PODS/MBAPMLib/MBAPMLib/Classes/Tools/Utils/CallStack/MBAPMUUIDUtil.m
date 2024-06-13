//
//  MBAPMUUIDUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/11/2.
//

#import "MBAPMUUIDUtil.h"
#import <mach-o/ldsyms.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

typedef struct {
    uint64_t address;
    uint64_t vmAddress;
    uint64_t size;
    const char *name;
    const uint8_t *uuid;
    int cpuType;
    int cpuSubType;
    uint64_t majorVersion;
    uint64_t minorVersion;
    uint64_t revisionVersion;
} MBAPMBinaryImage;

@implementation MBAPMUUIDUtil

static NSString *mainImageUUID = nil;
static NSString *mainBundlePath = nil;


#pragma mark - public methods

+ (NSString *)getCurrentImageUUID {
    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
        if (((const struct load_command *)command)->cmd == LC_UUID) {
            command += sizeof(struct load_command);
            NSLog(@"%@ end", NSStringFromSelector(_cmd));
            return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X", command[0], command[1], command[2], command[3],
                    command[4], command[5],
                    command[6], command[7],
                    command[8], command[9],
                    command[10], command[11], command[12], command[13], command[14], command[15]];
        } else {
            command += ((const struct load_command *)command)->cmdsize;
        }
    }
    return nil;
}

+ (NSString *)getMainImageUUID {
    if(!mainImageUUID || [mainImageUUID isEqualToString:@""]) {
        uint32_t mainImageIndex = getMainImage();
        if(mainImageIndex == -1) {
            return nil;
        }
        NSString *mainImageUUID = getBinaryImageUUID(mainImageIndex);
        return mainImageUUID;
    } else {
        return mainImageUUID;
    }
}

+ (NSDictionary *)getAllImageUUIDs {
    NSMutableDictionary<NSString *, NSString *> *uuidDic = [NSMutableDictionary new];
    const uint32_t imageCount = _dyld_image_count();
    for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
        const char *name = _dyld_get_image_name(iImg);
        NSString *imageName = [NSString stringWithUTF8String:name];
        NSString *uuid = getBinaryImageUUID(iImg);
        if(imageName && uuid) {
            [uuidDic setObject:imageName forKey:uuid];
        }
    }
    return [uuidDic copy];
}

+ (NSArray<NSDictionary<NSString *, NSString *> *> *)getUnsystemImageUUIDs {
    static NSMutableArray<NSDictionary<NSString *, NSString *> *> *unsystemImageUUIDs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsystemImageUUIDs = [NSMutableArray<NSDictionary<NSString *, NSString *> *> new];
        const uint32_t imageCount = _dyld_image_count();
        NSMutableDictionary<NSString *, NSString *> *versions = [NSMutableDictionary new];
        NSMutableDictionary<NSString *, NSString *> *identifiers = [NSMutableDictionary new];
        for (NSBundle *bundle in [NSBundle allFrameworks]) {
            NSString * bundleIdentifier = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
            if (!bundleIdentifier || [bundleIdentifier containsString:@"com.apple."]) {
                continue;
            }
            NSString * displayName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
            NSString * shortVersionString = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            if (!displayName || !shortVersionString || !bundleIdentifier) {
                continue;
            }
            [versions setObject:shortVersionString forKey:displayName];
            [identifiers setObject:bundleIdentifier forKey:displayName];
        }
        for (NSBundle *bundle in [NSBundle allBundles]) {
            NSString * bundleIdentifier = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
            if (!bundleIdentifier || [bundleIdentifier containsString:@"com.apple."]) {
                continue;
            }
            NSString * displayName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
            NSString * shortVersionString = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            if (!displayName || !shortVersionString || !bundleIdentifier) {
                continue;
            }
            [versions setObject:shortVersionString forKey:displayName];
            [identifiers setObject:bundleIdentifier forKey:displayName];
            
            if ([bundle isEqual:[NSBundle mainBundle]]) {
                NSString *bundleVersion = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
                if (bundleVersion && bundleVersion.length > 0) {
                    NSString *fullVersion = [NSString stringWithFormat:@"%@.%@", shortVersionString, bundleVersion];
                    [versions setObject:fullVersion forKey:displayName];
                }
                
                // identifier: 需要从main bundle 拿取项目真实的identifier， 具体参考/MBProjectConfig/MBProjectConfig/Classes/MBProjectConfig.m
                NSDictionary *configData = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MBProjectConfig"];
                NSString *realAppBundleId = [configData objectForKey:@"AppBundleId"];
                if (realAppBundleId && realAppBundleId.length > 0) {
                    [identifiers setObject:realAppBundleId forKey:displayName];
                }
            }
        }
        
        for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
            const char *name = _dyld_get_image_name(iImg);
            NSString *imagePath = [NSString stringWithUTF8String:name];
            if (![imagePath hasPrefix:getMainBundlePath()]) {
                continue;
            }
            NSString *imageName = nil;
            NSArray *imagePathStrArray = [imagePath componentsSeparatedByString:@"/"];
            if (imagePathStrArray > 0) {
                imageName = imagePathStrArray[imagePathStrArray.count - 1];
            }
            if (!imageName) {
                continue;
            }
            NSString *imageVersion = nil;
            if (![versions.allKeys containsObject:imageName]) {
                return;
            }
            imageVersion = versions[imageName];
            NSString *imageIdentifier = identifiers[imageName];
            NSString *uuid = getBinaryImageUUID(iImg);
            if(imageName && imageName.length > 0 && imageVersion && imageVersion.length > 0 && uuid && uuid.length > 0) {
                uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
                uuid = [uuid lowercaseString];
                NSDictionary<NSString *, NSString *> *uuidDic = @{@"name":imageIdentifier,@"version":imageVersion,@"uuid":uuid,@"type": @"native"};
                [unsystemImageUUIDs addObject:uuidDic];
            }
        }
    });
    return [unsystemImageUUIDs copy];
}

+ (NSArray<NSDictionary<NSString *, NSString *> *> *)getUnsystemImageInfos {
    static NSMutableArray<NSDictionary<NSString *, NSString *> *> *unsystemImageUUIDs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsystemImageUUIDs = [NSMutableArray<NSDictionary<NSString *, NSString *> *> new];
        const uint32_t imageCount = _dyld_image_count();
        
        for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
            MBAPMBinaryImage image = { 0 };
            if (!mbapm_getBinaryImage(iImg, &image)) {
                continue;;
            }
            if (image.name == NULL) {
                image.name = "";
            }
            NSString *imageName = [NSString stringWithUTF8String:image.name == NULL?image.name:""];
            const char *uuidChars = uuidBytesToString(image.uuid);
            NSString *uuid = [NSString stringWithUTF8String:uuidChars];
            if(imageName && imageName.length > 0 && uuid && uuid.length > 0) {
                uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
                uuid = [uuid lowercaseString];
                NSDictionary<NSString *, NSString *> *uuidDic = @{@"name":imageName,@"version":@"1.0",@"uuid":uuid,@"type": @"native"};
                [unsystemImageUUIDs addObject:uuidDic];
            }
        }
    });
    return [unsystemImageUUIDs copy];
}

+ (NSString *)getBinaryImagesDescription {
    static NSMutableString *binaryImagesDescription;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        binaryImagesDescription = [[NSMutableString alloc] initWithString:@"Binary Images:\n"];
        const uint32_t imageCount = _dyld_image_count();
        NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
        
        for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
            const char *name = _dyld_get_image_name(iImg);
            NSString *imagePath = [NSString stringWithUTF8String:name];
            NSArray *imagePathStrArray = [imagePath componentsSeparatedByString:@"/"];
            NSString *imageName = [imagePathStrArray lastObject];
            if (!imageName) {
                continue;
            }
            NSString *baseAddress = getBinaryImageLoadAddress(iImg);
//            NSString *endAddress = getBinaryImageEndAddress(iImg);
            NSString *cpuType = getBinaryImageLoadCpuType(iImg);
            NSString *uuid = getBinaryImageUUID(iImg);
            uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
            uuid = [uuid lowercaseString];
            
            NSString *oneBinaryDescription = [NSString stringWithFormat:@"%@ - %@ %@ %@  <%@> /placeholder/path", baseAddress, @"111111fff", imageName, cpuType, uuid];
            [array addObject:oneBinaryDescription];
        }
        NSArray * sortedKey = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        [binaryImagesDescription appendString:[sortedKey componentsJoinedByString:@"\n"]];
        [binaryImagesDescription appendString:@"\n\nEOF"];
    });
    
    return [binaryImagesDescription copy];
}

+ (NSString *)getMainImageName {
    static NSString *mainImageName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle* mainBundle = [NSBundle mainBundle];
        NSDictionary* infoDict = [mainBundle infoDictionary];
        NSString* executableName = infoDict[@"CFBundleExecutable"];
        mainImageName = executableName;
    });
    return mainImageName;
}

#pragma mark - private methods

// 获取主 image 的路径
static NSString* getExecutablePath() {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSDictionary* infoDict = [mainBundle infoDictionary];
    NSString* bundlePath = [mainBundle bundlePath];
    NSString* executableName = infoDict[@"CFBundleExecutable"];
    return [bundlePath stringByAppendingPathComponent:executableName];
}

static NSString* getMainBundlePath() {
    if (!mainBundlePath || [mainBundlePath isEqualToString:@""]) {
        NSBundle* mainBundle = [NSBundle mainBundle];
        return [mainBundle bundlePath];
    }
    return mainBundlePath;
}

static uint32_t getMainImage() {
    const uint32_t imageCount = _dyld_image_count();
    NSString *mainImagePath = getExecutablePath();
    for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
        const char *name = _dyld_get_image_name(iImg);
        NSString *imageName = [NSString stringWithUTF8String:name];
        if([imageName isEqualToString: mainImagePath]) {
            return iImg;
        }
    }
    return -1;
}

NSString* getBinaryImageLoadAddress(int index) {
    const struct mach_header* header = _dyld_get_image_header((unsigned)index);
    return [NSString stringWithFormat:@"0x%llx", (mach_vm_address_t)header];
}

//NSString* getBinaryImageEndAddress(int index) {
//    const struct mach_header* header = 0;
//    uintptr_t addressWSlide = 0;
//    header = _dyld_get_image_header(index);
//    if(header != NULL) {
//        uintptr_t cmdPtr = firstCmdAfterHeader(header);
//        for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
//            const struct load_command* loadCmd = (struct load_command*)cmdPtr;
//            if(loadCmd->cmd == LC_SEGMENT) {
//                const struct segment_command* segCmd = (struct segment_command*)cmdPtr;
//                addressWSlide = segCmd->vmaddr + segCmd->vmsize;
//            }
//            else if(loadCmd->cmd == LC_SEGMENT_64) {
//                const struct segment_command_64* segCmd = (struct segment_command_64*)cmdPtr;
//                addressWSlide = segCmd->vmaddr + segCmd->vmsize;
//            }
//            cmdPtr += loadCmd->cmdsize;
//        }
//    }
//    return [NSString stringWithFormat:@"0x%llx", (mach_vm_address_t)addressWSlide];
//}

NSString* getBinaryImageLoadCpuType(int index) {
    const struct mach_header* header = _dyld_get_image_header((unsigned)index);
    
    if (header->cputype == CPU_TYPE_ARM64) {
        if (header->cpusubtype == CPU_SUBTYPE_ARM64_V8) {
            return @"arm64-v8";
        } else if (header->cpusubtype == CPU_SUBTYPE_ARM64E) {
            return @"arm64e";
        } else {
            return @"arm64";
        }
    } else if (header->cputype == CPU_TYPE_ARM) {
        if (header->cpusubtype == CPU_SUBTYPE_ARM_V7) {
            return @"armv7";
        } else if (header->cpusubtype == CPU_SUBTYPE_ARM_V7S) {
            return @"armv7s";
        }
    } else if (header->cputype == CPU_TYPE_X86 || header->cputype == CPU_TYPE_I386) {
        return @"x86_64";
    }
    return [NSString stringWithFormat:@"%d_%d", header->cputype, header->cpusubtype];
}

NSString* getBinaryImageUUID(int index) {
    const struct mach_header* header = _dyld_get_image_header((unsigned)index);
    if(header == NULL) {
        return nil;
    }
    uintptr_t cmdPtr = firstCmdAfterHeader(header);
    if(cmdPtr == 0) {
        return nil;
    }
    
    uint8_t* uuid = NULL;
    
    for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++)
    {
        struct load_command* loadCmd = (struct load_command*)cmdPtr;
        
        if (loadCmd->cmd == LC_UUID) {
            struct uuid_command* uuidCmd = (struct uuid_command*)cmdPtr;
            uuid = uuidCmd->uuid;
            break;
        }
        cmdPtr += loadCmd->cmdsize;
    }
    const char* result = nil;
    
    if(uuid != NULL)
    {
        result = uuidBytesToString(uuid);
        NSString *lduuid = [NSString stringWithUTF8String:result];
        return lduuid;
    }
    
    return nil;
}

bool mbapm_getBinaryImage(int index, MBAPMBinaryImage *buffer) {
    const struct mach_header *header = _dyld_get_image_header((unsigned)index);
    if (header == NULL) {
        return false;
    }
    const char *name = _dyld_get_image_name(index);
    NSString *imagePath = [NSString stringWithUTF8String:name];
    if ([imagePath hasPrefix:getMainBundlePath()]) {
        NSString *imageName = nil;
        NSArray *imagePathStrArray = [imagePath componentsSeparatedByString:@"/"];
        if (imagePathStrArray > 0) {
            imageName = imagePathStrArray[imagePathStrArray.count - 1];
            buffer->name = [imageName cStringUsingEncoding:NSUTF8StringEncoding];
        }
    }

    uintptr_t cmdPtr = firstCmdAfterHeader(header);
    if (cmdPtr == 0) {
        return false;
    }

    // Look for the TEXT segment to get the image size.
    // Also look for a UUID command.
    uint64_t imageSize = 0;
    uint64_t imageVmAddr = 0;
    uint64_t version = 0;
    uint8_t *uuid = NULL;

    for (uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
        struct load_command *loadCmd = (struct load_command *)cmdPtr;
        switch (loadCmd->cmd) {
            case LC_SEGMENT: {
                struct segment_command *segCmd = (struct segment_command *)cmdPtr;
                if (strcmp(segCmd->segname, SEG_TEXT) == 0) {
                    imageSize = segCmd->vmsize;
                    imageVmAddr = segCmd->vmaddr;
                }
                break;
            }
            case LC_SEGMENT_64: {
                struct segment_command_64 *segCmd = (struct segment_command_64 *)cmdPtr;
                if (strcmp(segCmd->segname, SEG_TEXT) == 0) {
                    imageSize = segCmd->vmsize;
                    imageVmAddr = segCmd->vmaddr;
                }
                break;
            }
            case LC_UUID: {
                struct uuid_command *uuidCmd = (struct uuid_command *)cmdPtr;
                uuid = uuidCmd->uuid;
                break;
            }
            case LC_ID_DYLIB: {
                struct dylib_command *dc = (struct dylib_command *)cmdPtr;
                version = dc->dylib.current_version;
                break;
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }

    buffer->address = (uintptr_t)header;
    buffer->vmAddress = imageVmAddr;
    buffer->size = imageSize;
    buffer->name = name;
    buffer->uuid = uuid;
    buffer->cpuType = header->cputype;
    buffer->cpuSubType = header->cpusubtype;
    buffer->majorVersion = version >> 16;
    buffer->minorVersion = (version >> 8) & 0xff;
    buffer->revisionVersion = version & 0xff;

    return true;
}

static uintptr_t firstCmdAfterHeader(const struct mach_header* const header) {
    switch (header->magic) {
        case MH_MAGIC:
        case MH_CIGAM:
            return (uintptr_t)(header + 1);
        case MH_MAGIC_64:
        case MH_CIGAM_64:
            return (uintptr_t)(((struct mach_header_64 *)header) + 1);
        default:
            return 0;
    }
}

static const char* uuidBytesToString(const uint8_t* uuidBytes) {
    CFUUIDRef uuidRef = CFUUIDCreateFromUUIDBytes(NULL, *((CFUUIDBytes*)uuidBytes));
    NSString* str = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    return str == NULL ? NULL : strdup(str.UTF8String);
}

@end
