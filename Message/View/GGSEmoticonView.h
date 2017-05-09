//
//  GGSEmoticonView.h
//  GGSPlantform
//
//  Created by min zhang on 2017/2/28.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGSEmoticonView;

@protocol GGSEmoticonDelegate <NSObject>

@optional
/** 点击图片的事件处理 */
- (void)emotiocnView:(GGSEmoticonView *)emoticonView didClickedItemAtIndex:(NSInteger)index bottomIndex:(NSInteger)bottomIndex;

/** 点击选项的事件 */
- (void)emotiocnView:(GGSEmoticonView *)emoticonView didClickedBottomItemAtIndex:(NSInteger)index;

/** 发送图片的事件 */
- (void)sendCurrentInputText;

@end

static const NSInteger kEachPageCount = 21;

@interface GGSEmoticonView : UIView

/** 表情图片 */
@property (nonatomic, strong) NSMutableArray *emoticonArray;

/** 默认选中位置 */
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

/** 根据当前内容跟新按钮状态 */
- (void)changeSendButtonStateWithCurrentText:(NSString *)text;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<GGSEmoticonDelegate>)delegate
           bottomEmotionArray:(NSMutableArray *)bottomEmotionArray;

@end
