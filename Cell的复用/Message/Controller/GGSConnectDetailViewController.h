//
//  GGSConnectDetailViewController.h
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGSUserThread;

@interface GGSConnectDetailViewController : UIViewController

/**
 创建item

 @param threadId 聊天的id
 @return 预发送的消息
 */
- (instancetype)initWithThreadId:(NSInteger)threadId;

/**
 创建item

 @param threadId 聊天的threadId
 @param preMessage 预发送的消息
 @return item
 */
- (instancetype)initWithThreadId:(NSInteger)threadId
                      preMessage:(NSString *)preMessage;

/** 点击返回事件处理 */
@property (nonatomic, copy) void(^PreViewActionBlock)();

/** 是否显示未读标记为已读 */
@property (nonatomic, assign) BOOL isShowPeekUnRead;

/** 影藏底部的输入框 */
- (void)p_changeSubInputViewState:(BOOL)state;






///**
// *  通过threadId创建对象
// *
// *  @param threadId 创建的threadId
// *
// *  @return <#return value description#>
// */
//- (instancetype)initWithThreadId:(NSInteger)threadId;

@end


