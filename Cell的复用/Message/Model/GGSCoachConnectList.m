//
//  GGSCoachConnectList.m
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSCoachConnectList.h"
#import "GGSUserInfoManager.h"
#import "GGSDateStringManager.h"
#import "GGSJMessageContent.h"

static NSString const *kStaticImageChineseString = @"[笑],[高兴],[大笑],[热情的],[眨眼],[流口水],[接吻],[飞吻],[脸红],[咧着嘴笑],[满意],[戏弄],[吐舌],[说不出话],[酷],[出汗],[放下],[情绪低落],[呸],[焦虑],[担心],[震惊],[哦],[眼泪],[哭],[大声笑],[头晕],[恐怖],[焦虑不安],[生气],[休息],[生病]";

@implementation GGSCoachConnectList

- (void)handelShowItems {
    // 当前的发送消息的类型 判断消息的具体来源
    if (_user_id == [[GGSUserInfoManager shareInstance].user_id integerValue]) {
        _messageType = GGSMessageTypeSendToOthers;
    } else {
        _messageType = GGSMessageTypeSendToMe;
    }
    // 聊天创建的时间 将时间戳显示为具体的时间
    _showTime = [GGSDateStringManager showStringWithSecond:_created_at];
    // 当前消息的样式 hasPrefix hasSuffix判断开头和结尾是否包含字符串
    if ([_body hasPrefix:@"[gif:"] && [_body hasSuffix:@":]"]) {
        _connectMessageType = GGSConnectMessageTypeGifImage;
    }
    else if ([_body containsString:@"[:"] && [_body containsString:@":]"]) {
        _connectMessageType = GGSConnectMessageTypeStaticImage;
    }
    else {
        _connectMessageType = GGSConnectMessageTypeMessageText;
    }
}

+ (instancetype)connectInfoWithMessageContent:(GGSJMessageContent *)messageContent {
    GGSCoachConnectList *connectList = [[GGSCoachConnectList alloc] init];
    connectList.user_id = messageContent.user_id;
    connectList.body = messageContent.body;
    connectList.created_at = messageContent.created_at;
    
    // 当前消息的类型
    if (connectList.user_id == [[GGSUserInfoManager shareInstance].user_id integerValue]) {
        connectList.messageType = GGSMessageTypeSendToOthers;
    } else {
        connectList.messageType = GGSMessageTypeSendToMe;
    }
    // 聊天创建的时间
    connectList.showTime = [GGSDateStringManager showStringWithSecond:connectList.created_at];
    
    // 当前消息的样式
    if ([connectList.body hasPrefix:@"[gif:"] && [connectList.body hasSuffix:@":]"]) {
        connectList.connectMessageType = GGSConnectMessageTypeGifImage;
    }
    else if ([connectList.body containsString:@"[:"] && [connectList.body containsString:@":]"]) {
        connectList.connectMessageType = GGSConnectMessageTypeStaticImage;
    }
    else {
        connectList.connectMessageType = GGSConnectMessageTypeMessageText;
    }
    return connectList;
}

+ (instancetype)preSendconnectInfoWithUserId:(NSInteger)userId
                                 messageBody:(NSString *)messageBody
                                  createTime:(long long)createTime {
    GGSCoachConnectList *connectList = [[GGSCoachConnectList alloc] init];
    connectList.user_id = userId;
    connectList.body = messageBody;
    connectList.created_at = createTime;
    
    
    
    // 当前消息的类型
    if (connectList.user_id == [[GGSUserInfoManager shareInstance].user_id integerValue]) {
        connectList.messageType = GGSMessageTypeSendToOthers;
    } else {
        connectList.messageType = GGSMessageTypeSendToMe;
    }
    // 聊天创建的时间
    connectList.showTime = [GGSDateStringManager showStringWithSecond:connectList.created_at];
    
    // 当前消息的样式
    if ([connectList.body hasPrefix:@"[gif:"] && [connectList.body hasSuffix:@":]"]) {
        connectList.connectMessageType = GGSConnectMessageTypeGifImage;
    }
    else {
        __block BOOL isContain = NO;
        NSArray *array = [kStaticImageChineseString componentsSeparatedByString:@","];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *needString = (NSString *)obj;
            if ([connectList.body containsString:needString]) {
                isContain = YES;
                *stop = YES;
            }
        }];
        
        if (isContain) {
            connectList.connectMessageType = GGSConnectMessageTypeStaticImage;
        } else {
            connectList.connectMessageType = GGSConnectMessageTypeMessageText;
        }
    }
    return connectList;
}

@end
