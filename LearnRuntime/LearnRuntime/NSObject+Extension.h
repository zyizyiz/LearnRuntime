//
//  NSObject+Extension.h
//  LearnRuntime
//
//  Created by ios on 2019/1/4.
//  Copyright © 2019年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

/// 归档
- (void) yz_decoder:(NSCoder *)aDecoder;

/// 解档
- (void) yz_encoder:(NSCoder *)encoder;

- (NSString *)arrayObjectClass;
@end
