//
//  GGSBaseNormalTableViewHeader.h
//  GGSPlantform
//
//  Created by min zhang on 2017/2/20.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSBaseNormalTableViewHeader : UITableViewHeaderFooterView
/** 显示的title */
@property (nonatomic, strong) NSString *showTitle;
/** 点击事件 */
@property (nonatomic, copy) void(^ClickBlock)();

+ (GGSBaseNormalTableViewHeader *)headerWithTableView:(UITableView *)tableView;

@end
