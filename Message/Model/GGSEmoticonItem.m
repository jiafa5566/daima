//
//  GGSEmoticonItem.m
//  GGSPlantform
//
//  Created by min zhang on 2017/3/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSEmoticonItem.h"

@implementation GGSEmoticonItem

- (instancetype)initWithImageName:(NSString *)imageName
                  imageChieseName:(NSString *)imageChineseName
                           enName:(NSString *)enName {
    self = [super init];
    if (self) {
        _imageName = imageName;
        _imageChineseName = imageChineseName;
        _en_name = enName;
    }
    return self;
}

+ (instancetype)emoticonWithImageName:(NSString *)imageName
                     imageChineseName:(NSString *)imageChineseName
                               enName:(NSString *)enName {
    return [[self alloc] initWithImageName:imageName
                           imageChieseName:imageChineseName
                                    enName:enName];
}

@end
