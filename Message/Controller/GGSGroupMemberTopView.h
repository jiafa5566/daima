//
//  GGSGroupMemberTopView.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSGroupMemberTopView : UIView

/**
 <#Description#>

 @param frame <#frame description#>
 @param dataArray <#dataArray description#>
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame sourceArray:(NSMutableArray *)dataArray;
/** 点击回调 */
@property (nonatomic, strong) void(^selectedBlock) (NSInteger indexNumber);
@end
