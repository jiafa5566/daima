//
//  GGSGroupMemberTopView.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupMemberTopView.h"

#define MEMBERVIEW_TAG 1024
@interface GGSGroupMemberTopView()
/** 显示数据 */
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
/** 上一个button */
@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation GGSGroupMemberTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:CGRectZero sourceArray:nil];
}

- (instancetype)initWithFrame:(CGRect)frame sourceArray:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = dataArray;
        [self setupSubViewsLayout];
    }
    return self;
}

/** 添加SUbViewsLayout */
- (void)setupSubViewsLayout
{
    CGFloat origin_x = (SCREEN_WIDTH - 270) / 2;
    __weak typeof(self) weakSelf = self;
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton zm_buttonWithTitle:obj font:15 bakcgroundColor:[UIColor whiteColor]
                                                target:self action:@selector(buttonAction:)];
        button.tag = MEMBERVIEW_TAG + idx;
        [button setTitleColor:HexColor(0x999999) forState:(UIControlStateNormal)];
        [button setTitleColor:HexColor(0xff9600) forState:(UIControlStateSelected)];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = HexColor(0x999999).CGColor;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(origin_x + 70 *idx);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.height.equalTo(@(30));
            make.width.equalTo(@(60));
        }];
    }];
    
}


- (void)buttonAction:(UIButton *)sender
{
    if (self.selectedBlock) {
        self.selectedBlock(sender.tag - MEMBERVIEW_TAG);
    }
    [_lastButton setTintColor:HexColor(0x999999)];
    _lastButton.layer.borderColor = HexColor(0x999999).CGColor;
    sender.layer.borderColor = HexColor(0xff9600).CGColor;
    [sender setTintColor:HexColor(0xff9600)];
    _lastButton = sender;
}

#pragma mark ----- Getter
- (NSMutableArray<NSString *> *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)lastButton
{
    if (_lastButton == nil) {
        _lastButton = [[UIButton alloc] init];
    }
    return _lastButton;
}

@end
