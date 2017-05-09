//
//  GGSChatInputTextView.h
//  GGSPlantform
//
//  Created by min zhang on 16/10/13.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSChatInputTextView : UITextView

/** 占位字符 */
@property (nonatomic, strong) NSString *placeHolder;

/** 占位字符的的颜色 */
@property (nonatomic, strong) UIColor *placeHolderColor;


/** 获取文本的行数 */
- (NSUInteger)numberOfLinesOfText;

/** 每行显示的高度 */
+ (NSUInteger)maxCharactersPerLine;

/** 获取文本显示的自适应宽度的行数 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

/** 是否显示图片 */
@property (nonatomic, assign) BOOL isShowPlaceHolder;

@end
