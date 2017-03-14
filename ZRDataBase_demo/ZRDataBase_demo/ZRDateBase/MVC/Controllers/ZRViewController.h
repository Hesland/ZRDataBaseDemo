//
//  ZRViewController.h
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/6.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTableViewController.h"

@class ZRPerson,FMDatabase;
@interface ZRViewController : UIViewController <ZRTableViewDelegate>

@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UITextField *nameF;
@property (nonatomic, strong) UITextField *ageF;
@property (nonatomic, strong) UITextField *addressF;
@property (nonatomic, strong) UIButton *interButton;
@property (nonatomic, strong) UIButton *showButton;

@property (nonatomic, strong) NSMutableArray *personList;

- (void)setupUI;
- (void)insertData;
- (void)showData;
- (void)deleteData:(NSInteger)index;
- (void)openDataBase;

@end
