//
//  GGSChooseMessageTypeView.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSChooseMessageTypeView.h"

#import "GGSShareItemCollectionViewCell.h"
#import "GGSBaseTitleCellData.h"
@interface GGSChooseMessageTypeView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *listDataArray;
@end

@implementation GGSChooseMessageTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsLayout];
    }
    return self;
}

/** 添加子视图 */
- (void)setupSubViewsLayout
{
    [self addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, (SCREEN_WIDTH - 212) / 4, 0, (SCREEN_WIDTH - 212) / 4));
    }];
}

#pragma mark ----- UICOllectionViewDelegate
- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGSShareItemCollectionViewCell *cell = [GGSShareItemCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.cellData = self.listDataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectBlock) {
        self.didSelectBlock(indexPath.row);
    }
}

- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark ----- Getter
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH - 212) / 4;
        flowLayout.itemSize = CGSizeMake(64, 80);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        static NSString *identifier = @"GGSShareItemCollectionViewCell";
        [_collectionView registerClass:[GGSShareItemCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

- (NSMutableArray *)listDataArray
{
    if (_listDataArray == nil) {
        _listDataArray = [NSMutableArray array];
        GGSBaseTitleCellData *cellData0 = [[GGSBaseTitleCellData alloc] initLeftImage:@"ggs_wechat_share"
                                                                            leftTitle:@"全部"
                                                                      isShowAccessory:NO
                                                                               destVC:nil];
        GGSBaseTitleCellData *cellData1 = [[GGSBaseTitleCellData alloc] initLeftImage:@"ggs_wechat_friend"
                                                                            leftTitle:@"通知"
                                                                      isShowAccessory:NO
                                                                               destVC:nil];
        GGSBaseTitleCellData *cellData2 = [[GGSBaseTitleCellData alloc] initLeftImage:@"ggs_weibo_share"
                                                                            leftTitle:@"群"
                                                                      isShowAccessory:NO
                                                                               destVC:nil];
        [_listDataArray addObjectsFromArray:@[cellData0,cellData1,cellData2]];
    }
    return _listDataArray;
}
@end
