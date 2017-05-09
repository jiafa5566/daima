//
//  GGSGroupInfoDetailCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupInfoDetailCell.h"
@interface GGSGroupInfoDetailCell()
/** 右侧显示信息 */
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation GGSGroupInfoDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GGSGroupInfoDetailCell";
    GGSGroupInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSGroupInfoDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews
{
    [super setupCellContentSubViews];
    [self.contentView addSubview:self.contentLabel];
    __weak typeof(self) weakSelf = self;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
}
#pragma mark ----- Setter
- (void)setCelldata:(GGSTitleCellData *)celldata
{
    self.itemLabel.text = celldata.leftTitle;
    _contentLabel.text = celldata.rightTitle;
}

#pragma mark ----- Getter
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}
@end
