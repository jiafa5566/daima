//
//  GGSGroupTypeView.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSGroupTypeView : UIView


/**
 <#Description#>

 @param frame <#frame description#>
 @param dataArray <#dataArray description#>
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)dataArray;

/** 点击回调 */
@property (nonatomic, copy) void(^ItemSlectedBlock)(NSInteger indexPath_row);

@end
