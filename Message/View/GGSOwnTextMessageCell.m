//
//  GGSOwnTextMessageCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/2.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSOwnTextMessageCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface GGSOwnTextMessageCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 文本内容 */
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation GGSOwnTextMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSGroupTextMessageCell";
    GGSOwnTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSOwnTextMessageCell alloc] init];
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
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.top.equalTo(view.mas_bottom).offset(10);
        make.height.equalTo(@(30));
        make.width.equalTo(@(30));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top);
        make.right.equalTo(weakSelf.iconImageView.mas_left).offset(-10);
        make.width.lessThanOrEqualTo(@(240));
    }];
    
    // 自适应高度
    _messageLabel.preferredMaxLayoutWidth = 240;
    self.hyb_lastViewInCell = _messageLabel;
    self.hyb_bottomOffsetToCell = 15;
}

#pragma mark ----- Setter
- (void)setTextContent:(NSString *)textContent
{
    _messageLabel.text = textContent;
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
