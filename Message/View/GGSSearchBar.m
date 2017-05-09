//
//  GGSSearchBar.m
//  GGSPlantform
//
//  Created by min zhang on 2017/3/1.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSSearchBar.h"

@interface GGSSearchBar ()

@property (nonatomic, strong) UIView *leftPlaceView;

@end

@implementation GGSSearchBar

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupDefaultSetting];
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - PrivateMethod
- (void)p_setupDefaultSetting {
    self.font = [UIFont systemFontOfSize:13];  // 继承于UITextField 直接设置字体大小
    self.placeArtString = @"搜索你感兴趣的东西";
    self.clearButtonMode = UITextFieldViewModeWhileEditing; // 清楚输入框的按钮出现的模式
    

    
    
//    self.leftPlaceView.frame = CGRectMake(0, 0, 6, CGRectGetHeight(self.bounds));
//    self.leftPlaceView.backgroundColor = [UIColor redColor];
//    self.leftView = self.leftPlaceView;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ggs_home_search"]];
    imageView.userInteractionEnabled = NO;
    [self.leftPlaceView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_leftPlaceView).offset(-5);
        make.centerY.equalTo(_leftPlaceView);
        make.height.equalTo(@12);
        make.width.equalTo(@12);
    }];
    
    self.leftView = self.leftPlaceView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.borderStyle = UITextBorderStyleNone;
    [self setValue:HEXCOLOR(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
//    [self setValue:HEXCOLOR(0xc51564) forKeyPath:@"_placeholderLabel.backgroundColor"];

    self.tintColor = [UIColor blueColor];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    if (self.isEditing) {
        // 编辑状态
        CGFloat leftOrigin =  5 + 12 + 5;
        // 更新leftView的动画
//        [UIView animateWithDuration:0.2 animations:^{
            self.leftPlaceView.frame = CGRectMake(0, 0, leftOrigin, CGRectGetHeight(self.frame));
//        }];
        return CGRectMake(leftOrigin, 0.5, CGRectGetWidth(self.bounds) - 5 + 12 + 5, CGRectGetHeight(self.frame));
    } else {
        // 非编辑状态
        CGSize showSize = [NSString zm_titleLimitSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX) title:self.placeholder font:self.font];
        CGFloat leftOrigin = (CGRectGetWidth(self.frame) - showSize.width)/2.0;
        // 更新leftView的动画
//        [UIView animateWithDuration:0.2 animations:^{
            self.leftPlaceView.frame = CGRectMake(0, 0, leftOrigin + (12 + 5) / 2.0, CGRectGetHeight(self.frame));
//        }];
        return CGRectMake(leftOrigin + (12 + 5)/2.0, 0.5, CGRectGetWidth(self.bounds) - (leftOrigin + (12 + 5) / 2.0), CGRectGetHeight(self.frame));
    }
}

//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    CGFloat leftOrigin =  5 + 12 + 5;
//    self.leftPlaceView.frame = CGRectMake(0, 0, leftOrigin, CGRectGetHeight(self.frame));
//    return CGRectMake(leftOrigin, 0, CGRectGetWidth(self.bounds) - 5 + 12 + 5, CGRectGetHeight(self.frame));
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.leftPlaceView.frame = CGRectMake(0, 0, 6, CGRectGetHeight(self.frame));
//    
//    if (self.isEditing) {
//        self.leftPlaceView.frame = CGRectMake(0, 0, 5 + 12 + 5, CGRectGetHeight(self.frame));
//    } else {
//        CGSize showSize = [NSString zm_titleLimitSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX) title:self.placeholder font:self.font];
//        CGFloat leftOrigin = (CGRectGetWidth(self.frame) - showSize.width)/2.0;
//        self.leftPlaceView.frame = CGRectMake(0, 0, leftOrigin + 5, CGRectGetHeight(self.frame));
//    }
//    
//    [self editingRectForBounds:self.bounds];
}

//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectMake(CGRectGetMaxX(self.leftPlaceView.frame), 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.leftPlaceView.frame), CGRectGetHeight(bounds));
//}

#pragma mark - Setter
- (void)setPlaceArtString:(NSString *)placeArtString {
    _placeArtString = placeArtString;

    self.placeholder = _placeArtString;
    
//    [self layoutSubviews];
    
//    CGSize showSize = [NSString zm_titleLimitSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX) title:self.placeholder font:self.font];
//    CGFloat leftOrigin = (CGRectGetWidth(self.frame) - showSize.width)/2.0;
//    self.leftPlaceView.frame = CGRectMake(0, 0, leftOrigin + 5 + 12, CGRectGetHeight(self.frame));
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
//    [self textRectForBounds:self.bounds];
    CGFloat leftOrigin =  5 + 12 + 5;
    self.leftPlaceView.frame = CGRectMake(0, 0, leftOrigin, CGRectGetHeight(self.frame));
}

#pragma mark - Getter
- (UIView *)leftPlaceView {
    if (_leftPlaceView == nil) {
        _leftPlaceView = [[UIView alloc] init];
        _leftPlaceView.backgroundColor = [UIColor clearColor];
        _leftPlaceView.userInteractionEnabled = NO;
    }
    return _leftPlaceView;
}

@end
