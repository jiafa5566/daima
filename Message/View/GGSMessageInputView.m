//
//  GGSMessageInputView.m
//  GGSPlantform
//
//  Created by min zhang on 2017/3/9.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSMessageInputView.h"

@interface GGSMessageInputView () <UITextViewDelegate>
/** 背景图 */
@property (nonatomic, strong) UIView *backContainView;
/** 输入框 */
@property (nonatomic, strong) UITextView *inputTextView;
/** 更改显示样式的item */
@property (nonatomic, strong) UIButton *changeInputStateButton;

@property (nonatomic, weak) id<GGSMessageInputDelegate>delegate;

@end

@implementation GGSMessageInputView

@synthesize currentShowText = _currentShowText;

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<GGSMessageInputDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupSubViews];
        _delegate = delegate;
        _currentInputMode = GGSMessageInputModeKeyBoard;
    }
    return self;
}

- (void)p_setupSubViews {
    [self addSubview:self.backContainView];
    [self addSubview:self.inputTextView];
    [self addSubview:self.changeInputStateButton];
    
    __weak typeof(self) weakSelf = self;
    [_backContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(1, 0, 1, 0));
    }];
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(7, 10, 7, 48));
    }];
    [_changeInputStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    self.backgroundColor = HEXCOLOR(0xe5e5e5);
    _backContainView.backgroundColor = HEXCOLOR(0xf6f6f6);
    _inputTextView.layer.borderColor = HEXCOLOR(0xe5e5e5).CGColor;
    _inputTextView.layer.borderWidth = 1.f;
    _inputTextView.layer.cornerRadius = 4.f;
    _inputTextView.layer.masksToBounds = YES;
}

#pragma mark - UItextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        [self.delegate beginEditInputTextView:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __func__);

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __func__);

}
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"%s", __func__);

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __func__);
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(inputView:sendCurrentText:)]) {
            [self.delegate inputView:self sendCurrentText:textView.text];
        }
        return NO;
    } else {
        if ([self.delegate respondsToSelector:@selector(changeEditInputTextView:text:)]) {
            [self.delegate changeEditInputTextView:textView text:text];
        }
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%s", __func__);

}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"%s", __func__);

}

/** 影藏输入框 */
- (void)hideInputView {
    [_inputTextView resignFirstResponder];
}
/** 显示输入框 */
- (void)showInputView {
    [_inputTextView becomeFirstResponder];
}

- (void)clearCurrentShowText {
    _inputTextView.text = @"";
}

- (void)deleteInputViewBackWard {
    [_inputTextView deleteBackward];
}

- (void)changeModeButtonState:(BOOL)state {
    _changeInputStateButton.selected = state;
}

- (void)updateInputViewContentOffSet {
    CGSize size = _inputTextView.contentSize;
    CGSize showSize = _inputTextView.frame.size;
    if (size.height > showSize.height) {
        [_inputTextView setContentOffset:CGPointMake(0, size.height - showSize.height)];
    }
}

- (void)updateInputViewStateWithMessageType:(GGSConnectMessageType)messageType {
    if (messageType == GGSConnectMessageTypeGifImage) {
        _inputTextView.textColor = [UIColor lightGrayColor];
//        _inputTextView.userInteractionEnabled = NO;
    } else {
        _inputTextView.textColor = kMAINTITLE_COLOR;
//        _inputTextView.userInteractionEnabled = YES;
    }
}

#pragma mark - ActionEvent
- (void)changeInputButtonClicked:(UIButton *)sender {
    sender.selected = YES ^ sender.selected;
    GGSMessageInputMode inputMode = GGSMessageInputModeKeyBoard;
    if (sender.selected) {
        inputMode = GGSMessageInputModeEmoticon;
    }
    // 更改当前的输入样式
    if ([self.delegate respondsToSelector:@selector(inputTextView:didChangeCurrentInputMode:)]) {
        [self.delegate inputTextView:self didChangeCurrentInputMode:inputMode];
    }
}

#pragma mark - Setter
- (void)setCurrentInputMode:(GGSMessageInputMode)currentInputMode {
    _currentInputMode = currentInputMode;
    
    if (_currentInputMode == GGSMessageInputModeKeyBoard) {
        _changeInputStateButton.selected = NO;
    } else if (_currentInputMode == GGSMessageInputModeEmoticon) {
        _changeInputStateButton.selected = YES;
    }
}

- (void)setCurrentShowText:(NSString *)currentShowText {
    _currentShowText = currentShowText;
    _inputTextView.text = _currentShowText;
    
}

#pragma mark - Getter
- (NSString *)currentShowText {
    return _inputTextView.text;
}

- (UIView *)backContainView {
    if (_backContainView == nil) {
        _backContainView = [[UIView alloc] init];
    }
    return _backContainView;
}

- (UITextView *)inputTextView {
    if (_inputTextView == nil) {
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.backgroundColor = kLOGO_BACKGROUNDCOLOR;
        _inputTextView.showsVerticalScrollIndicator = YES;
        _inputTextView.delegate = self;
        _inputTextView.showsHorizontalScrollIndicator = NO;
        _inputTextView.font = [UIFont systemFontOfSize:16];
        _inputTextView.textColor = kMAINTITLE_COLOR;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES;
    }
    return _inputTextView;
}

- (UIButton *)changeInputStateButton {
    if (_changeInputStateButton == nil) {
        _changeInputStateButton = [UIButton zm_buttonWithTitle:@""
                                                     font:0
                                          bakcgroundColor:HEXCOLOR(0xf6f6f6)
                                                    image:@""
                                                   target:self
                                                   action:@selector(changeInputButtonClicked:)];
        [_changeInputStateButton setImage:[UIImage imageNamed:@"ggs_inputEmoticon"] forState:UIControlStateNormal];
        [_changeInputStateButton setImage:[UIImage imageNamed:@"ggs_inputKeyboard"] forState:UIControlStateSelected];
        _changeInputStateButton.selected = NO;
    }
    return _changeInputStateButton;
}

@end
