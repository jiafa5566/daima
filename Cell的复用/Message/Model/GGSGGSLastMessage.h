//
//  GGSGGSLastMessage.h
//  GGSPlantform
//
//  Created by zhangmin on 2016/6/23.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGSJMessageContent;

@interface GGSGGSLastMessage : NSObject
/**
 *  消息对应的id
 */
@property (nonatomic, assign) NSInteger id;
/**
 *  对应的thared_id
 */
@property (nonatomic, assign) NSInteger thread_id;
/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger user_id;
/**
 *  消息内容
 */
@property (nonatomic, strong) NSString *body;
/**
 *  消息创建的日期
 */
@property (nonatomic, strong) NSString *created_at;
/**
 *  消息更新的日期
 */
@property (nonatomic, strong) NSString *updated_at;
/**
 *  消息删除的日期
 */
@property (nonatomic, strong) NSString *deleted_at;
/**
 *  消息的类型
 */
@property (nonatomic, strong) NSString *type;

- (instancetype)initWithIdTag:(NSInteger)id
                    createdAt:(long long)createAt
                     threadId:(NSInteger)threadId
                       userId:(NSInteger)userId
                         body:(NSString *)body;

- (instancetype)initWithMessageContent:(GGSJMessageContent *)messageConent;


@end
