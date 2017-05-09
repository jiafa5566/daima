//
//  GGSShowMessageAdapter.m
//  GGSPlantform
//
//  Created by min zhang on 2017/3/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSShowMessageAdapter.h"
#import "GGSEmoticonItem.h"
#import "GGSUserInfoManager.h"
#import "GGSDateStringManager.h"

static GGSShowMessageAdapter *_adapter = nil;

@interface GGSShowMessageAdapter ()

@end

@implementation GGSShowMessageAdapter

+ (instancetype)shareAdapter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _adapter = [[GGSShowMessageAdapter alloc] init];
    });
    return _adapter;
}

/**
 通过当前的消息配置显示的艺术字
 
 @param body 当前消息
 @return 返回的艺术字
 */
- (NSMutableAttributedString *)showArtMessageWithMeesageBody:(NSString *)body {
    if ([NSString isBlankString:body]) {
        return [NSMutableAttributedString new];
    }
    
    NSMutableAttributedString *artString = [[NSMutableAttributedString alloc] initWithString:body];
    NSMutableDictionary *parmater = [NSMutableDictionary dictionary];
    // 行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:1.f];
    paragraphStyle1.minimumLineHeight = 25.f;
    paragraphStyle1.alignment = NSTextAlignmentLeft;
    paragraphStyle1.lineBreakMode = NSLineBreakByCharWrapping;
    parmater[NSParagraphStyleAttributeName] = paragraphStyle1;
    // 字间距
    parmater[NSKernAttributeName] = @(0.5f);
    [artString setAttributes:parmater range:NSMakeRange(0, [body length])];
    
    return artString;
}


/**
 通过当前消息的内容配置显示的消息
 
 @param body 纤细内容
 @param staticImageArray 静态图片数组
 @return item
 */
- (NSMutableAttributedString *)staticImageArtStringWithMessageBody:(NSString *)body staticImageArray:(NSMutableArray *)staticImageArray {
        // 处理显示的艺术字
        __block NSMutableAttributedString *artString = [self showArtMessageWithMeesageBody:body];
        [staticImageArray enumerateObjectsUsingBlock:^(GGSEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([body containsString:obj.en_name]) {
                // 显示的艺术字
                artString = [self p_replaceCurrentArtStringWithCompareString:obj.en_name artString:artString imageName:obj.imageName];
                NSLog(@"测试测试 ---- %@", artString);
            }
        }];
        return artString;
}

/** 更换显示的text */
- (NSMutableAttributedString *)p_replaceCurrentArtStringWithCompareString:(NSString *)compareString artString:(NSMutableAttributedString *)artString imageName:(NSString *)imageName {
    NSRange range = [[artString string] rangeOfString:compareString];
    if (range.location != NSNotFound) {
        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        textAtt.bounds = CGRectMake(0, -4.5, 25, 25);
        textAtt.image = [UIImage imageNamed:imageName];
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:textAtt];
        [artString replaceCharactersInRange:range withAttributedString:string];
        // 递归调用
        [self p_replaceCurrentArtStringWithCompareString:compareString artString:artString imageName:imageName];
    }
    return artString;
}


/**
 通过本地发送消息的内容配置发送的消息
 
 @param body 发送消息的内容
 @param staticImageArray 静态图片数组
 @return 需要发送到服务器的消息
 */
- (NSString *)sendToServerStringWithMessageBody:(NSString *)body staticImageArray:(NSMutableArray *)staticImageArray {
    // 获取当前显示的信息类型
    GGSConnectMessageType messageType = [self connectMeesageTypeWithMessageBody:body];
    // 更新相应的约束
    if (messageType == GGSConnectMessageTypeMessageText) {
        // 初始化添加的表情
        return body;
    }
    else if (messageType == GGSConnectMessageTypeStaticImage) {
        // 静态图片
        __block NSString *sendMessage = body;
        [staticImageArray enumerateObjectsUsingBlock:^(GGSEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sendMessage containsString:obj.imageChineseName]) {
                // 替换输入的文字
                sendMessage = [sendMessage stringByReplacingOccurrencesOfString:obj.imageChineseName withString:obj.en_name];
            }
        }];
        body = sendMessage;
        return body;
    }
    return body;
}


