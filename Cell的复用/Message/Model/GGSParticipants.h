//
//  GGSParticipants.h
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGSParticipants : NSObject

@property (nonatomic, assign) long long id;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *phone_number;

@property (nonatomic, assign) long long user_id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *real_name;

@property (nonatomic, strong) NSString *qq_number;

@property (nonatomic, assign) long long review_count;

@property (nonatomic, assign) id signature;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSString *team;

@property (nonatomic, strong) NSString *profile_pic;

@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) NSString *national_id;

@property (nonatomic, assign) long long fee;

@property (nonatomic, assign) NSInteger currency_id;

@property (nonatomic, assign) long long last_available;

@property (nonatomic, assign) NSInteger approved;

@property (nonatomic, assign) NSInteger is_professional;

@property (nonatomic, assign) NSInteger game_id;

@property (nonatomic, assign) NSInteger is_contract;

@end
