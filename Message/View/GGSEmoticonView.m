//
//  GGSEmoticonView.m
//  GGSPlantform
//
//  Created by min zhang on 2017/2/28.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSEmoticonView.h"

#import "GGSEmonticonCollectionViewCell.h"
#import "GGSEmoticonFlowlayout.h"
#import "GGSEmoticonItem.h"
#import "GGSDesignPageControl.h"

/** 表情collectionView的标签 */
static const NSInteger kEmonticonCollectionViewTag = 100024;
/** 底部collectionView的标签 */
static const NSInteger kBottomCollectionViewTag = 100025;
/** 每页显示的个数 */
static const NSInteger kEachPageShowCount = 21;

@interface GGSEmoticonView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

/** 表情 */
@property (nonatomic, strong) UICollectionView *emonticonCollectionView;
/** 底部包含按钮 */
@property (nonatomic, strong) UIView *bottomContainerView;
/** 底部滑动图 */
@property (nonatomic, strong) UICollectionView *bottomCollectionView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** 分页包含视图 */
@property (nonatomic, strong) GGSDesignPageControl *pageControl;
/** 底部表情图片 */
@property (nonatomic, strong) NSMutableArray *bottomEmoticonArray;
///** 选中的位置 */
//@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@property (nonatomic, weak) id<GGSEmoticonDelegate> delegate;

@end

@implementation GGSEmoticonView

@synthesize emoticonArray = _emoticonArray;

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:CGRectZero delegate:nil bottomEmotionArray:[NSMutableArray array]];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<GGSEmoticonDelegate>)delegate
           bottomEmotionArray:(NSMutableArray *)bottomEmotionArray {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _bottomEmoticonArray = bottomEmotionArray;
        [self p_setupSubViews];
    }
    return self;
}

#pragma mark - UICollectionViewDataSrouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case kEmonticonCollectionViewTag:
        {
            return self.emoticonArray.count;
        }
        case kBottomCollectionViewTag:
        {
            return self.bottomEmoticonArray.count;
        }
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGSEmonticonCollectionViewCell *cell = [GGSEmonticonCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    switch (collectionView.tag) {
        case kEmonticonCollectionViewTag:
        {
            if (indexPath.row < _emoticonArray.count) {
                cell.emoticonItem = _emoticonArray[indexPath.row];
            }
            cell.backgroundColor = HEXCOLOR(0xf5f5f7);
            cell.isShowSepatorLineView = NO;
        }
            break;
        case kBottomCollectionViewTag:
        {
            if (indexPath.row < _bottomEmoticonArray.count) {
                cell.emoticonItem = _bottomEmoticonArray[indexPath.row];
            }
            if (indexPath.row == _defaultSelectedIndex) {
                cell.backgroundColor = HEXCOLOR(0xf5f5f7);
                cell.isShowSepatorLineView = NO;
            } else {
                cell.backgroundColor = [UIColor whiteColor];
                cell.isShowSepatorLineView = YES;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (collectionView.tag) {
        case kEmonticonCollectionViewTag:
        {
            if ([self.delegate respondsToSelector:@selector(emotiocnView:didClickedItemAtIndex:bottomIndex:)]) {
                [self.delegate emotiocnView:self didClickedItemAtIndex:indexPath.row bottomIndex:_defaultSelectedIndex];
            }
        }
            break;
        case kBottomCollectionViewTag:
        {
            // 默认选中位置
            self.defaultSelectedIndex = indexPath.row;
//            // 改变测得颜色
//            if (_lastSelectedIndexPath == nil) {
//                GGSEmonticonCollectionViewCell *cell = (GGSEmonticonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//                cell.backgroundColor = HEXCOLOR(0xf5f5f7);
//                cell.isShowSepatorLineView = NO;
//                _lastSelectedIndexPath = indexPath;
//            } else if (_lastSelectedIndexPath != indexPath) {
//                GGSEmonticonCollectionViewCell *lastSelectedCell = (GGSEmonticonCollectionViewCell *)[collectionView cellForItemAtIndexPath:_lastSelectedIndexPath];
//                lastSelectedCell.backgroundColor = [UIColor whiteColor];
//                lastSelectedCell.isShowSepatorLineView = YES;
//                GGSEmonticonCollectionViewCell *currentSelectedCell = (GGSEmonticonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//                currentSelectedCell.backgroundColor = HEXCOLOR(0xf5f5f7);
//                currentSelectedCell.isShowSepatorLineView = NO;
//                _lastSelectedIndexPath = indexPath;
//            }
            if ([self.delegate respondsToSelector:@selector(emotiocnView:didClickedBottomItemAtIndex:)]) {
                [self.delegate emotiocnView:self didClickedBottomItemAtIndex:indexPath.row];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewFlowlayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (collectionView.tag) {
        case kEmonticonCollectionViewTag:
        {
            return CGSizeMake((SCREEN_WIDTH/7.0), (250 - 74) / 3.0);
        }
        case kBottomCollectionViewTag:
        {
            return CGSizeMake(44, 44);
        }
        default:
            return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _emonticonCollectionView) {
        // 设置当前分页数
        NSInteger offSetXIndex = (_emonticonCollectionView.contentOffset.x  + (SCREEN_WIDTH * 0.5)) / SCREEN_WIDTH;
        _pageControl.currentPage = offSetXIndex;
        NSLog(@"%.f----%ld", scrollView.contentOffset.x, offSetXIndex);
    }
}

#pragma mark - ActionEvent
- (void)sendButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sendCurrentInputText)]) {
        [self.delegate sendCurrentInputText];
    }
}

#pragma mark - PrivateMethod
- (void)p_setupSubViews {
    [self addSubview:self.emonticonCollectionView];
    [self addSubview:self.pageControl];
    [self addSubview:self.bottomContainerView];
    [_bottomContainerView addSubview:self.bottomCollectionView];
    [_bottomContainerView addSubview:self.sendButton];
    
    _bottomContainerView.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .heightRatioToView(self, (44/250.0));
    
    _bottomCollectionView.sd_layout
    .topSpaceToView(_bottomContainerView, 0)
    .leftEqualToView(_bottomContainerView)
    .bottomEqualToView(_bottomContainerView)
    .rightSpaceToView(_bottomContainerView, 60);
    
    _sendButton.sd_layout
    .topEqualToView(_bottomContainerView)
    .bottomEqualToView(_bottomContainerView)
    .rightEqualToView(_bottomContainerView)
    .widthIs(60);
    
    _pageControl.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomSpaceToView(_bottomContainerView, 0)
    .heightRatioToView(self, (30/250.0));
    
    _emonticonCollectionView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .bottomSpaceToView(_pageControl, 0)
    .rightEqualToView(self);
    
    [self.bottomCollectionView reloadData];
    [self.emonticonCollectionView reloadData];
    
    _bottomContainerView.backgroundColor = HEXCOLOR(0xe5e5e5);
}

- (UICollectionView *)p_createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collecitonView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collecitonView.delegate = self;
    collecitonView.dataSource = self;
    collecitonView.bounces = NO;
    collecitonView.pagingEnabled = YES;
    collecitonView.showsVerticalScrollIndicator = NO;
    collecitonView.showsHorizontalScrollIndicator = NO;
    collecitonView.backgroundColor = kBACKGROUND_COLOR;
    return collecitonView;
}

- (void)changeSendButtonStateWithCurrentText:(NSString *)text {
    if ([NSString isBlankString:text] == NO && _defaultSelectedIndex == 0) {
        _sendButton.backgroundColor = HEXCOLOR(0x0076ff);
        _sendButton.userInteractionEnabled = YES;
    } else {
        _sendButton.backgroundColor = HEXCOLOR(0xcccccc);
        _sendButton.userInteractionEnabled = NO;
    }
}

#pragma mark - Setter
- (void)setEmoticonArray:(NSMutableArray *)emoticonArray {
    _emoticonArray = emoticonArray;
    
    NSInteger totalPageCount = 0;
    if ((_emoticonArray.count % kEachPageCount) == 0) {
        totalPageCount = _emoticonArray.count / kEachPageCount;
    } else {
        totalPageCount = _emoticonArray.count / kEachPageCount + 1;
    }
    
    _pageControl.numberOfPages = totalPageCount;
    _pageControl.currentPage = 0;
    
    [self.emonticonCollectionView setContentOffset:CGPointZero animated:NO];
    [self.emonticonCollectionView reloadData];
}

- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    _defaultSelectedIndex = defaultSelectedIndex;
    
//    if (_defaultSelectedIndex == 0 && _bottomEmoticonArray.count) {
////        _lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        
//        // 设置默认选中位置
////        [self collectionView:self.bottomCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:_defaultSelectedIndex inSection:0]];
//    } else if (_defaultSelectedIndex == 1) {
//        [self changeSendButtonStateWithCurrentText:@""];
//    }
    [self.bottomCollectionView reloadData];
}

