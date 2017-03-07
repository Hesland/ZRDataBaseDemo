//
//  ZRTableViewController.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/6.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRTableViewController.h"
#import "FMDatabase.h"

@interface ZRTableViewController ()

@property (nonatomic, strong) FMDatabase *db;


@end

@implementation ZRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor redColor];
    
    [self zr_testWithFMDB];
    
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
            [self.db close];
        }
        
        // 2.插入
        NSString *insertStr = @"insert into mytable(num,name,sex) values(0,'zhaoran','m');";
        BOOL insert_res = [self.db executeUpdate:insertStr];
        if (!insert_res) {
            NSLog(@"error when creating database table");
            [self.db close];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
