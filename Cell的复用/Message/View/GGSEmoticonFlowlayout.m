//
//  GGSEmoticonFlowlayout.m
//  GGSPlantform
//
//  Created by min zhang on 2017/3/1.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSEmoticonFlowlayout.h"

static const NSInteger kEachPageCount = 21;
static const NSInteger kEachRowCount = 7;
static const NSInteger kEachLineCount = 3;
static const NSInteger kTotalHeight = 176;

@interface GGSEmoticonFlowlayout ()

@end

@implementation GGSEmoticonFlowlayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array0 = (NSMutableArray *)[super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:array0];

    for (int i = 1; i < array.count; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = array[i];
        UICollectionViewLayoutAttributes *preLayoutAttributes = array[i-1];
        
        CGRect currentFrame = currentLayoutAttributes.frame;
        currentFrame.origin.x = CGRectGetMaxX(preLayoutAttributes.frame);
        
//        CGFloat beginX = CGRectGetMaxX(preLayoutAttributes.frame);
        
        NSIndexPath *currentIndexPath = currentLayoutAttributes.indexPath;
        
        CGFloat currentX = (currentIndexPath.row / 21) * SCREEN_WIDTH + (currentIndexPath.row % 7) * (SCREEN_WIDTH / (kEachRowCount * 1.0));
        CGFloat currentY = (kTotalHeight / (1.0 * kEachLineCount)) * ((currentIndexPath.row % kEachPageCount) / 7);
        if (currentY >= kTotalHeight) {
            currentY = 0;
        }
        
        currentFrame.origin.x = currentX;
        currentFrame.origin.y = currentY;
        
        currentLayoutAttributes.frame = currentFrame;
    }
    return array;
}

@end
