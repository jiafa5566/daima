//
//  GGSPTPusherManager.h
//  GGSPlantform
//
//  Created by min zhang on 16/9/22.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Pusher/PTPusher.h>

@class GGSPTPusherData;

@interface GGSPTPusherManager : NSObject
/** 消息接收器 */
+ (instancetype)messageManager;

/** 注册channel 收到最新的消息时的事件处理 */
- (void)registerMessageChannelWithUserId:(NSInteger)userId messageBlock:(void(^)(GGSPTPusherData *lastMessage))messageBlock;

//@property (nonatomic, weak) id<PTPusherDelegate>delegate;

@end
