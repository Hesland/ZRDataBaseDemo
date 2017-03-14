//
//  ZRMember.h
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/8.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRPerson.h"

@interface ZRMember : ZRPerson

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address num:(NSInteger)num;
+ (instancetype)memberWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address num:(NSInteger) num;

@end
