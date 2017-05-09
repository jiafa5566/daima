//
//  GGSUserThread.m
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSUserThread.h"
#import "GGSUserInfoManager.h"
#import "GGSParticipants.h"
#import "GGSGGSLastMessage.h"
#import "GGSDateStringManager.h"
#import <MJExtension/MJExtension.h>

@interface GGSUserThread ()

/** 当前用户的头像 */
@property (nonatomic, strong) NSString *currentUserPic;
/** 其他聊天的用户头像 */
@property (nonatomic, strong) NSString *chatPic;
/** 用户名 */
@property (nonatomic, strong) NSString *userName;
/** 其他聊天用户的用户名 */
@property (nonatomic, strong) NSString *chatUserName;
/** 其他聊天用户的用户名 */
@property (nonatomic, assign) NSInteger chatId;

@end

@implementation GGSUserThread

//- (NSString *)currentUserPic {
//    if ([NSString isBlankString:_currentUserPic]) {
//        NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
//        __block NSString *userProfile = @"";
//        [_participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.user_id == userId) {
//                userProfile = obj.profile_pic;
//                *stop = YES;
//            }
//        }];
//        _currentUserPic = userProfile;
//    }
//    return _currentUserPic;
//}

//- (NSString *)chatPic {
//    if ([NSString isBlankString:_chatPic]) {
//        NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
//        __block NSString *userProfile = @"";
//        [_participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.user_id != userId) {
//                userProfile = obj.profile_pic;
//                *stop = YES;
//            }
//        }];
//        _chatPic = userProfile;
//    }
//    return _chatPic;
//}

//- (NSString *)userName {
//    if ([NSString isBlankString:_userName]) {
//        NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
//        __block NSString *userName = @"";
//        [_participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.user_id == userId) {
//                userName = obj.name;
//                if ([NSString isBlankString:obj.name]) {
//                    userName = obj.username;
//                }
//                *stop = YES;
//            }
//        }];
//        _userName = userName;
//    }
//    return _userName;
//}

//- (NSString *)chatUserName {
//    if ([NSString isBlankString:_chatUserName]) {
//        __block NSString *userName = @"聊天群";
//        if (_participants.count > 2) {
//            if ([NSString isBlankString:_subject] == NO) {
//                userName = _subject;
//            } else {
//                userName = @"聊天群";
//            }
//        } else {
//            NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
//            [_participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.user_id != userId) {
//                    if ([NSString isBlankString:obj.name] == NO && [obj.name isKindOfClass:[NSString class]]) {
//                        NSLog(@"%@", obj.name);
//                        userName = [NSString stringWithFormat:@"%@", [obj.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                    } else {
//                        if ([NSString isBlankString:obj.username] == NO) {
//                            userName = obj.username;
//                        } else {
//                            userName = @"神秘用户";
//                        }
//                    }
//                    *stop = YES;
//                }
//            }];
//        }
//        _chatUserName = userName;
//    }
//    return _chatUserName;
//}

//- (NSInteger)chatId {
//    if (_chatId <= 0) {
//        __block NSInteger chatId = 0;
//        NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
//        [_participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.user_id != userId) {
//                chatId = obj.user_id;
//                *stop = YES;
//            }
//        }];
//        _chatId = chatId;
//    }
//    return _chatId;
//}

- (void)handelShowItem {
    // 最后一条信息发送时间
    // 聊天下级数组
    NSMutableArray *participantsArray = [NSMutableArray array];
    __block NSString *chatIcon = @"";
    __block NSString *currentUserIcon = @"";
    __block NSString *chatUserName = @"";
    __block NSString *currentUserName = @"";
    __block NSInteger chatId = 0;
    
    NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
    [_participants enumerateObjectsUsingBlock:^(id  _Nonnull itemObj, NSUInteger idx, BOOL * _Nonnull stop) {
        GGSParticipants *participants = [GGSParticipants mj_objectWithKeyValues:itemObj];
        [participantsArray addObject:participants];
        if (userId != participants.user_id) {
            chatId = participants.user_id;

            chatIcon = participants.profile_pic;
            // 用户名
            if ([NSString isBlankString:participants.name] == NO) {
                chatUserName = participants.name;
            } else {
                if ([NSString isBlankString:participants.username] == NO) {
                    chatUserName = participants.username;
                } else {
                    chatUserName = @"神秘用户";
                }
            }
        } else if (userId == participants.user_id) {
            // 头像
            currentUserIcon = participants.profile_pic;
            // 用户名
            if (participantsArray.count > 2) {
                currentUserName = @"聊天群";
            } else {
                if ([NSString isBlankString:participants.name] == NO) {
                    currentUserName = participants.name;
                } else {
                    if ([NSString isBlankString:participants.username] == NO) {
                        currentUserName = participants.username;
                    } else {
                        currentUserName = @"神秘用户";
                    }
                }
            }
        }
    }];
    _userName = currentUserName;
    _currentUserPic = currentUserIcon;
    _chatUserName = chatUserName;
    _chatPic = chatIcon;
    _chatId = chatId;
    
    // 处理最后一条显示信息
    _last_message = [GGSGGSLastMessage mj_objectWithKeyValues:_last_message];
    // 谈话内容
    _participants = participantsArray;
    // 最后一条信息显示时间
    _lastMessageShowTime = [GGSDateStringManager zm_messageListTimeWithSecond:_last_message_time];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ggs_emoticon_compareKeyValues" ofType:@".plist"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    __block NSString *lastMessage = _last_message.body;
    __block BOOL isStaticImage = NO;
    [dictionary.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([lastMessage containsString:obj]) {
            NSString *value = dictionary[obj];
            if ([NSString isBlankString:value] == NO) {
                lastMessage = [lastMessage stringByReplacingOccurrencesOfString:obj withString:value];
            }
            isStaticImage = YES;
        }
    }];
    
    if ([_last_message.body containsString:@"[gif:"] && [_last_message.body containsString:@":]"]) {
        _messageType = GGSConnectMessageTypeGifImage;
    } else if (isStaticImage) {
        _messageType = GGSConnectMessageTypeStaticImage;
        _last_message.body = lastMessage;
    }
}

/** 判断当前的用户信息是否有效 */
- (BOOL)isCurrentThreadDataAvaliable {
    BOOL isThreadNotNil = (_last_message != nil) && (_participants.count >= 2) && (_last_message_time != 0);
    return isThreadNotNil;
}

@end
