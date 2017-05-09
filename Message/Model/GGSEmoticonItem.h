//
//  GGSEmoticonItem.h
//  GGSPlantform
//
//  Created by min zhang on 2017/3/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGSEmoticonItem : NSObject

/** 图片名称 */
@property (nonatomic, strong) NSString *imageName;

/** 图片名称 */
@property (nonatomic, strong) NSString *imageChineseName;

/** 英文名称 */
@property (nonatomic, strong) NSString *en_name;

- (instancetype)initWithImageName:(NSString *)imageName
                  imageChieseName:(NSString *)imageChineseName
                           enName:(NSString *)enName;

+ (instancetype)emoticonWithImageName:(NSString *)imageName
                     imageChineseName:(NSString *)imageChineseName
                               enName:(NSString *)enName;

@end
