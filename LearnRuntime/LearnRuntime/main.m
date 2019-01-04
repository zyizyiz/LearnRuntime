//
//  main.m
//  LearnRuntime
//
//  Created by ios on 2019/1/4.
//  Copyright © 2019年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>
#import "NSObject+Extension.h"

@interface People:NSObject<NSCoding>

// 升高
@property(nonatomic,copy)NSString *height;

// 体重
@property(nonatomic,copy)NSString *weight;

// 年龄
@property(nonatomic,assign)int age;

+(void)run;

+(void)study;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
@end

@implementation People

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self yz_decoder: aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder { 
    [self yz_encoder:aCoder];
}


+(void)run {
    NSLog(@"我正在跑步");
}

+(void)study {
    NSLog(@"我正在学习");
}

@end

@interface ZPeople : NSObject

+(void)z_run;

@end

@implementation ZPeople

+(void)load {
    Method m1 = class_getClassMethod([People class], @selector(run));
    Method m2 = class_getClassMethod([ZPeople class], @selector(z_run));
    method_exchangeImplementations(m1, m2);
}

+(void)z_run {
    NSLog(@"我休息一下");
    // 方法已被交换
    [ZPeople z_run];
}

@end

@interface People(Custom)

// 判断是否需要喝水 分类不能生成实例变量
@property(nonatomic,assign)NSString *name;
@end

@implementation People(Custom)

-(void)setName:(NSString *)name {
    // _cmd 表示当前方法的selector
    objc_setAssociatedObject(self, _cmd, name, OBJC_ASSOCIATION_COPY);
}

-(NSString *)name {
    return objc_getAssociatedObject(self, @selector(setName:));
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [People run];
        [People study];
        // runtime 为分类添加属性
        People *man = [[People alloc]init];
        [man setName:@"张三"];
        NSLog(@"名字是%@",man.name);
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([People class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            // 获取变量名
            const char *name = ivar_getName(ivar);
            // 获取变量类型
            const char *type = ivar_getTypeEncoding(ivar);
            NSLog(@"成员变量名：%s 成员变量类型：%s",name,type);
        }
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingString:@"/people.plist"];
        NSLog(@"%@",path);
        
        [man setAge:20];
        [man setHeight:@"180"];
        [man setWeight:@"150"];
        BOOL isSuccess = [NSKeyedArchiver archiveRootObject:man toFile:path];
        if (isSuccess) {
            NSLog(@"归档成功");
        }
        
        People *people = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSLog(@"身高是%@",people.height);
        
        _Nullable Class ca = NSClassFromString(@"www");
        NSLog(@"%@",ca);
    }
    return 0;
}
