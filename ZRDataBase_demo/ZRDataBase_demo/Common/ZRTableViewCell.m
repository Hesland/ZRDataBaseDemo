//
//  ZRTableViewCell.m
//  ZRDataBase_demo
//
//  Created by Hesland on 2017/3/7.
//  Copyright © 2017年 Hesland. All rights reserved.
//

#import "ZRTableViewCell.h"
#import "ZRPerson.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface ZRTableViewCell ()

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *address;

@end

@implementation ZRTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.name = [[UILabel alloc] init];
        self.age = [[UILabel alloc] init];
        self.address = [[UILabel alloc] init];
        
        [self addSubview:self.name];
        [self addSubview:self.age];
        [self addSubview:self.address];
        
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).offset(5);
            make.height.mas_equalTo(@20);
            make.top.mas_equalTo(self.mas_top);
        }];
        
        [self.age mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(@20);
            make.top.mas_equalTo(self.name.mas_bottom).offset(5);
        }];
        
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(@20);
            make.top.mas_equalTo(self.age.mas_bottom).offset(5);
        }];
    }
    
    return self;
}

- (void)setModel:(ZRPerson *)model {
    _model = model;
    
    self.name.text = self.model.name;
    self.age.text = [NSString stringWithFormat:@"%lu",self.model.age];
    self.address.text = self.model.address;
}

@end
