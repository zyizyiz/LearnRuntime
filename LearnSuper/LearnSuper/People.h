//
//  People.h
//  LearnSuper
//
//  Created by ios on 2019/1/29.
//  Copyright © 2019 KN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface People : NSObject

// 姓名
@property(nonatomic,copy)NSString *name;

// 年龄
@property(nonatomic,copy)NSString *age;

- (void)print;

@end

NS_ASSUME_NONNULL_END
