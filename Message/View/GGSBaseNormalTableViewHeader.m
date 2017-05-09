//
//  GGSBaseNormalTableViewHeader.m
//  GGSPlantform
//
//  Created by min zhang on 2017/2/20.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSBaseNormalTableViewHeader.h"

@interface GGSBaseNormalTableViewHeader ()
/** 描述按钮 */
@property (nonatomic, strong) UIButton *descrButton;

@end

@implementation GGSBaseNormalTableViewHeader

+ (GGSBaseNormalTableViewHeader *)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"GGSBaseNormalTableViewHeader";
    GGSBaseNormalTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (header == nil) {
        header = [[GGSBaseNormalTableViewHeader alloc] init];
    }
    return header;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupSubViews];
    }
    return self;
}

#pragma mark - ActionEvent
- (void)buttonClicked:(UIButton *)sender {
    if (_ClickBlock) {
        self.ClickBlock();
    }
}

#pragma mark - PrivateMethod
- (void)p_setupSubViews {
    [self.contentView addSubview:self.descrButton];
    
    __weak typeof(self) weakSelf = self;
    [_descrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
}

#pragma mark - Setter
- (void)setShowTitle:(NSString *)showTitle {
    _showTitle = showTitle;
    
    [_descrButton setTitle:_showTitle forState:UIControlStateNormal];
    [_descrButton setTitle:_showTitle forState:UIControlStateSelected];
}

#pragma mark - Getter
- (UIButton *)descrButton {
    if (_descrButton == nil) {
        _descrButton = [UIButton zm_buttonWithTitle:@""
                                               font:14
                                    bakcgroundColor:[UIColor clearColor]
                                             target:self
                                             action:@selector(buttonClicked:)];
        [_descrButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_descrButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    }
    return _descrButton;
}

@end
