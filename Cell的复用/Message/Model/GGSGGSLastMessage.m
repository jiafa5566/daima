//
//  GGSGGSLastMessage.m
//  GGSPlantform
//
//  Created by zhangmin on 2016/6/23.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSGGSLastMessage.h"
#import "GGSJMessageContent.h"

@implementation GGSGGSLastMessage

- (instancetype)initWithIdTag:(NSInteger)idTag
                    createdAt:(long long)createAt
                     threadId:(NSInteger)threadId
                       userId:(NSInteger)userId
                         body:(NSString *)body {
                             self = [super init];
                             if (self) {
                                 _id = idTag;
                                 _created_at = [NSString stringWithFormat:@"%lld", createAt];
                                 _thread_id = threadId;
                                 _user_id = userId;
                                 _body = body;
                             }
                             return self;
}

- (instancetype)initWithMessageContent:(GGSJMessageContent *)messageConent {
    return [self initWithIdTag:messageConent.id
                     createdAt:messageConent.created_at
                      threadId:messageConent.thread_id
                        userId:messageConent.user_id
                          body:messageConent.body];
}

@end
