//
//  ZRDBManager.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/14.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRDBManager.h"
#import "FMDatabase.h"

@implementation ZRDBManager

static id manager;

+ (instancetype)shareManager {
    @synchronized (self) {
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    }
    return manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}




@end
