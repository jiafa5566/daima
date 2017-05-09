//
//  GGSChatJMessage.m
//  GGSPlantform
//
//  Created by min zhang on 16/10/20.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSChatJMessage.h"
#import <MJExtension/MJExtension.h>
#import "GGSPTPusherData.h"
#import "GGSThreadSubItem.h"


@implementation GGSChatJMessage

//
- (instancetype)initWithChatMessage:(JMSGMessage *)chatMessage {
    self = [super init];
    if (self) {
        
        NSDictionary *jsonDictioanry = [[chatMessage toJsonString] mj_JSONObject];
        if ([jsonDictioanry isKindOfClass:[NSDictionary class]] && jsonDictioanry != nil) {
            // 用户id
            NSString *userId = jsonDictioanry[@"target_id"];
            _userId = [[userId stringByReplacingOccurrencesOfString:@"gogosu_" withString:@""] integerValue];
            // 聊天id
            NSString *chatId = jsonDictioanry[@"from_id"];
            _chatId = [[chatId stringByReplacingOccurrencesOfString:@"gogosu_" withString:@""] integerValue];
            // 创建时间
            _createdAt = [jsonDictioanry[@"create_time"] longLongValue] / 1000;
            // 聊天内容
            NSDictionary *textDicitonary = [jsonDictioanry[@"msg_body"] mj_JSONObject];
            if ([textDicitonary isKindOfClass:[NSDictionary class]] && textDicitonary != nil) {
                id text = [textDicitonary[@"text"] mj_JSONObject];
                if (text != nil) {
                    // 处理不同类型的消息
                    if ([text isKindOfClass:[NSString class]]) {
                        _messageText = text;
                        _chatMessageItem = text;
                    } else if ([text isKindOfClass:[NSDictionary class]]) {
                        GGSPTPusherData *pusherData = [GGSPTPusherData mj_objectWithKeyValues:text];
                        pusherData.created_at = _createdAt;
                        pusherData.thread = [GGSThreadSubItem mj_objectWithKeyValues:pusherData.thread];
                        _chatMessageItem = pusherData;
                    }
                } else {
                    NSString *text = textDicitonary[@"text"];
                    if ([NSString isBlankString:text] == NO) {
                        _messageText = text;
                        _chatMessageItem = text;
                    }
                }
            }
        }
    }
    return self;
}

+ (instancetype)chatItemWithChatMessage:(JMSGMessage *)chatMessage {
    return [[self alloc] initWithChatMessage:chatMessage];
}

@end
