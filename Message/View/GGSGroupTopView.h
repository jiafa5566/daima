//
//  GGSGroupTopView.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSGroupTopView : UIView

/** 群名称 群号设置 */
@property (nonatomic, strong) id groupInfo;

/** 点击按钮回调 */
@property (nonatomic, copy) void (^selectedBlock) (NSInteger selected_index);

@end
