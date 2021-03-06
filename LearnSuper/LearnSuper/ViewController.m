//
//  ViewController.m
//  LearnSuper
//
//  Created by ios on 2019/1/29.
//  Copyright © 2019 KN. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (Class)class
{
    return object_getClass(self);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ViewController ViewController UIViewController UIViewController
    // super 关键词只是从super class 向上找方法而已 参赛还是self
    // superclass 就是调用 [self class]->superclass;
    NSLog(@"%@",[self class]);
    NSLog(@"%@",[super class]);
    NSLog(@"%@",[self superclass]);
    NSLog(@"%@",[super superclass]);

    NSLog(@"-----------------------");
    
    // ViewController ViewController
    NSLog(@"%@",NSStringFromClass([self class]));
    // [super class] 就是调用 object_getClass(self);
    NSLog(@"%@",NSStringFromClass([super class]));
    
    NSLog(@"-----------------------");
    /*
        函数在栈上 栈的地址分配是从高地址到低地址
        obj -> cls -> People
     
     */
    id cls = [People class];
    void *obj = &cls;
    // my name is <ViewController: 0x7f9030f07b40>
    [(__bridge id)obj print];
    
    // 1 0 0 0
    // isKindOfClass : 代表是否为目标类或者其的子类  区分类对象和实例对象
    // isMemberOfClass : 代表是否为目标类  区分类对象和实例对象
    // isKindOfClass:[NSObject class]  永远为True  因为基类的元类的superclass是基类
    // 类对象调用判断的是元类  实例对象调用判断的是类对象
    NSLog(@"%d",[[People class] isKindOfClass:[NSObject class]]);
    NSLog(@"%d",[[People class] isMemberOfClass:[NSObject class]]);
    NSLog(@"%d",[[People class] isKindOfClass:[People class]]);
    NSLog(@"%d",[[People class] isMemberOfClass:[People class]]);

}


@end
