//
//  ZRViewController.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/6.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRViewController.h"
#import "ZRTableViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Masonry.h"
#import "ZRPerson.h"

@interface ZRViewController () <ZRTableViewDelegate>

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

@end


@implementation ZRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self openDataBase];
    [self setupUI];
}

#pragma mark - FMDB

- (void)openDataBase {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"persons.db"];
    FMDatabase *personsDB = [FMDatabase databaseWithPath:path];  // 从此可见，根本不需要用单例来继续锁定db对象了，而只需要确定db的路径即可获取到对应的db，并生成一个线程安全的操作队列
//    FMDatabaseQueue *personDBQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    if ([personsDB open]) {
        NSLog(@"数据库已经打开");
        self.db = personsDB;
        NSString *selectTableStr = @"select * from sqlite_master where type = 'table' and name = 'persons';";
        FMResultSet *result_table = [self.db executeQuery:selectTableStr];
        if (![result_table next]) {
            NSString *createStr = @"create table persons(num integer, name varchar(20), age integer, address varchar(300), primary key(num));";
            BOOL create_res = [self.db executeUpdate:createStr];
            if (create_res) {
                NSLog(@"persons表创建成功");
            }
        }
        
        NSString *seleteEnumStr = @"select * from persons;";
        FMResultSet *result_enum = [self.db executeQuery:seleteEnumStr];
        NSMutableArray *array_tmp = [NSMutableArray array];

        while ([result_enum next]) {
            NSInteger age = (NSInteger)[result_enum intForColumn:@"age"];
            NSInteger num = (NSInteger)[result_enum intForColumn:@"num"];
            NSString *name = [result_enum stringForColumn:@"name"];
            NSString *address = [result_enum stringForColumn:@"address"];
            ZRPerson *person = [[ZRPerson alloc] initWithName:name age:age address:address num:num];
            [array_tmp addObject:person];
        }
        self.personList = [array_tmp mutableCopy];
    }
    
    NSLog(@"数据库记录完毕");
    [self.db close];
}

- (void)insertData {
    ZRPerson *lastPerson = self.personList.lastObject;
    ZRPerson *person = [[ZRPerson alloc] initWithName:self.nameF.text
                                                  age:self.ageF.text.integerValue
                                              address:self.addressF.text
                                                  num:lastPerson.num + 1];
    if ([self.db open]) {
        NSString *insertStr = [NSString stringWithFormat:@"insert into persons(num ,name, age, address) values(%lu,'%@',%@,'%@');", lastPerson.num + 1, self.nameF.text, self.ageF.text, self.addressF.text];
        if ([self.db executeUpdate:insertStr]) {
            NSLog(@"插入成功");
            [self.personList addObject:person];
            [self.db close];
        }
    }
}

- (void)showData {
    ZRTableViewController *tableViewController = [[ZRTableViewController alloc] init];
    tableViewController.personList = self.personList;
    tableViewController.delegate = self;
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)deleteData:(NSInteger)index {
    if ([self.db open]) {
        ZRPerson *person = self.personList[index];
        NSString *deleteStr = [NSString stringWithFormat:@"delete from persons where num = %lu;",person.num];
        if ([self.db executeUpdate:deleteStr]) {
            NSLog(@"删除成功");
            [self.personList removeObjectAtIndex:index];
            [self.db close];
        }
    }
}

#pragma mark - ZRTableViewDelegate

- (void)ZRTableViewDidDeleteDataAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteData:indexPath.row];
}

#pragma mark - UI
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     1.姓名
     2.年龄
     3.家庭住址
     */
    
    self.title = @"输入数据";
    
    self.interButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.interButton setTitle:@"输入数据" forState:UIControlStateNormal];
    [self.interButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.interButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.interButton setBackgroundColor:[UIColor greenColor]];
    [self.interButton addTarget:self action:@selector(insertData) forControlEvents:UIControlEventTouchUpInside];
    
    self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showButton setTitle:@"展示数据" forState:UIControlStateNormal];
    [self.showButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.showButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.showButton setBackgroundColor:[UIColor greenColor]];
    [self.showButton addTarget:self action:@selector(showData) forControlEvents:UIControlEventTouchUpInside];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"姓名:";
    self.age = [[UILabel alloc] init];
    self.age.text = @"年龄:";
    self.address = [[UILabel alloc] init];
    self.address.text = @"地址:";
    
    self.nameF = [[UITextField alloc] init];
    self.nameF.placeholder = @"请输入姓名";
    self.ageF = [[UITextField alloc] init];
    self.ageF.placeholder = @"请输入年龄";
    self.addressF = [[UITextField alloc] init];
    self.addressF.placeholder = @"请输入家庭地址";
    
    
    [self.view addSubview:self.name];
    [self.view addSubview:self.age];
    [self.view addSubview:self.address];
    [self.view addSubview:self.nameF];
    [self.view addSubview:self.ageF];
    [self.view addSubview:self.addressF];
    [self.view addSubview:self.interButton];
    [self.view addSubview:self.showButton];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30);
        make.top.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@50);
    }];
    
    [self.age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.name);
        make.top.mas_equalTo(self.name.mas_bottom).offset(10);
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.name);
        make.top.mas_equalTo(self.age.mas_bottom).offset(10);
    }];
    
    [self.nameF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_right).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(30);
        make.top.height.mas_equalTo(self.name);
    }];
    
    [self.ageF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameF);
        make.top.height.mas_equalTo(self.age);
    }];
    
    [self.addressF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameF);
        make.top.height.mas_equalTo(self.address);
    }];
    
    [self.interButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.address.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.interButton.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
