//
//  GGSGroupPartNumberCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/6.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupPartNumberCell.h"
@interface GGSGroupPartNumberCell()
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *itemLabel;
/** 部分成员头像 */
@property (nonatomic, strong) UIImageView *numberImageView1;
@property (nonatomic, strong) UIImageView *numberImageView2;
@property (nonatomic, strong) UIImageView *numberImageView3;
@property (nonatomic, strong) UIImageView *numberImageView4;

/** 显示箭头 */
@property (nonatomic, strong) UIButton *arrowButton;
@end

@implementation GGSGroupPartNumberCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSGroupPartNumberCell";
    GGSGroupPartNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSGroupPartNumberCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.itemLabel];
    [self.contentView addSubview:self.numberImageView1];
    [self.contentView addSubview:self.numberImageView2];
    [self.contentView addSubview:self.numberImageView3];
    [self.contentView addSubview:self.numberImageView4];
    [self.contentView addSubview:self.arrowButton];
    __weak typeof(self) weakSelf = self;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        make.width.equalTo(weakSelf.iconImageView.mas_height);
    }];
    [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.equalTo(@12);
        make.width.equalTo(@12);
    }];
    [_numberImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.arrowButton.mas_left).offset(-10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.numberImageView4.mas_height);
    }];
    [_numberImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberImageView4.mas_left).offset(-10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.numberImageView3.mas_height);
    }];
    [_numberImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberImageView3.mas_left).offset(-10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.numberImageView2.mas_height);
    }];
    [_numberImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberImageView2.mas_left).offset(-10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.numberImageView1.mas_height);
    }];
}

#pragma mark ----- Setter
- (void)setData:(GGSTitleCellData *)data
{
    _itemLabel.text = data.leftTitle;
}

#pragma mark ----- Getter
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = HexColor(0x73C7F2);
        _iconImageView.layer.cornerRadius = 12.5;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)itemLabel
{
    if (_itemLabel == nil) {
        _itemLabel = [[UILabel alloc] init];
    }
    return _itemLabel;
}

- (UIImageView *)numberImageView1
{
    if (_numberImageView1 == nil) {
        _numberImageView1 = [[UIImageView alloc]init];
        _numberImageView1.backgroundColor = HexColor(0x73C7F2);
        _numberImageView1.layer.cornerRadius = 17.5;
        _numberImageView1.layer.masksToBounds = YES;
    }
    return _numberImageView1;
}

- (UIImageView *)numberImageView2
{
    if (_numberImageView2 == nil) {
        _numberImageView2 = [[UIImageView alloc] init];
        _numberImageView2.backgroundColor = HexColor(0x73C7F2);
        _numberImageView2.layer.cornerRadius = 17.5;
        _numberImageView2.layer.masksToBounds = YES;

    }
    return _numberImageView2;
}

- (UIImageView *)numberImageView3
{
    if (_numberImageView3 == nil) {
        _numberImageView3 = [[UIImageView alloc] init];
        _numberImageView3.backgroundColor = HexColor(0x73C7F2);
        _numberImageView3.layer.cornerRadius = 17.5;
        _numberImageView3.layer.masksToBounds = YES;

    }
    return _numberImageView3;
}

- (UIImageView *)numberImageView4
{
    if (_numberImageView4 == nil) {
        _numberImageView4 = [[UIImageView alloc] init];
        _numberImageView4.backgroundColor = HexColor(0x73C7F2);
        _numberImageView4.layer.cornerRadius = 17.5;
        _numberImageView4.layer.masksToBounds = YES;

    }
    return _numberImageView4;
}

- (UIButton *)arrowButton
{
    if (_arrowButton == nil) {
        _arrowButton = [UIButton zm_buttonWithBackImage:@"ggs_videolist_more" selectedImage:@"ggs_videolist_more"];
    }
    return _arrowButton;
}

@end
