//
//  GGSConnectListCell.h
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSBaseTableViewCell.h"
@class GGSUserThread;

@interface GGSConnectListCell : GGSBaseTableViewCell
/** 用户交流信息 */
@property (nonatomic, strong) GGSUserThread *userConnectInfo;

@end
