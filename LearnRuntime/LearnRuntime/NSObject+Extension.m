//
//  NSObject+Extension.m
//  LearnRuntime
//
//  Created by ios on 2019/1/4.
//  Copyright © 2019年 KN. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/objc-runtime.h>
@implementation NSObject (Extension)

+(BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"resolveClassMethod");
    return false;
}

+(BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod");
    return false;
}

-(id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector");
    return nil;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation");
    
}
-(void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"doesNotRecognizeSelector");
}

/// 归档
-(void) yz_decoder:(NSCoder *)aDecoder {
    Class currentClass = self.class;
    while (currentClass && currentClass !=[NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(currentClass, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        currentClass = [currentClass superclass];
    }
}

/// 解档
- (void) yz_encoder:(NSCoder *)aCoder {
    Class currentClass = self.class;
    while (currentClass && currentClass !=[NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(currentClass, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [self valueForKey:key];
            [aCoder encodeObject:value forKey:key];
        }
        free(ivars);
        currentClass = [currentClass superclass];
    }
}

- (void) yz_setDic:(NSDictionary *)dict {
    Class currentClass = [self class];
    while (currentClass && currentClass != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([currentClass class], &outCount);
        for (int i = 0 ; i < outCount; i++) {
            Ivar ivar = ivars[i];
            // 获取成员变量
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            // 将成员变量转为属性名
            key = [key substringFromIndex:1];
            id value = dict[key];
            // 防止属性模型的数量大于字典的数量 从会被赋值为nil而报错
            if (value == nil) {
                continue;
            }
            
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
                if ([type hasPrefix:@"NS"]) {
                    _Nullable Class class = NSClassFromString(type);
                    if (class) {
                        value = [class yz_objectWithDic:value];
                    }
                }else if ([type isEqualToString:@"NSArray"]) {
                    NSArray *array = value;
                    NSMutableArray *mArray = [NSMutableArray array];
                    
                    id class;
                    if ([self respondsToSelector:@selector(arrayObjectClass)]) {
//                        NSString *classStr = [self arrayObjectClass];
//                        class = NSClassFromString(classStr);
                    }
                    for (id item in array) {
                        [mArray addObject:item];
                    }
                    value = mArray;
                }
            }
            
            [self setValue:value forKey:key];
        }
        free(ivars);
        currentClass = [currentClass superclass];
    }
}



+(instancetype) yz_objectWithDic:(NSDictionary *)dict {
    NSObject *obj = [[NSObject alloc]init];
    [obj yz_setDic:dict];
    return obj;
}


@end
