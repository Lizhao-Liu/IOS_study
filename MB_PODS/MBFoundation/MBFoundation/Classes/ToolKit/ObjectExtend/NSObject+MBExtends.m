//
//  NSObject+MBExtends.m
//  YMMTestProj
//
//  Created by heng wu on 2020/3/31.
//  Copyright © 2020 heng wu. All rights reserved.
//

#import "NSObject+MBExtends.h"
#import <objc/runtime.h>

@implementation NSObject (MBExtends)

+ (BOOL)ymm_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ {
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    return YES;
}

+ (BOOL)ymm_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ {
    return [object_getClass((id)self) ymm_swizzleMethod:origSel_ withMethod:altSel_];
}

- (BOOL)isKindOfClazz:(Class)aClass {
    return [self isKindOfClass:aClass];
}

+ (Class)clazz {
    return [self class];
}

-(id)glt_performSelector:(SEL)selector withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION {
    // 根据类名以及SEL 获取方法签名的实例
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        signature = [self methodSignatureForSelector:selector];
        if (signature == nil) {
            return nil;
        }
    }
    // NSInvocation是一个消息调用类，它包含了所有OC消息的成分：target、selector、参数以及返回值。
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    NSUInteger argCount = signature.numberOfArguments;
    // 参数必须从第2个索引开始，因为前两个已经被target和selector使用
    argCount = argCount > 2 ? argCount - 2 : 0;
    NSMutableArray *objs = [NSMutableArray arrayWithCapacity:0];
    if (object) {
        [objs addObject:object];
        va_list args;
        va_start(args, object);
        while ((object = va_arg(args, id))){
            [objs addObject:object];
        }
        va_end(args);
    }
    if (objs.count != argCount){
        return nil;
    }
    //设置参数列表
    for (NSInteger i = 0; i < objs.count; i++) {
        id obj = objs[i];
        if ([obj isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([obj isKindOfClass:[NSDictionary class]] && obj[@"YMMSWNull"] &&
            [obj[@"YMMSWNull"] isKindOfClass:[NSNumber class]]) {
            continue;
        }else{
            [invocation setArgument:&obj atIndex:i+2];
        }
    }
    [invocation invoke];
    //获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength != 0 && signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}


#pragma mark - Safe

- (id)valueForUndefinedKey:(NSString *)key {
    return objc_getAssociatedObject(self, CFBridgingRetain(key));
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    objc_setAssociatedObject(self, CFBridgingRetain(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNilValueForKey:(NSString *)key {
    return ;
}

#pragma mark - Property Methods

static const char *jk_getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            NSArray *numberTypes = @[@"i",@"s",@"l",@"q",@"I",@"S",@"L",@"Q",@"f",@"d",@"B"];
            if ([numberTypes containsObject:name]) {
                name = NSStringFromClass([NSNumber class]);
            }
            if (name) {
                return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
            }
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            if (name) {
                return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
            }
        }
    }
    
    return "";
}

+ (NSArray *)ymm_allPropertyKeys:(BOOL)includeSuper {
    
    Class clazz = self.class;
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    if (includeSuper) {
        Class superClass = class_getSuperclass(self.class);
        if (superClass != [NSObject class]) {
            NSArray *superPropertyArray = [superClass ymm_allPropertyKeys:YES];
            [propertyArray addObjectsFromArray:superPropertyArray];
        }
    }
    
    return [NSArray arrayWithArray:propertyArray];
}

+ (NSArray *)ymm_allPropertyKeys:(BOOL)includeSuper rootSuperClass:(Class)rootSuperClass {
    if (!rootSuperClass) {
        rootSuperClass = [NSObject class];
    }
    
    Class clazz = self.class;
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    if (includeSuper) {
        Class superClass = class_getSuperclass(self.class);
        if (superClass != rootSuperClass) {
            NSArray *superPropertyArray = [superClass ymm_allPropertyKeys:YES rootSuperClass:rootSuperClass];
            [propertyArray addObjectsFromArray:superPropertyArray];
        }
    }
    
    return [NSArray arrayWithArray:propertyArray];
}

+ (Class)ymm_classForPropertyName:(NSString *)propertyName {
    
    Class classForProperty = nil;
    
    objc_property_t property = class_getProperty(self.class, propertyName.UTF8String);
    
    if (property) {
        NSString *className = [NSString stringWithUTF8String:jk_getPropertyType(property)];
        classForProperty = NSClassFromString(className);
    }
    
    return classForProperty;
}

- (NSDictionary *)ymm_allProperty {
    NSArray *allPropertyKeys = [[self class] ymm_allPropertyKeys:NO];
    if (allPropertyKeys.count > 0) {
        return [self dictionaryWithValuesForKeys:allPropertyKeys];
    }
    return nil;
}

@end


@implementation NSObject (MBJournal)

- (void)setEventExtraDic:(NSDictionary *)eventExtraDic {
    objc_setAssociatedObject(self, @selector(eventExtraDic), eventExtraDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)eventExtraDic {
    return objc_getAssociatedObject(self, @selector(eventExtraDic));
}


- (void)setLogElementId:(NSString *)logElementId {
    [self setElementId:logElementId];
}


// 如果没有设置logElementId直接使用当前对象类名
- (NSString *)logElementId {
    return [self elementId];
}


#pragma mark - Interface Methods

- (void)setElementId:(NSString *)elementId {
    objc_setAssociatedObject(self, @selector(elementId), elementId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// 如果没有设置elementId直接使用当前对象类名
- (NSString *)elementId {
    return objc_getAssociatedObject(self,@selector(elementId));
}

- (NSDictionary *)extension {
    return nil;
}

@end

