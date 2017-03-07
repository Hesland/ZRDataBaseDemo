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
#import "Masonry.h"
#import "ZRPerson.h"



@interface ZRViewController ()


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
    
    /**
     1.展示UI时，就应当先开启数据库并查询全部数据。如果App第一次开启，应当先建立数据库并建立一个新表。（应该考虑的是数据量比较大时带来的I/O操作的卡顿问题）
     2.根据获取的状态，进行下一步的预留操作
     */
    
    
    [self openDataBase];
    [self setupUI];
}

- (void)openDataBase {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"persons.db"];

    FMDatabase *personsDB = [FMDatabase databaseWithPath:path];
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
            NSString *name = [result_enum stringForColumn:@"name"];
            NSString *address = [result_enum stringForColumn:@"address"];
            ZRPerson *person = [[ZRPerson alloc] initWithName:name age:age address:address];
            
            [array_tmp addObject:person];
        }
        
        self.personList = [array_tmp mutableCopy];
    }
    
    NSLog(@"数据库记录完毕");
    [self.db close];
}

- (void)insertData {
    ZRPerson *person = [[ZRPerson alloc] initWithName:self.nameF.text
                                                  age:self.ageF.text.integerValue
                                              address:self.addressF.text];
    
    if ([self.db open]) {
        NSString *insertStr = [NSString stringWithFormat:@"insert into persons(num ,name, age, address) values(%lu,'%@',%@,'%@')", self.personList.count, self.nameF.text, self.ageF.text, self.addressF.text];
        if ([self.db executeUpdate:insertStr]) {
            NSLog(@"插入成功");
            [self.personList addObject:person];
        }
        
    }
}

- (void)showData {
    ZRTableViewController *tableViewController = [[ZRTableViewController alloc] init];
    tableViewController.personList = self.personList;
    [self.navigationController pushViewController:tableViewController animated:YES];
}

/// FMDB初体验
- (void)zr_testWithFMDB {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbPath = [path stringByAppendingPathComponent:@"FMDB.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSLog(@"db开启成功");
        self.db = db;
        
        // 更新db
        // 1.创建表
        NSString *createStr = @"create table mytable(num integer,name varchar(7),sex char(1),primary key(num));";
        BOOL create_res = [self.db executeUpdate:createStr];
        if (!create_res) {
            NSLog(@"error when creating database table");
            
//            // 2.插入|新建
//            NSString *insertStr = @"insert into mytable(num,name,sex) values(0,'zhaoran','m');";
//            BOOL insert_res = [self.db executeUpdate:insertStr];
//            if (!insert_res) {
//                NSLog(@"error when inserting database table");
//                [self.db close];
//            }
            
//            // 3.修改数据
//            NSString *updateStr = @"update mytable set name = 'Hesland' where num = 0;";
//            BOOL update_res = [self.db executeUpdate:updateStr];
//            if (!update_res) {
//                NSLog(@"error when updating database table");
//                [self.db close];
//            }
            
            // 4.删除数据
            // 昭然：貌似这里写的删除数据的字符串指令存在一些问题，删除不掉对应的数据
            NSString *deleteStr = @"delete from members where num = 0;";
            BOOL delete_res = [self.db executeUpdate:deleteStr];
            if (!delete_res) {
                NSLog(@"error when deleting database table");
                [self.db close];
            }
            
        }
        
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //执行查询SQL语句，返回查询结果
    FMResultSet *result = [self.db executeQuery:@"select * from mytable"];
    NSMutableArray *array = [NSMutableArray array];
    //获取查询结果的下一个记录
    while ([result next]) {
        //根据字段名，获取记录的值，存储到字典中
        // 昭然：这里就是牵扯到需要用什么来接收数据库中查询到的数据了。至于是要用字典，还是要用MVC中设计出的模型，全看需要做的是什么事情，仅此而已。
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        int num  = [result intForColumn:@"num"];
        NSString *name = [result stringForColumn:@"name"];
        NSString *sex  = [result stringForColumn:@"sex"];
        dict[@"num"] = @(num);
        dict[@"name"] = name;
        dict[@"sex"] = sex;
        //把字典添加进数组中
        [array addObject:dict];
    }
    
    NSLog(@"%@", array);
}

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
