//
//  GGSGroupInfoSettingCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupInfoSettingCell.h"

@interface GGSGroupInfoSettingCell()

/** 选择框 */
@property (nonatomic, strong) UISwitch *switchButton;
@end

@implementation GGSGroupInfoSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSGroupInfoSettingCell";
    GGSGroupInfoSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSGroupInfoSettingCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [super setupCellContentSubViews];
    [self.contentView addSubview:self.switchButton];
    __weak typeof(self) weakSelf = self;
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.equalTo(@(18));
        make.height.equalTo(@(10));
    }];
}

#pragma mark ----- PrivationMethod
- (void)switchAction:(UISwitch *)sender
{
    if (self.SWitchBlock) {
        self.SWitchBlock(sender.on);
    }
}

#pragma mark ----- Getter
- (UISwitch *)switchButton
{
    if (_switchButton == nil) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton setOn:NO];
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

@end
