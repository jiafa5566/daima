//
//  GGSChatMessageCell.h
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSBaseTableViewCell.h"

@interface GGSChatMessageCell : GGSBaseTableViewCell

/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 昵称 */
@property (nonatomic, strong) UILabel *userlabel;


/** 最后一条信息 */
@property (nonatomic, strong) UILabel *textlabel;
/** 最后一条信息的日期 */
@property (nonatomic, strong) UILabel *datelabel;

/**  */
@property (nonatomic, strong) id data;

@end
