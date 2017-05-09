//
//  GGSMessageInputView.h
//  GGSPlantform
//
//  Created by min zhang on 2017/3/9.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSCoachConnectList.h"

@class GGSMessageInputView;

/**
 键盘的输入样式

 - GGSMessageInputModeKeyBoard: 键盘输入
 - GGSMessageInputModeEmoticon: 表情输入
 */
typedef NS_ENUM(NSInteger, GGSMessageInputMode) {
    GGSMessageInputModeKeyBoard = 0,
    GGSMessageInputModeEmoticon,
};

@protocol GGSMessageInputDelegate <NSObject>

@optional

- (void)inputTextView:(GGSMessageInputView *)inputTextView didChangeCurrentInputMode:(GGSMessageInputMode)inputMode;

- (void)beginEditInputTextView:(UITextView *)textView;

- (void)endEditInputTextView:(UITextView *)textView;

- (void)changeEditInputTextView:(UITextView *)textView text:(NSString *)text;

- (void)sendTextView:(UITextView *)textView message:(NSString *)message;

/** 发送当前的文本信息 */
- (void)inputView:(GGSMessageInputView *)inputView sendCurrentText:(NSString *)text;

@end

@interface GGSMessageInputView : UIView

/** 当前输入的样式 */
@property (nonatomic, assign) GGSMessageInputMode currentInputMode;

@property (nonatomic, strong) NSString *currentShowText;

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<GGSMessageInputDelegate>)delegate;

/** 清除当前显示文本 */
- (void)clearCurrentShowText;

/** 影藏输入框 */
- (void)hideInputView;
/** 显示输入框 */
- (void)showInputView;
/** 清除最后面的显示title */
- (void)deleteInputViewBackWard;

- (void)changeModeButtonState:(BOOL)state;

/** 更新输入框偏移量 */
- (void)updateInputViewContentOffSet;

/** 更新输入框的状态 */
- (void)updateInputViewStateWithMessageType:(GGSConnectMessageType )messageType;

@end
