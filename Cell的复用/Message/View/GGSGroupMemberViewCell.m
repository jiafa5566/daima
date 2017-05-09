//
//  GGSGroupMemberViewCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/4.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupMemberViewCell.h"
@interface GGSGroupMemberViewCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 群成员名 */
@property (nonatomic, strong) UILabel *userLabel;
/** 游戏类型 */
@property (nonatomic, strong) UIImageView *gameType_imageView;
@end

@implementation GGSGroupMemberViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GGSGroupMemberViewCell";
    GGSGroupMemberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GGSGroupMemberViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.userLabel];
    [self.contentView addSubview:self.gameType_imageView];
    __weak typeof(self) weakSelf = self;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(kToLeftViewMarigin);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(kToLeftMinMarigin);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-kToLeftMinMarigin);
        make.width.equalTo(weakSelf.iconImageView.mas_height);
    }];
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(kToLeftMinMarigin);
    }];
    [_gameType_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.userLabel.mas_centerY);
        make.left.equalTo(weakSelf.userLabel.mas_right).offset(kToLeftMinMarigin);
        make.height.equalTo(weakSelf.userLabel.mas_height);
        make.width.equalTo(weakSelf.gameType_imageView.mas_height);
    }];
    //  分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HexColor(0xcccccc);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark ----- Setter
- (void)setData:(NSString *)data
{
    _iconImageView.image = [UIImage imageNamed:@"ggs_pay_way_icon"];
    _userLabel.text = data;
    _gameType_imageView.image = [UIImage imageNamed:@"ggs_lol"];
}

#pragma mark ----- Getter
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"ggs_pay_way_icon"];
    }
    return _iconImageView;
}

- (UILabel *)userLabel
{
    if (_userLabel == nil) {
        _userLabel = [[UILabel alloc] init];
        _userLabel.font = [UIFont systemFontOfSize:15];
        _userLabel.textColor = HexColor(0x333333);
    }
    return _userLabel;
}

- (UIImageView *)gameType_imageView
{
    if (_gameType_imageView == nil) {
        _gameType_imageView = [[UIImageView alloc] init];
    }
    return _gameType_imageView;
}

@end
