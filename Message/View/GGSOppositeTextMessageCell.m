//
//  GGSOppositeTextMessageCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/2.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSOppositeTextMessageCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface GGSOppositeTextMessageCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 文本信息 */
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation GGSOppositeTextMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSOppositeTextMessageCell";
    GGSOppositeTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSOppositeTextMessageCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)setupCellContentSubViews
{
    // 分割线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.contentView);
        make.height.equalTo(@(5));
    }];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.messageLabel];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.height.equalTo(@(30));
        make.width.equalTo(@(30));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(240));
    }];
    
    // 自适应高度
    _messageLabel.preferredMaxLayoutWidth = 240;
    self.hyb_lastViewInCell = _messageLabel;
    self.hyb_bottomOffsetToCell = 15;
}

#pragma mark ----- Getter
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
    }
    return _messageLabel;
}

@end
