//
//  GGSPersonalChatMessageCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSPersonalChatMessageCell.h"
@interface GGSPersonalChatMessageCell()
/** 对应的名称 */
@property (nonatomic, strong) UILabel *userNameLabel;
@end

@implementation GGSPersonalChatMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSPersonalChatMessageCell";
    GGSPersonalChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSPersonalChatMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [super setupCellContentSubViews];
    [self.contentView addSubview:self.userNameLabel];
    __weak typeof(self) weakSelf = self;
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.top.equalTo(weakSelf.userlabel.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.textLabel.mas_top).offset(-10);
    }];
}

#pragma mark ----- Getter
- (UILabel *)userNameLabel
{
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] init];
    }
    return _userNameLabel;
}

@end
