//
//  ZRTableViewController.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/6.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRTableViewController.h"
#import "ZRTableViewCell.h"
#import "FMDatabase.h"
#import "Masonry.h"

static NSString *ID = @"ZRTableViewCellIdentifer";

@interface ZRTableViewController ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ZRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)exitCurrentViewController {
    [[UIApplication sharedApplication].windows.lastObject.subviews.lastObject removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.personList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                      title:@"删除"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除该条数据？" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // 想了想，还是用代理方法搞定数据删除好了。今晚先写到这里。
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:okay];
        [controller addAction:cancel];
        
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    return [NSArray arrayWithObject:delete];
}

@end
