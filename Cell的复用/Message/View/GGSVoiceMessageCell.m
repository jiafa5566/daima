//
//  GGSVoiceMessageCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSVoiceMessageCell.h"
@interface GGSVoiceMessageCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 语音背景图 */
@property (nonatomic, strong) UIImageView *backImageView;
/** 语音动图 */
@property (nonatomic, strong) UIImageView *voiceImageView;
/** 语音时长 */
@property (nonatomic, strong) UILabel *voiceDurationLabel;
@end

@implementation GGSVoiceMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSVoiceMessageCell";
    GGSVoiceMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSVoiceMessageCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)setupCellContentSubViews
{
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    __weak typeof(self) weakSlef = self;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSlef.contentView);
        make.height.equalTo(@(5));
    }];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.backImageView];
    [self.contentView insertSubview:self.voiceImageView aboveSubview:self.backImageView];
    [self.contentView addSubview:self.voiceDurationLabel];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.right.equalTo(weakSlef.contentView.mas_right).offset(-15);
        make.height.equalTo(@(30));
        make.width.equalTo(@(30));
    }];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSlef.iconImageView.mas_top);
        make.right.equalTo(weakSlef.iconImageView.mas_left).offset(-10);
        make.width.equalTo(@(120));
        make.height.equalTo(@(30));
    }];
    [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(weakSlef.backImageView);
        make.width.equalTo(weakSlef.voiceImageView.mas_height);
    }];
    [_voiceDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSlef.iconImageView.mas_centerY);
        make.right.equalTo(weakSlef.backImageView.mas_left).offset(10);
    }];
}

#pragma mark ----- Getter
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)backImageView
{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UIImageView *)voiceImageView
{
    if (_voiceImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)voiceDurationLabel
{
    if (_voiceDurationLabel == nil) {
        _voiceDurationLabel = [[UILabel alloc] init];
    }
    return _voiceDurationLabel;
}
@end
