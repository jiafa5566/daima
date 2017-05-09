//
//  GGSCoachConnectList.h
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGSJMessageContent;

typedef NS_ENUM(NSInteger, GGSMessageType) {
    /** 消息接受者 */
    GGSMessageTypeSendToOthers = 0,
    /** 消息发送者 */
    GGSMessageTypeSendToMe,
};

/**
 发送消息的样式

 - GGSConnetMessageTypeMessageText: 纯文本消息
 - GGSConnetMessageTypeStaticImage: 静态图片
 - GGSConnetMessageTypeGifImage: 动态图片
 */
typedef NS_ENUM(NSInteger, GGSConnectMessageType) {
    GGSConnectMessageTypeMessageText = 0,  // 普通文本
    GGSConnectMessageTypeStaticImage,      // 图片
    GGSConnectMessageTypeGifImage,         // gif动画图片
};

@interface GGSCoachConnectList : NSObject

@property (nonatomic, assign) long long id;

@property (nonatomic, assign) long long thread_id;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, strong) NSString *body;

@property (nonatomic, assign) NSTimeInterval created_at;

@property (nonatomic, strong) NSString *updated_at;

@property (nonatomic, strong) NSString *deleted_at;

////////////// 自己追加字段
/** 用户头像 */
@property (nonatomic, strong) NSString *userProfilePic;

/** 是否显示小时发送时间 */
@property (nonatomic, assign) BOOL isShowMessageSendTime;

/** 显示的艺术字 */
@property (nonatomic, strong) NSMutableAttributedString *showArtString;

/** 显示的动态图名称 */
@property (nonatomic, strong) NSString *gifImageName;

/**
 *  显示时间
 */
@property (nonatomic, strong) NSString *showTime;

/** 消息来源样式 */
@property (nonatomic, assign) GGSMessageType messageType;

/**
 *  返回信息的类型
 */
@property (nonatomic, strong) NSString *type;

/** 消息样式 */
@property (nonatomic, assign) GGSConnectMessageType connectMessageType;

/** 处理显示的数据 */
- (void)handelShowItems;



/************************自增处理方法*************************/
/** 显示消息的具体内容 */
+ (instancetype)connectInfoWithMessageContent:(GGSJMessageContent *)messageContent;
/**  */
+ (instancetype)preSendconnectInfoWithUserId:(NSInteger)userId
                                 messageBody:(NSString *)messageBody
                                  createTime:(long long)createTime;


@end
