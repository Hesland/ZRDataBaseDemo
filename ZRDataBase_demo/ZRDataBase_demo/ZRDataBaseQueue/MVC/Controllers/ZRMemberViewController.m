//
//  ZRMemberViewController.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/8.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRMemberViewController.h"
#import "ZRMember.h"
#import "ZRTableViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Masonry.h"

@interface ZRMemberViewController ()

@property (nonatomic, copy) NSString *dbPath;

@end

@implementation ZRMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self openDataBase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)openDataBase {
    if (self.dbPath == nil) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"members.db"];
        NSLog(@"%@", path);
        self.dbPath = path;
    }
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    // 把别的表中的数据先导入到这个数据中(数据迁移，合并)
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *selectTableSql = @"select * from sqlite_master where type = 'table' and name = 'members';";
        FMResultSet *result_table = [db executeQuery:selectTableSql];
        if (![result_table next]) {
            NSString *createSql = @"create table members(num integer, name varchar(20), age integer, address varchar(300), primary key(num));";
            [db executeUpdate:createSql];
        }
        // 获取数据
        NSString *selectSql = @"select * from members;";
        FMResultSet *result_enum = [db executeQuery:selectSql];
        NSMutableArray *arr_tmp = [NSMutableArray array];
        while ([result_enum next]) {
            ZRMember *member = [ZRMember memberWithName:[result_enum stringForColumn:@"name"]
                                                      age:(NSInteger)[result_enum intForColumn:@"age"]
                                                  address:[result_enum stringForColumn:@"address"]
                                                      num:(NSInteger)[result_enum intForColumn:@"num"]];
            [arr_tmp addObject:member];
        }
        self.personList = [arr_tmp mutableCopy];
    }];
}

- (void)insertData {
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *insertStr = [NSString stringWithFormat:@"insert into members(num, name, age, address) values(%lu, %@, %lu, %@);", self.personList.count - 1, self.nameF.text, [self.ageF.text integerValue], self.address.text];
        if ([db executeUpdate:insertStr]) {
            NSLog(@"插入成功");
        };
    }];
}

- (void)showData {
    ZRTableViewController *tableViewController = [[ZRTableViewController alloc] init];
    tableViewController.personList = self.personList;
    tableViewController.delegate = self;
    [self.navigationController pushViewController:tableViewController animated:YES];
    NSLog(@"%@展示数据成功", self);
}

- (void)deleteData:(NSInteger)index {
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    [dbQueue inDatabase:^(FMDatabase *db) {
        ZRMember *member = self.personList[index];
        NSString *deleteStr = [NSString stringWithFormat:@"delete from members where num = %lu", member.num];
        if ([db executeUpdate:deleteStr]) {
            [self.personList removeObjectAtIndex:index];
        }
    }];
}

- (void)ZRTableViewDidDeleteDataAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteData:indexPath.row];
}



- (void)setupUI {
    [super setupUI];
    self.title = @"输入数据";
    [self.interButton setBackgroundColor:[UIColor blueColor]];
    [self.showButton setBackgroundColor:[UIColor blueColor]];
}

@end
