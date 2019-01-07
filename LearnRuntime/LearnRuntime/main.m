//
//  main.m
//  LearnRuntime
//
//  Created by ios on 2019/1/4.
//  Copyright © 2019年 KN. All rights reserved.
//

/*
 OC中的方法调用其实都是转成了objc_msgSend的函数调用
 objc_msgSend底层有3大阶段 : 消息发送（当前类、父类中查找）、动态方法解析、消息转发
 
 OC是一门动态性比较强的编程语言，很多操作都是推迟到程序运行时在进行。
 OC的动态性就是由Runtime来支撑和实现的。平时编写的OC代码，底层都是转换成Runtime API进行调用
 
 具体应用：
 1.利用关联属性（AssociatedObject）给分类添加属性
 (objc_getAssociatedObject、objc_setAssociatedObject)
 2.遍历类的所有成员变量（归解档、字典转模型、修改textfield的占位文字颜色(KVO)）
 (objc_copyIvarList)
 3.交换方法实现
 (method_exchangeImplementations)
 4.利用消息转发机制解决方法找不到的异常情况
 (+resolveInstanceMethod、+resolveClassMethod、-forwardingTargetForSelector、-forwardInvocation、-doesNotRecognizeSelector)
 ......
 
 */

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>
#import "NSObject+Extension.h"

@interface People:NSObject<NSCoding>

// 身高
@property(nonatomic,copy)NSString *height;

// 体重
@property(nonatomic,copy)NSString *weight;

// 年龄
@property(nonatomic,assign)int age;

+(void)run;

+(void)study;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;

-(void)print;
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


-(void)print {
    NSLog(@"my height is %@",_height);
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

@interface Student : ZPeople

@end

@implementation Student

-(instancetype)init {
    /*
     [self class] = Student
     [super class] = Student
     [self superclass] = ZPeople
     [super class] = ZPeople
     */
    if (self == [super init]) {
        NSLog(@"[self class] = %@",[self class]);
        NSLog(@"[super class] = %@",[super class]);
        NSLog(@"[self superclass] = %@",[self superclass]);
        NSLog(@"[super class] = %@",[super superclass]);
    }
    return self;
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

void encode(People *man) {
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
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [People run];
        [People study];
        // runtime 为分类添加属性
        People *man = [[People alloc]init];
        [man setName:@"张三"];
        NSLog(@"名字是%@",man.name);
        // 遍历成员变量
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
        
        encode(man);
        
        // 找不到时传null
        _Nullable Class ca = NSClassFromString(@"www");
        NSLog(@"%@",ca);
        
        
        // isKindOfClass : 确定一个对象是否是一个类的成员,或者是派生自该类的成员(该类的子类).
        // isMemberOfClass : 确定一个对象是否是当前类的成员.
        Student *s =  [[Student alloc]init];
        Boolean res1 = [[NSObject class] isKindOfClass:[NSObject class]];
        Boolean res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
        Boolean res3 = [[ZPeople class] isKindOfClass:[ZPeople class]];
        Boolean res4 = [[ZPeople class] isMemberOfClass:[ZPeople class]];
        Boolean res5 = [s isKindOfClass:[Student class]];
        Boolean res6 = [s isMemberOfClass:[Student class]];
        // 1 0 0 0 1 1
        NSLog(@"%d %d %d %d %d %d",res1,res2,res3,res4,res5,res6);
        
        // 运行失败 unrecognized selector sent to instance
        id cls = [ZPeople class];
        void *obj = &cls;
        [(__bridge id)obj print];
        
    }
    return 0;
}

