//
//  ViewController.m
//  LearnSuper
//
//  Created by ios on 2019/1/29.
//  Copyright © 2019 KN. All rights reserved.
//

#import "ViewController.h"
#import "People.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
        函数在栈上 栈的地址分配是从高地址到低地址
        obj -> cls -> People
     
     */
    id cls = [People class];
    void *obj = &cls;
    // my name is <ViewController: 0x7f9030f07b40>
    [(__bridge id)obj print];
    
}


@end
