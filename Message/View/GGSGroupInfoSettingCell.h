//
//  GGSGroupInfoSettingCell.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSBaseGroupInfoCell.h"

@interface GGSGroupInfoSettingCell : GGSBaseGroupInfoCell

/** UISwitch选择回调 */
@property (nonatomic, copy) void (^SWitchBlock)(BOOL isSelected);

@end
