//
//  GGSJMessageContent.m
//  GGSPlantform
//
//  Created by min zhang on 16/10/26.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSJMessageContent.h"
#import <MJExtension/MJExtension.h>

@implementation GGSJMessageContent

/** 创建数据模型 */
- (instancetype)initWithMessage:(JMSGMessage *)message {
    self = [super init];
    if (self) {
        NSDictionary *dictionary = [[message.content toJsonString] mj_JSONObject];
        if ([dictionary isKindOfClass:[NSDictionary class]] && dictionary != nil) {
            _id = [dictionary[@"id"] integerValue];
            _created_at = [dictionary[@"created_at"] longLongValue];
            _thread_id = [dictionary[@"thread_id"] integerValue];
            _user_id = [dictionary[@"user_id"] integerValue];
            _body = dictionary[@"body"];
            _content_text = dictionary[@"content_text"];
        }
    }
    return self;
}

+ (instancetype)messageContentWithMessage:(JMSGMessage *)message {
    return [[self alloc] initWithMessage:message];
}

/** 创建发送信息的模型 */
- (JMSGMessage *)createMessageConnectWithUserId:(NSInteger)userId
                                          idTag:(NSInteger)idTag
                                       threadId:(NSInteger)threadId
                                      createdAt:(long long)createdAt
                                           body:(NSString *)body
                                    contentText:(NSString *)contentText
                                         chatId:(NSInteger)chatId {
    
    NSDictionary *parmater = @{@"id" : [NSString stringWithFormat:@"%ld", idTag],
                       @"created_at" : [NSString stringWithFormat:@"%lld", createdAt],
                        @"thread_id" : [NSString stringWithFormat:@"%ld", threadId],
                          @"user_id" : [NSString stringWithFormat:@"%ld", userId],
                             @"body" : body,
                     @"content_text" : contentText};
    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:parmater];
//    if (messageType == GGSSendMessageTypeGIF) {
//        [dictionary addEntriesFromDictionary:@{
//                                               @"type" : @"gif"
//                                               }];
//    }
//
//    
//    JMSGTextContent *abstractConent = [[JMSGTextContent alloc] initWithText:body];
    JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:parmater];
    
    
    // 添加字段
//    [abstractConent addStringExtra:[NSString stringWithFormat:@"%ld", idTag] forKey:@"id"];
//    [abstractConent addStringExtra:[NSString stringWithFormat:@"%lld", createdAt] forKey:@"created_at"];
//    [abstractConent addStringExtra:[NSString stringWithFormat:@"%ld", threadId] forKey:@"thread_id"];
//    [abstractConent addStringExtra:[NSString stringWithFormat:@"%ld", userId] forKey:@"user_id"];
//    [abstractConent addStringExtra:body forKey:@"body"];
//    [abstractConent addStringExtra:contentText forKey:@"content_text"];
    
    NSString *connectUserName = [NSString stringWithFormat:@"gogosu_%ld", chatId];
    JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:customContent username:connectUserName];
    return message;
}

@end
