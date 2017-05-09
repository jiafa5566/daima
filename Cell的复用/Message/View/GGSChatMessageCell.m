//
//  GGSChatMessageCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSChatMessageCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface GGSChatMessageCell()
@end

@implementation GGSChatMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSChatMessageCell";
    GGSChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSChatMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.userlabel];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.datelabel];
    __weak typeof(self) weakSelf = self;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.iconImageView.mas_height);
    }];
    [_userlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - CGRectGetWidth(weakSelf.iconImageView.frame) - CGRectGetWidth(weakSelf.datelabel.frame) - 50));
    }];
    [_textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-60);
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom);
    }];
    [_datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
    }];
    
//    // 自适应高度
//    _textlabel.preferredMaxLayoutWidth = SCREEN_WIDTH - CGRectGetWidth(weakSelf.iconImageView.frame) - 40;
//    self.hyb_lastViewInCell = _textlabel;
//    self.hyb_bottomOffsetToCell = 10;
}

#pragma mark ----- Setter
- (void)setData:(id)data
{
    _iconImageView.image = [UIImage imageNamed:@"ggs_refreshicon"];
    _userlabel.text = @"这里是客服";
    _datelabel.text = @"2017-01-23";
    _textlabel.text = @"中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委中纪委红纪委中纪委中纪委";
}

#pragma mark ----- Getter
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)userlabel
{
    if (_userlabel == nil) {
        _userlabel = [[UILabel alloc] init];
        _userlabel.font = [UIFont systemFontOfSize:16];
    }
    return _userlabel;
}

- (UILabel *)datelabel
{
    if (_datelabel == nil) {
        _datelabel = [[UILabel alloc] init];
        _datelabel.font = [UIFont systemFontOfSize:12];
        _datelabel.textColor = HexColor(0xcccccc);
    }
    return _datelabel;
}

- (UILabel *)textLabel
{
    if (_textlabel == nil) {
        _textlabel = [[UILabel alloc] init];
        _textlabel.font = [UIFont systemFontOfSize:12];
        _textlabel.textColor = HexColor(0xcccccc);
    }
    return _textlabel;
}

@end
