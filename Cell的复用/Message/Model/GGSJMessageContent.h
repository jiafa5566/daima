//
//  GGSJMessageContent.h
//  GGSPlantform
//
//  Created by min zhang on 16/10/26.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>

@interface GGSJMessageContent : NSObject

//"id" : "9401",
//"created_at" : "1477457704",
//"thread_id" : "1348",
//"user_id" : "5447",
//"body" : "13",
//"content_text" : "[自定义消息]"

/** 用户id */
@property (nonatomic, assign) long long id;

/** 创建日期 */
@property (nonatomic, assign) long long created_at;

/** 用户id */
@property (nonatomic, assign) long long thread_id;

/** 用户id */
@property (nonatomic, assign) NSInteger user_id;

/** 消息内容 */
@property (nonatomic, strong) NSString *body;

/** 消息类型 */
@property (nonatomic, strong) NSString *content_text;


/** 创建数据模型 */
- (instancetype)initWithMessage:(JMSGMessage *)message;

+ (instancetype)messageContentWithMessage:(JMSGMessage *)message;

/** 创建发送信息的模型 */
- (JMSGMessage *)createMessageConnectWithUserId:(NSInteger)userId
                                          idTag:(NSInteger)idTag
                                       threadId:(NSInteger)threadId
                                      createdAt:(long long)createdAt
                                           body:(NSString *)body
                                    contentText:(NSString *)contentText
                                         chatId:(NSInteger)chatId;


@end
