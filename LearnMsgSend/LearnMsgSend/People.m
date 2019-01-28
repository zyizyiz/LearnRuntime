//
//  People.m
//  LearnMsgSend
//
//  Created by ios on 2019/1/28.
//  Copyright © 2019 KN. All rights reserved.
//

#import "People.h"
#import <objc/message.h>

@implementation People

// 动态方法解析后重新进入消息发送状态
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // @selector() 底层实现相当于char*
    if (sel == @selector(test)) {
        // self 为类对象
//        Method method = class_getInstanceMethod(self, @selector(yz_test));
//        class_addMethod(self,
//                        sel,
//                        method_getImplementation(method),
//                        method_getTypeEncoding(method));
        class_addMethod(self,
                        sel,
                        (IMP)C_test, "v16@0:8");
        // 写不写返回YES无所谓，因为不管怎样，都会进入消息发送
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 类方法需要动态解析类方法，不然也会报错  EXC_BAD_ACCESS
        Method method = class_getClassMethod(object_getClass(self), @selector(yz_test));
        class_addMethod(object_getClass(self),
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        return YES;
    }
    return [super resolveClassMethod:sel];
}


- (void)yz_test
{
    NSLog(@"class : %s",__func__);
}

+ (void)yz_test
{
    NSLog(@"mete-class : %s",__func__);
}

// v 16 @ 0 : 8
// v void
// 16 一共占16个字节
// @ self
// 0 从0开始
// : SEL
// 8 从8开始
void C_test(id self,SEL _cmd)
{
    NSLog(@"%@ - %s - %s",self,sel_getName(_cmd),__func__);
}

@end
