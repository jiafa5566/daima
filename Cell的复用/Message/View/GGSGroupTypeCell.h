//
//  GGSGroupTypeCell.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSBaseCollectionViewCell.h"

@interface GGSGroupTypeCell : GGSBaseCollectionViewCell

/** 数据源 */
@property (nonatomic, strong) NSString *itemName;


/** 改变字体的颜色 */
- (void)cell_changeItemTextColor:(BOOL )isChange;

@end
