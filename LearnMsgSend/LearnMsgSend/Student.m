//
//  Student.m
//  LearnMsgSend
//
//  Created by ios on 2019/1/28.
//  Copyright © 2019 KN. All rights reserved.
//

#import "Student.h"

@implementation Student

//- (void)forward
//{
//    NSLog(@"class : %s",__func__);
//}

// 第三步
// 方法重签名
// ******不区分实例方法和类方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(forward)) {
        NSLog(@"第三步: 方法签名");
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 走到这一步的话 可以做任何事
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
    NSLog(@"第三步 ： %@ -- %@",NSStringFromSelector(anInvocation.selector),anInvocation.target);
}
@end
