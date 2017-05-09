//
//  GGSUserThread.h
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGSGGSLastMessage;

#import "GGSCoachConnectList.h"

@interface GGSUserThread : NSObject

@property (nonatomic, assign) long long thread_id;

@property (nonatomic, assign) long long participant_id;

@property (nonatomic, assign) long long unread_message_count;

@property (nonatomic, assign) long long page;

@property (nonatomic, strong) NSMutableArray *participants;
/**
 *  最后一条消息的时间
 */
@property (nonatomic, assign) long long last_message_time;
/**
 *  最后一条消息
 */
@property (nonatomic, strong) GGSGGSLastMessage *last_message;
/**
 *  全名称
 */
@property (nonatomic, strong) NSString *subject;
/**
 *  是否官方客服
 */
@property (nonatomic, assign) BOOL is_support;

/** 当前用户的头像 */
@property (nonatomic, strong, readonly) NSString *currentUserPic;
/** 其他聊天的用户头像 */
@property (nonatomic, strong, readonly) NSString *chatPic;
/** 用户名 */
@property (nonatomic, strong, readonly) NSString *userName;
/** 其他聊天用户的用户名 */
@property (nonatomic, strong, readonly) NSString *chatUserName;
/** 其他聊天用户的userId */
@property (nonatomic, assign, readonly) NSInteger chatId;

/** 自己增加字段 最后一条信息显示时间 */
@property (nonatomic, strong) NSString *lastMessageShowTime;

/** 当前消息的类型 */
@property (nonatomic, assign) GGSConnectMessageType messageType;

/** 处理显示数据 */
- (void)handelShowItem;

/** 判断当前的用户信息是否有效 */
- (BOOL)isCurrentThreadDataAvaliable;

@end
