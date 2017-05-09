//
//  GGSDesignPageControl.m
//  GGSPlantform
//
//  Created by min zhang on 2017/3/9.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSDesignPageControl.h"

@implementation GGSDesignPageControl


- (void)setCurrentPage:(NSInteger)currentPage {
    
    [super setCurrentPage:currentPage];
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *imageView = self.subviews[i];
        CGSize needSize = CGSizeMake(7, 7);
        CGRect remakeFrame = CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMinY(imageView.frame), needSize.width, needSize.height);
        imageView.frame = remakeFrame;
        
//        if (i == self.currentPage) {
//            imageView.image =
//        }
    }
}

@end
