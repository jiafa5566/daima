//
//  GGSPTPusherData.h
//  GGSPlantform
//
//  Created by min zhang on 16/9/12.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGSThreadSubItem;

@interface GGSPTPusherData : NSObject
/**
 *  推送消息类型
 */
@property (nonatomic, strong) NSString *body;
/**
 *  创建日期
 */
@property (nonatomic, assign) NSTimeInterval created_at;
/**
 *  chuangjian
 */
@property (nonatomic, assign) NSInteger id;
/**
 *  创建的类型
 */
@property (nonatomic, strong) GGSThreadSubItem *thread;
/**
 *  创建的threadId
 */
@property (nonatomic, assign) NSInteger thread_id;
/**
 *  消息类型
 */
@property (nonatomic, strong) NSString *type;
/**
 *  更新日期
 */
@property (nonatomic, assign) NSTimeInterval updated_at;
/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger user_id;

@end
