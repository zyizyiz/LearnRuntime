//
//  People.m
//  LearnSuper
//
//  Created by ios on 2019/1/29.
//  Copyright © 2019 KN. All rights reserved.
//

#import "People.h"

@implementation People

//static Class _C_People_class(Class self, SEL _cmd) {
    // 消息接受者 结构体
    // 方法
    // super指的是从父类开始向上查找方法
    // 编译和实际调用的方法不同
    // 编译：objc_msgSendSuper   实际：objc_msgSendSuper2
    // 结构体也不同
    // objc_msgSendSuper ： {self,superClass}  objc_msgSendSuper2: {self,selfClass}
//    objc_msgSendSuper(
//                      {
//                          self,
//                          class_getSuperclass(objc_getMetaClass("People"))
//                      }, sel_registerName("class"));
//}

//- (void)test
//{
//    [super test];
//    NSLog(@"1234567890");
//}

- (void)print
{
//    NSLog(@"my name is %@, age is %@",_name,_age);
    NSLog(@"my name is %@",self.name);
}

@end
