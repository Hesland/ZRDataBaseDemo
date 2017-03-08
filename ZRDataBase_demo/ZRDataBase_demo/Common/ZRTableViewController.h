//
//  ZRTableViewController.h
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/6.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRTableViewDelegate <NSObject>

- (void)ZRTableViewDidDeleteDataAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZRTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *personList;
@property (nonatomic, weak) id<ZRTableViewDelegate> delegate;

@end
