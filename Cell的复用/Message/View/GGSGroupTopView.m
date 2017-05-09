//
//  GGSGroupTopView.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupTopView.h"

#define GROUP_BUTTONTAG 1024
@interface GGSGroupTopView()
/** 背景图 */
@property (nonatomic, strong) UIImageView *backGroundImageView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 设置按钮 */
@property (nonatomic, strong) UIButton *setButton;
/** 群名称 */
@property (nonatomic, strong) UILabel *groupNameLabel;
/** 群号 */
@property (nonatomic, strong) UILabel *groupNumberLabel;
@end

@implementation GGSGroupTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsLayout];
    }
    return self;
}

/** 添加SubViewslayout */
- (void)setupSubViewsLayout
{
    __weak typeof(self) weakSelf = self;
    [self addSubview:self.backGroundImageView];
    [self insertSubview:self.backButton aboveSubview:self.backGroundImageView];
    [self insertSubview:self.setButton aboveSubview:self.backGroundImageView];
    [self insertSubview:self.groupNameLabel aboveSubview:self.backGroundImageView];
    [self insertSubview:self.groupNumberLabel aboveSubview:self.backGroundImageView];
    [_backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(40);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
    }];
    [_setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.top.equalTo(weakSelf.mas_top).offset(40);
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
    }];
    [_groupNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset (30);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-20);
    }];
    [_groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.groupNumberLabel.mas_top).offset(- 10);
        make.left.equalTo(weakSelf.groupNumberLabel);
    }];
};

#pragma mark ----- PrivationMethod
- (void)backBUttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1025:
        {  // 返回
            if (self.selectedBlock) {
                self.selectedBlock(sender.tag - GROUP_BUTTONTAG);
            }
        }
            break;
        case 1026:
        {  // 设置
            if (self.selectedBlock) {
                self.selectedBlock(sender.tag - GROUP_BUTTONTAG);
            }
        }
        default:
            break;
    }
}

/** 根据显示内容计算显示宽度 */
- (CGFloat)p_calculateRowWidth:(NSString *)string  font:(CGFloat )textFont{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:textFont]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

/** 根据显示的内容计算显示的高度 */
- (CGFloat)p_calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat )textMaxWidth{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(textMaxWidth, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

#pragma mark ----- Setter
- (UIImageView *)backGroundImageView
{
    if (_backGroundImageView == nil) {
        _backGroundImageView = [[UIImageView alloc] init];
        _backGroundImageView.backgroundColor = HexColor(0xC391BE);
    }
    return _backGroundImageView;
}
- (void)setGroupInfo:(id)groupInfo
{
    _groupNameLabel.text = @"布吉岛教学群8班";
    _groupNumberLabel.text = @"群号0541554";
}

#pragma mark ----- Getter
- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [UIButton zm_buttonWithFont:16 title:@"返回" titleColor:[UIColor blackColor] backgroundColor:HexColor(0x86CCC9) target:self action:@selector(backBUttonAction:)];
        _backButton.tag = GROUP_BUTTONTAG + 1;
        _backButton.layer.cornerRadius = 17.5;
        _backButton.layer.masksToBounds = YES;
    }
    return _backButton;
}

- (UIButton *)setButton
{
    if (_setButton == nil) {
        _setButton = [UIButton zm_buttonWithFont:16 title:@"设置" titleColor:[UIColor blackColor] backgroundColor:HexColor(0x86CCC9) target:self action:@selector(backBUttonAction:)];
        _setButton.layer.cornerRadius = 17.5;
        _setButton.layer.masksToBounds = YES;
        _setButton.tag = GROUP_BUTTONTAG + 2;
    }
    return _setButton;
}

- (UILabel *)groupNameLabel
{
    if (_groupNameLabel == nil) {
        _groupNameLabel = [[UILabel alloc] init];
        _groupNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _groupNameLabel.text = @"布吉岛教学群8班";
    }
    return _groupNameLabel;
}

- (UILabel *)groupNumberLabel
{
    if (_groupNumberLabel == nil) {
        _groupNumberLabel = [[UILabel alloc] init];
        _groupNumberLabel.font = [UIFont boldSystemFontOfSize:16];
        _groupNumberLabel.text = @"群号0541554";
    }
    return _groupNumberLabel;
}


@end
