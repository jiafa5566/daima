//
//  GGSCustomerServiceCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSCustomerServiceCell.h"
@interface GGSCustomerServiceCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** GOGOSU官方客服 */
@property (nonatomic, strong) UILabel *serViceLabel;
/** 官方客服标签*/
@property (nonatomic, strong) UILabel *signLabel;
@end

@implementation GGSCustomerServiceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSCustomerServiceCell";
    GGSCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSCustomerServiceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

-(void)setupCellContentSubViews
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.serViceLabel];
    [self.contentView addSubview:self.signLabel];
    __weak typeof(self) weakSelf = self;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(kToLeftViewMarigin);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(kToLeftMinMarigin);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-kToLeftMinMarigin);
        make.width.equalTo(weakSelf.iconImageView.mas_height);
    }];
    [_serViceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(kToLeftMinMarigin);
    }];
    [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
        make.left.equalTo(weakSelf.serViceLabel.mas_right).offset(kToLeftMinMarigin);
    }];
}

#pragma mark ----- PrivationMethod
- (NSMutableAttributedString *)p_cellsetUpAttributedStringWithSourceString:(NSString *)sourceString
{
    NSMutableAttributedString *artString = [[NSMutableAttributedString alloc] initWithString:sourceString];
    NSTextAttachment *leftTextAtt = [[NSTextAttachment alloc] init];
    leftTextAtt.bounds = CGRectMake(0, 0, 5, 0);
    NSMutableAttributedString * leftIamgeString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:leftTextAtt];
    NSTextAttachment *rightTextAtt = [[NSTextAttachment alloc] init];
    rightTextAtt.bounds = CGRectMake(0, 0, 5, 0);
    NSMutableAttributedString * rightIamgeString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:rightTextAtt];
    [leftIamgeString appendAttributedString:artString];
    [leftIamgeString appendAttributedString:rightIamgeString];
    return leftIamgeString;
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

- (UILabel *)serViceLabel
{
    if (_serViceLabel == nil) {
        _serViceLabel = [[UILabel alloc] init];
        _serViceLabel.text = @"GOGOSU客服";
        _serViceLabel.font = [UIFont systemFontOfSize:18];
    }
    return _serViceLabel;
}

- (UILabel *)signLabel
{
    if (_signLabel == nil) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.attributedText = [self p_cellsetUpAttributedStringWithSourceString:@"官方客服"];
        _signLabel.backgroundColor = HexColor(0xff9600);
        _signLabel.textColor = kWHITE_COLOR;
        _signLabel.layer.cornerRadius = 4;
        _signLabel.layer.masksToBounds = YES;
    }
    return _signLabel;
}


@end
