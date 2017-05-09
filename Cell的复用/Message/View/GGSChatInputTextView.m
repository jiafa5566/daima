//
//  GGSChatInputTextView.m
//  GGSPlantform
//
//  Created by min zhang on 16/10/13.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSChatInputTextView.h"

@interface GGSChatInputTextView ()


@end

@implementation GGSChatInputTextView

#pragma mark - Setter
- (void)setPlaceHolder:(NSString *)placeHolder {
    if ([_placeHolder isEqualToString:placeHolder]) {
        return;
    }
    
    NSUInteger maxChars = [GGSChatInputTextView maxCharactersPerLine];
    if ([placeHolder length] > maxChars) {
        placeHolder = [placeHolder substringToIndex:maxChars - 8];
        placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }
    
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setIsShowPlaceHolder:(BOOL)isShowPlaceHolder {
    if (_isShowPlaceHolder == isShowPlaceHolder) {
        return;
    }
    
    _isShowPlaceHolder = isShowPlaceHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    if ([_placeHolderColor isEqual:placeHolderColor]) {
        return;
    }
    
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    dispatch_async(dispatch_get_main_queue(), ^{
        [super setFont:font];
        [self setNeedsDisplay];
    });
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Notification
- (void)inpuTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setup];
        _isShowPlaceHolder = YES;
    }
    return self;
}

- (NSUInteger)numberOfLinesOfText {
    return [GGSChatInputTextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
    return (text.length / [GGSChatInputTextView maxCharactersPerLine]) + 1;
}

#pragma mark - PrivateMethod
- (void)p_setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 10, 8);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16];
    self.textColor = kMAINTITLE_COLOR;
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.returnKeyType = UIReturnKeySend;
    self.textAlignment = NSTextAlignmentLeft;
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inpuTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
}

/** 绘制placeHolder */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([self.text length] == 0 && self.placeHolder && self.isShowPlaceHolder) {
        
        CGSize titleSize = [NSString zm_titleLimitSize:CGSizeMake(CGRectGetWidth(self.frame) - 20, 40) title:self.placeHolder font:[UIFont systemFontOfSize:16]];
        // 绘制区域
        CGRect placeHolderRect = CGRectMake((rect.size.width - titleSize.width)/2.0, (rect.size.height - titleSize.height)/2.0, titleSize.width, titleSize.height);
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            [_placeHolder drawInRect:placeHolderRect
                      withAttributes:@{NSFontAttributeName : (self.font != nil ? self.font : [UIFont systemFontOfSize:16]),
                                       NSForegroundColorAttributeName : (self.placeHolderColor != nil ? self.placeHolderColor : kMAINTITLE_COLOR),
                                       NSParagraphStyleAttributeName : paragraphStyle}];
        } else {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            [_placeHolder drawInRect:placeHolderRect
                      withAttributes:@{NSFontAttributeName : self.font,
                             NSParagraphStyleAttributeName : paragraphStyle}];
        }
    }
}

- (void)dealloc {
    _placeHolder = nil;
    _placeHolderColor = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
