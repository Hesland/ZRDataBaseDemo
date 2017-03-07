//
//  ZRPerson.h
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/7.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRPerson : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address;

@end
