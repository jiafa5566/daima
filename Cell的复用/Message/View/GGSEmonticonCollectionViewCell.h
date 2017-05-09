//
//  GGSEmonticonCollectionViewCell.h
//  GGSPlantform
//
//  Created by min zhang on 2017/2/28.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSBaseCollectionViewCell.h"

@class GGSEmoticonItem;

@interface GGSEmonticonCollectionViewCell : GGSBaseCollectionViewCell

/** 显示的item */
@property (nonatomic, strong) GGSEmoticonItem *emoticonItem;

/** 是否显示分割线 */
@property (nonatomic, assign) BOOL isShowSepatorLineView;

@end