#pragma mark - Getter
- (UICollectionView *)emonticonCollectionView {
    if (_emonticonCollectionView == nil) {
        GGSEmoticonFlowlayout *flowLayout = [[GGSEmoticonFlowlayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _emonticonCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _emonticonCollectionView.delegate = self;
        _emonticonCollectionView.dataSource = self;
        _emonticonCollectionView.showsVerticalScrollIndicator = NO;
        _emonticonCollectionView.showsHorizontalScrollIndicator = NO;
        _emonticonCollectionView.backgroundColor = kBACKGROUND_COLOR;
        _emonticonCollectionView.pagingEnabled = YES;
        _emonticonCollectionView.bounces = NO;
        _emonticonCollectionView.tag = kEmonticonCollectionViewTag;
        NSString *identifier = @"GGSEmonticonCollectionViewCell";
        [_emonticonCollectionView registerClass:[GGSEmonticonCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _emonticonCollectionView;
}

- (UIView *)bottomContainerView {
    if (_bottomContainerView == nil) {
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomContainerView;
}

- (UICollectionView *)bottomCollectionView {
    if (_bottomCollectionView == nil) {
        _bottomCollectionView = [self p_createCollectionView];
        _bottomCollectionView.tag = kBottomCollectionViewTag;
        _bottomCollectionView.backgroundColor = kLOGO_BACKGROUNDCOLOR;
        NSString *identifier = @"GGSEmonticonCollectionViewCell";
        [_bottomCollectionView registerClass:[GGSEmonticonCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _bottomCollectionView;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton zm_buttonWithTitle:@"发送"
                                              font:14
                                   bakcgroundColor:kCTAMAINCOLOR
                                            target:self
                                            action:@selector(sendButtonClicked:)];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _sendButton;
}

- (GGSDesignPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[GGSDesignPageControl alloc] init];
        _pageControl.backgroundColor = HEXCOLOR(0xf5f5f7);
        _pageControl.pageIndicatorTintColor = HEXCOLOR(0xcccccc);
        _pageControl.currentPageIndicatorTintColor = HEXCOLOR(0xfed16a);
        NSInteger totalCount = self.emoticonArray.count / kEachPageCount;
        if ((_emoticonArray.count % kEachPageCount) > 0) {
            totalCount = totalCount + 1;
        }
        _pageControl.numberOfPages = totalCount;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

@end
