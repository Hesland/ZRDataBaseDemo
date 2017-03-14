//
//  ZRMember.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/8.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRMember.h"

@implementation ZRMember

+ (instancetype)memberWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address num:(NSInteger)num {
    return [[super alloc] initWithName:name age:age address:address num:num];
}

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address num:(NSInteger)num {
    if (self = [super initWithName:name age:age address:address num:num]) {
        // 这里附加扩展的属性赋值
    }
    return self;
}

@end
