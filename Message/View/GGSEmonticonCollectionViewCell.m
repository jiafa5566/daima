//
//  GGSEmonticonCollectionViewCell.m
//  GGSPlantform
//
//  Created by min zhang on 2017/2/28.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSEmonticonCollectionViewCell.h"

#import "GGSEmoticonItem.h"

@interface GGSEmonticonCollectionViewCell ()
/** 表情图片 */
@property (nonatomic , strong) UIImageView *emoticonImageView;

/** 分割线 */
@property (nonatomic, strong) UIView *separotrView;

@end

@implementation GGSEmonticonCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GGSEmonticonCollectionViewCell";
    GGSEmonticonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GGSEmonticonCollectionViewCell alloc] init];
    }
    return cell;
}

- (void)setupCellContentSubViews {
    [self.contentView addSubview:self.emoticonImageView];
//    [self.contentView addSubview:self.separotrView];
//    _emoticonImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    _emoticonImageView.sd_layout
    .centerXEqualToView(self.contentView)
    .centerYEqualToView(self.contentView)
    .widthIs(30)
    .heightIs(30);
    
//    _separotrView.sd_layout
//    .topEqualToView(_emoticonImageView)
//    .bottomEqualToView(_emoticonImageView)
//    .rightSpaceToView(self.contentView, 0)
//    .widthIs(0.5);
}

#pragma mark - Setter
- (void)setEmoticonItem:(GGSEmoticonItem *)emoticonItem {
    _emoticonItem = emoticonItem;
    
    if ([_emoticonItem.imageName hasSuffix:@".gif"]) {
        NSString *name = [_emoticonItem.imageName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
        NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        _emoticonImageView.image = [UIImage imageWithContentsOfFile:file];
    } else {
        _emoticonImageView.image = [UIImage imageNamed:_emoticonItem.imageName];
    }
}

- (void)setIsShowSepatorLineView:(BOOL)isShowSepatorLineView {
    _isShowSepatorLineView = isShowSepatorLineView;
    
//    _separotrView. hidden = !_isShowSepatorLineView;
}

//- (void)setShowImageString:(NSString *)showImageString {
//    _showImageString = showImageString;
//    
//    if ([_showImageString hasSuffix:@".gif"]) {
//        NSString *name = [_showImageString stringByReplacingOccurrencesOfString:@".gif" withString:@""];
//        NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
//        _emoticonImageView.image = [UIImage imageWithContentsOfFile:file];
//    } else {
//         _emoticonImageView.image = [UIImage imageNamed:_showImageString];
//    }
//
////    _emoticonImageView.image = [UIImage imageNamed:_showImageString];
////    [_emoticonImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:_showImageString]];
////    [_emoticonImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:_showImageString]];
//
//}

#pragma mark - Getter
- (UIImageView *)emoticonImageView {
    if (_emoticonImageView == nil) {
        _emoticonImageView = [[UIImageView alloc] init];
        _emoticonImageView.image = [UIImage imageNamed:@"ggs_wechat_share"];
        _emoticonImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _emoticonImageView;
}

- (UIView *)separotrView {
    if (_separotrView == nil) {
        _separotrView = [UIView new];
        _separotrView.backgroundColor = HEXCOLOR(0xe5e5e5);
    }
    return _separotrView;
}

@end
