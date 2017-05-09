//
//  GGSThreadSubItem.h
//  GGSPlantform
//
//  Created by min zhang on 16/9/12.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGSThreadSubItem : NSObject
/**
 *  创建日期
 */
@property (nonatomic, strong) NSString *created_at;
/**
 *  更新日期
 */
@property (nonatomic, strong) NSString *deleted_at;
/**
 *  id
 */
@property (nonatomic, assign) NSInteger id;
/**
 *  显示数据类型
 */
@property (nonatomic, strong) NSString *subject;
/**
 *  更新日期
 */
@property (nonatomic, strong) NSString *updated_at;

@end
