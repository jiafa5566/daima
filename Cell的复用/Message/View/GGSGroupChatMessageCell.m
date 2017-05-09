//
//  GGSGroupChatMessageCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupChatMessageCell.h"
@interface GGSGroupChatMessageCell()
/** 游戏类型图片 */
@property (nonatomic, strong) UIImageView *gameTypeImageView;
/** 群主名称 */
@property (nonatomic, strong) UILabel *groupManagerLabel;

@end

@implementation GGSGroupChatMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSGroupChatMessageCell";
    GGSGroupChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSGroupChatMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [super setupCellContentSubViews];
    [self.contentView addSubview:self.gameTypeImageView];
    [self.contentView addSubview:self.groupManagerLabel];
    __weak typeof(self) weakSelf = self;
    [_gameTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.userlabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.bottom.equalTo(weakSelf.textLabel.mas_top).offset(-10);
        make.width.equalTo(weakSelf.gameTypeImageView.mas_height);
    }];
    [_groupManagerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.gameTypeImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.gameTypeImageView.mas_centerY);
    }];
}

#pragma mark ----- Getter
- (UIImageView *)gameTypeImageView
{
    if (_gameTypeImageView == nil) {
        _gameTypeImageView = [[UIImageView alloc] init];
    }
    return _gameTypeImageView;
}

- (UILabel *)groupManagerLabel
{
    if (_groupManagerLabel == nil) {
        _groupManagerLabel = [[UILabel alloc] init];
    }
    return _groupManagerLabel;
}

@end
