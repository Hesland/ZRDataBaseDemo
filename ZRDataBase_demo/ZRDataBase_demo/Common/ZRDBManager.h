//
//  ZRDBManager.h
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/14.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@interface ZRDBManager : NSObject <NSCopying>

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareManager;
//- (FMDatabase *)createDataBaseWithPath:(NSString *)path;
//- (void)createTableWithName:(NSString *)name;// 这得扔进来一个字典吧？
//- (void)selectWithkey:(NSString *)key;

@end
