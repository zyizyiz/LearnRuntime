//
//  ViewController.m
//  LearnMsgSend
//
//  Created by ios on 2019/1/28.
//  Copyright © 2019 KN. All rights reserved.
//

#import "ViewController.h"
#import "People.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    People *people =  [People new];
    [people test];      // 动态方法解析
    [people forward];   // 消息转发
    
    
    [People test];
}


@end
