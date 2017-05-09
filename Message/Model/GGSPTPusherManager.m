//
//  GGSPTPusherManager.m
//  GGSPlantform
//
//  Created by min zhang on 16/9/22.
//  Copyright © 2016年 zhangmin. All rights reserved.
//


#import "GGSPTPusherManager.h"
#import <MJExtension/MJExtension.h>
#import "GGSPTPusherData.h"
#import "GGSThreadSubItem.h"
//#import <Pusher/PTPusherChannel.h>
//#import <Pusher/PTPusherEvent.h>

static GGSPTPusherManager   *_mananger = nil;
// PTPusher 的key
static NSString *ptpusherKey = @"13ee7c26bf9f450cc98b";

@interface GGSPTPusherManager ()
// 链接
//@property (nonatomic, strong) PTPusher *client;

@end

@implementation GGSPTPusherManager

+ (instancetype)messageManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mananger = [[GGSPTPusherManager alloc] init];
    });
    return _mananger;
}

/** 注册channel 收到最新的消息时的事件处理 */
- (void)registerMessageChannelWithUserId:(NSInteger)userId
                            messageBlock:(void(^)(GGSPTPusherData *lastMessage))messageBlock {
//    _client = [PTPusher pusherWithKey:@"13ee7c26bf9f450cc98b" delegate:_delegate encrypted:YES];
//    // 根据当前用户id 生成channel
//    NSString *chandelId = [NSString stringWithFormat:@"%ld-channel", userId];
//    PTPusherChannel *channel = [_client subscribeToChannelNamed:chandelId];
//    
//    [channel bindToEventNamed:@"new-message" handleWithBlock:^(PTPusherEvent *channelEvent) {
//        // channelEvent.data is a NSDictianary of the JSON object received
//        // 配置lastMessage 数据
//        NSDictionary *channelDictionary = [channelEvent.data mj_JSONObject];
//        GGSPTPusherData *pusherData = [GGSPTPusherData mj_objectWithKeyValues:channelDictionary];
//        pusherData.created_at = pusherData.created_at / 1000;
//        pusherData.thread = [GGSThreadSubItem mj_objectWithKeyValues:pusherData.thread];
//        
//        if (messageBlock) {
//            messageBlock(pusherData);
//        }
//    }];
//    
//    [self.client connect];
}

@end
