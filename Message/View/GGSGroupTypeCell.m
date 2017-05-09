//
//  GGSGroupTypeCell.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupTypeCell.h"

@interface GGSGroupTypeCell ()

@property (nonatomic, strong) UILabel *itemLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation GGSGroupTypeCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GGSGroupTypeCell";
    GGSGroupTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GGSGroupTypeCell alloc] init];
    }
    return cell;
}

-(void)setupCellContentSubViews
{
    [self.contentView addSubview:self.itemLabel];
    [self.contentView addSubview:self.lineView];
    __weak typeof(self) weakSelf = self;
    [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.equalTo(@(0.5));
        make.width.equalTo(@(60));
    }];
}
#pragma mark ----- PrivationMethod
- (void)cell_changeItemTextColor:(BOOL)isChange
{
    if (isChange) {
        _lineView.hidden = NO;
        _itemLabel.textColor = HexColor(0xF5A974);
    } else {
        _lineView.hidden = YES;
        _itemLabel.textColor = HexColor(0xcccccc);
    }
}

#pragma mark ----- Setter
- (void)setItemName:(NSString *)itemName
{
    _itemLabel.text = itemName;
}

#pragma mark ----- Getter
- (UILabel *)itemLabel
{
    if (_itemLabel == nil) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.textColor = HexColor(0xcccccc);
    }
    return _itemLabel;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = HexColor(0xF5A974);
        _lineView.hidden = YES;
    }
    return _lineView;
}


@end
