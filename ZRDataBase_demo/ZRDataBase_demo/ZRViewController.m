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

@interface ZRViewController ()
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ZRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self zr_testWithFMDB];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击查看数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 40);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
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

- (void)buttonClick {
//    [self presentViewController:[[ZRTableViewController alloc] init] animated:YES completion:nil];
    [self zr_testWithFMDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
