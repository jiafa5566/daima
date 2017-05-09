//
//  GGSGroupMemberViewCell.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/4.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSBaseTableViewCell.h"

@interface GGSGroupMemberViewCell : GGSBaseTableViewCell

/** 数据 */
@property (nonatomic, strong) NSString *data;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
