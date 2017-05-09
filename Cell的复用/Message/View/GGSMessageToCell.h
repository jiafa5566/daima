//
//  GGSMessageToCell.h
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSBaseTableViewCell.h"
@class GGSCoachConnectList;


@interface GGSMessageToCell : GGSBaseTableViewCell
// 用户聊天信息
@property (nonatomic, strong) GGSCoachConnectList *connectList;

@property (nonatomic, assign) CGFloat height;
/**
 *  返回教练的id
 */
@property (nonatomic, copy) void(^IconBlock)();

/**
 *  开启转圈动画
 */
- (void)startAnimation;

/**
 *  关闭转圈动画
 */
- (void)endAnimation;
@end
