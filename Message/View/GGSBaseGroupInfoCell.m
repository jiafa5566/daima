//
//  GGSBaseGroupInfoCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSBaseGroupInfoCell.h"

@implementation GGSBaseGroupInfoCell

/**
 *  创建tableViewCell
 *
 *  @param tableView 对应的TableView
 *  @param indexPath 对应的位置
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GGSBaseGroupInfoCell";
    GGSBaseGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSBaseGroupInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"GGSBaseGroupInfoCell";
    GGSBaseGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSBaseGroupInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCellContentSubViews];
        self.backgroundColor = kWHITE_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//- (instancetype)init {
//    static NSString *identifier = @"";
//    return [self initWithStyle:UITableViewCellStyleDefault
//               reuseIdentifier:<#(nullable NSString *)#>];
//}

/**
 *  创建cell上面的下级子视图
 */
- (void)setupCellContentSubViews
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.itemLabel];
    __weak typeof(self) weakSelf = self;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        make.width.equalTo(weakSelf.iconImageView.mas_height);
    }];
    [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HexColor(0xcccccc);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark ----- Setter
- (void)setCelldata:(GGSTitleCellData *)celldata
{
    _itemLabel.text = celldata.leftTitle;
}

#pragma mark ----- Getter
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 12.5;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.backgroundColor = HexColor(0x73C7F2);
    }
    return _iconImageView;
}

- (UILabel *)itemLabel
{
    if (_itemLabel == nil) {
        _itemLabel = [[UILabel alloc] init];
    }
    return _itemLabel;
}
@end
