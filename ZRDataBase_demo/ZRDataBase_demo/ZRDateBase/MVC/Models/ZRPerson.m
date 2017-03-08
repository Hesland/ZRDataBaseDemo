//
//  ZRPerson.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/7.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRPerson.h"

@interface ZRPerson()

@end

@implementation ZRPerson

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address num:(NSInteger)num{
    if (self = [super init]) {
        self.age = age;
        self.name = name;
        self.address = address;
        self.num = num;
    }
    return self;
}

@end
