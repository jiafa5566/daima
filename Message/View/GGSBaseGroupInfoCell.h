//
//  GGSBaseGroupInfoCell.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSTitleCellData.h"

@interface GGSBaseGroupInfoCell : UITableViewCell

/**  */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 设置选项 */
@property (nonatomic, strong) UILabel *itemLabel;

/**
 *  创建tableViewCell
 *
 *  @param tableView 对应的TableView
 *  @param indexPath 对应的位置
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath;

/**
 *  创建tableView
 *
 *  @param tableView 需要创建的tableView
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  创建cell上面的下级子视图
 */
- (void)setupCellContentSubViews;

/** 数据 */
@property (nonatomic, strong) GGSTitleCellData *celldata;

@end