/**
 <#Description#>
 
 @param body <#body description#>
 @param connectType <#connectType description#>
 @param staticImageArray <#staticImageArray description#>
 @param threadId <#threadId description#>
 @param isShowLastMessage <#isShowLastImage description#>
 @return <#return value description#>
 */
- (GGSCoachConnectList *)preSendConnectInfoWithMessageBody:(NSString *)body
                                               connectType:(GGSConnectMessageType)connectType
                                          staticImageArray:(NSMutableArray *)staticImageArray
                                                  threadId:(NSInteger)threadId
                                        isShowLastSendTime:(BOOL)isShowLastSendTime
                                                  chatIcon:(NSString *)chatIcon {
    // 配置能显示信息 先做显示如果 发送时显示小圆圈 发送成功再做处理
    GGSCoachConnectList *connectInfo = [[GGSCoachConnectList alloc] init];
    connectInfo.user_id = [[GGSUserInfoManager shareInstance].user_id integerValue];
    // 用户头像数据
    connectInfo.userProfilePic = chatIcon;
    connectInfo.messageType = GGSMessageTypeSendToOthers;
    connectInfo.body = body;
    connectInfo.gifImageName = [self gifImageNameWithImageName:body connectType:connectType];
    // 消息的样式
    connectInfo.connectMessageType = connectType;
    // 显示的内容
    if (connectType == GGSConnectMessageTypeStaticImage) {
        connectInfo.showArtString = [self staticImageArtStringWithMessageBody:body staticImageArray:staticImageArray];
    }
    else if (connectType == GGSConnectMessageTypeMessageText) {
        connectInfo.showArtString = [self showArtMessageWithMeesageBody:body];
    }
    connectInfo.thread_id = threadId;
    connectInfo.created_at = [[NSDate date] timeIntervalSince1970];
    connectInfo.showTime = [GGSDateStringManager showStringWithSecond:connectInfo.created_at];
    // 是否显示最后一条信息的时间
    connectInfo.isShowMessageSendTime = isShowLastSendTime;
    return connectInfo;
}

//- (GGSCoachConnectList *)receiveConnectInfoWith;

/** 根据消息内容设置消息的样式 */
- (GGSConnectMessageType)connectMeesageTypeWithMessageBody:(NSString *)body {
    if ([body hasPrefix:@"[gif:"] && [body hasSuffix:@":]"]) {
        return GGSConnectMessageTypeGifImage;
    }
    else if ([body containsString:@"[:"] && [body containsString:@":]"]) {
        return GGSConnectMessageTypeStaticImage;
    }
    return GGSConnectMessageTypeStaticImage;
}

/**
 通过当前的图片名称 和 消息的样式处理显示的gif图片
 
 @param imageName 图片名称
 @param connectType 链接的样式
 @return gif图片
 */
- (NSString *)gifImageNameWithImageName:(NSString *)imageName
                            connectType:(GGSConnectMessageType)connectType {
    if (connectType == GGSConnectMessageTypeGifImage) {
        imageName = [imageName stringByReplacingOccurrencesOfString:@"[gif:" withString:@""];
        imageName = [imageName stringByReplacingOccurrencesOfString:@":]" withString:@""];
        return imageName;
    }
    return imageName;
}


/**
 最后一条消息显示的内容
 
 @param string 需要配置的消息
 @param staticImageArray 静态表情
 @return item
 */
- (NSString *)connectListShowLastMessageStringWithString:(NSString *)string
                                        staticImageArray:(NSMutableArray *)staticImageArray {
    GGSConnectMessageType connectType = [self connectMeesageTypeWithMessageBody:string];
    if (connectType == GGSConnectMessageTypeGifImage) {
        return @"[动画表情]";
    }
    else if (connectType == GGSConnectMessageTypeStaticImage) {
        __block NSString *showMessageString = string;
        [staticImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGSEmoticonItem *item = (GGSEmoticonItem *)obj;
            if ([showMessageString containsString:item.en_name]) {
                showMessageString = [showMessageString stringByReplacingOccurrencesOfString:item.en_name
                                                                                 withString:item.imageChineseName];
            }
        }];
        return showMessageString;
    }
    return string;
}

@end
