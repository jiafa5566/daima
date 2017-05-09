//
//  GGSGroupTypeView.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupTypeView.h"
#import "GGSGroupTypeCell.h"
@interface GGSGroupTypeView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;

@end

@implementation GGSGroupTypeView

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = dataArray;
        [self setUpSubViewsLayout];
    }
    return self;
}

/** 添加下级视图 */
- (void)setUpSubViewsLayout
{
    [self addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ----- UICOllectionViewDelegate
- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGSGroupTypeCell *cell = [GGSGroupTypeCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.itemName = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGSGroupTypeCell *cell0 = (GGSGroupTypeCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GGSGroupTypeCell *cell1 = (GGSGroupTypeCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (indexPath.row == 0) {
        [cell0 cell_changeItemTextColor:YES];
        [cell1 cell_changeItemTextColor:NO];
    }
    if (indexPath.row == 1) {
        [cell0 cell_changeItemTextColor:NO];
        [cell1 cell_changeItemTextColor:YES];
    }

    if (self.ItemSlectedBlock) {
        self.ItemSlectedBlock(indexPath.row);
    }
}

- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 60, 0, 60);
}


#pragma mark ----- Getter
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 120)/(self.dataArray.count * 1.0), 35);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        static NSString *identifier = @"GGSGroupTypeCell";
        [_collectionView registerClass:[GGSGroupTypeCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

- (NSMutableArray<NSString *> *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
