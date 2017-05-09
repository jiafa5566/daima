//
//  GGSChatJMessage.h
//  GGSPlantform
//
//  Created by min zhang on 16/10/20.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMSGMessage.h>

@interface GGSChatJMessage : NSObject

/** 聊天id */
@property (nonatomic, assign) NSInteger chatId;

/** 用户id */
@property (nonatomic, assign) NSInteger userId;

/** 消息内容 */
@property (nonatomic, strong) NSString *messageText;

/** 创建日期 */
@property (nonatomic, assign) long long createdAt;

/** 聊天内容 */
@property (nonatomic, strong) id chatMessageItem;

- (instancetype)initWithChatMessage:(JMSGMessage *)chatMessage;

+ (instancetype)chatItemWithChatMessage:(JMSGMessage *)chatMessage;

@end
