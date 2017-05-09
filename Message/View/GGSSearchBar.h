//
//  GGSSearchBar.h
//  GGSPlantform
//
//  Created by min zhang on 2017/3/1.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSSearchBar : UITextField

- (instancetype)initWithFrame:(CGRect)frame;

/** 设置占位字符 */
@property (nonatomic, strong) NSString *placeArtString;

@end
