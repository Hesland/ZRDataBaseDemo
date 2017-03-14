//
//  ZRTableViewCell.h
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/7.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZRPerson;
@interface ZRTableViewCell : UITableViewCell

@property (nonatomic, strong) ZRPerson *model;

@end
