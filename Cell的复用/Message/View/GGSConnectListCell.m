
//
//  GGSConnectListCell.m
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSConnectListCell.h"
#import "GGSUserThread.h"
#import "GGSParticipants.h"
#import "UIView+CornorRadious.h"
#import "UIImage+Color.h"
#import "GGSGGSLastMessage.h"
#import <SDWebImage/SDImageCache.h>
#import "GGSUserInfoManager.h"

#import "UIView+CornorRadious.h"
#import "GGSDateStringManager.h"

@interface GGSConnectListCell ()
// 头像Button
@property (nonatomic, strong) UIButton *userIconButton;

// 头像
@property (nonatomic, strong) UIImageView *userIconImageView;
// 姓名
@property (nonatomic, strong) UILabel *userNameLabel;
// 日期
@property (nonatomic, strong) UILabel *createDateLabel;
// 最新一条聊天信息
@property (nonatomic, strong) UILabel *lastMessageLabel;
// 未读信息条数
@property (nonatomic, strong) UIButton *unReadCounButton;

@property (nonatomic, assign) NSInteger unReadCount;
// 官方客服
@property (nonatomic, strong) UILabel *servierLabel;

@end

@implementation GGSConnectListCell
- (void)setUserConnectInfo:(GGSUserThread *)userConnectInfo {
    _userConnectInfo = userConnectInfo;
    // 处理群聊图片
    [self p_handelUserShowImageWithThreadInfo:_userConnectInfo];
    // 处理显示的时间 最后一条消息显示的时间
    _createDateLabel.text = _userConnectInfo.lastMessageShowTime;
    // 处理未读纤细
    [self p_handelUnReadMessageCount];
    // 设置用户名
    [self p_showChatUserName];
    
    // 客服显示数据
    if (userConnectInfo.is_support) {
        _servierLabel.hidden = NO;
    } else {
        _servierLabel.hidden = YES;
    }
    
    // 最后一条消息显示的内容
    if ([_userConnectInfo.last_message.type isEqualToString:@"booking_preference"]) {
        _lastMessageLabel.text = @"";
    } else {
        if (_userConnectInfo.messageType == GGSConnectMessageTypeGifImage) {
            _lastMessageLabel.text = @"[动画表情]";
        } else {
            _lastMessageLabel.text = _userConnectInfo.last_message.body;
        }
    }
}

#pragma mark - PrivateMethod
- (void)p_handelUserShowImageWithThreadInfo:(GGSUserThread *)threadInfo {
    NSArray *array = _userConnectInfo.participants;
    if (array.count >= 2) {
        // 显示的名称
//        _userNameLabel.text = _userConnectInfo.chatUserName;
        
        if (array.count > 2) {
            NSMutableArray *arrayImage = [NSMutableArray array];
            
            [_userConnectInfo.participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[UIImageView new] sd_setImageWithURL:kBaseImageURL(obj.profile_pic) placeholderImage:[UIImage new] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    // 绘制图片
                    UIImage *needImage = [self p_drawImage:image inSize:CGSizeMake(45/3.0, 45/3.0) index:idx
                                          ];
                    [arrayImage addObject:needImage];
                    
                    if (arrayImage.count == (_userConnectInfo.participants.count)) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            UIImage *backImage = [UIImage zm_imageWithRadius:0
                                                               bordWidth:0
                                                                    size:CGSizeMake(55, 55)
                                                               bordColor:[UIColor clearColor]
                                                               backColor:[UIColor clearColor]];
                            UIImage *groupImage = [self p_groupImageWithBackImage:backImage needImageArray:arrayImage];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _userIconImageView.image = groupImage;
                                // 清除缓存
                                NSString *imageKey = [NSString stringWithFormat:@"%@", kBaseImageURL(obj.profile_pic)];
                                if ([NSString isBlankString:imageKey] == NO) {
                                    [[SDImageCache sharedImageCache] removeImageForKey:imageKey];
                                }
                            });
                        });
                    }
                }];
            }];
        } else {
            // 图片
            __weak typeof(self) weakSelf = self;
            [_userIconImageView sd_setImageWithURL:kBaseImageURL(_userConnectInfo.chatPic) placeholderImage:[UIImage imageNamed:@"ggs_chat_defaulticon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error == nil) {
//                    __block UIImage *newImage = image;
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        newImage = [newImage zm_addCornorWithRadius:3.f size:CGSizeMake(55, 55)];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.userIconImageView.image = image;
                        });
//                    NSString *imageKey = [NSString stringWithFormat:@"%@", kBaseImageURL(weakSelf.userConnectInfo.chatPic)];
//                    if (image && [NSString isBlankString:imageKey] == NO) {
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
//                    }
                }
            }];
        }
    }
}

/** 设置用户名 */
- (void)p_showChatUserName {
    NSArray *array = _userConnectInfo.participants;
    if (array.count >= 2) {
        // 显示的名称
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_userConnectInfo.chatUserName attributes:@{NSForegroundColorAttributeName : kMAINTITLE_COLOR, NSFontAttributeName : [UIFont systemFontOfSize:17]}];
        _userNameLabel.attributedText = string;
    } else {
        _userNameLabel.text = @"神秘用户";
    }
}

// 设置显示的未读信息数
- (void)p_handelUnReadMessageCount {
    // 未读消息数
    NSInteger unReadCount = _userConnectInfo.unread_message_count;
    if (unReadCount == 0) {
        _unReadCounButton.hidden = YES;
        [_unReadCounButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0));
        }];
    } else {
        _unReadCounButton.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"%ld", unReadCount];
        CGSize size = [NSString zm_titleSize:title font:[UIFont systemFontOfSize:12]];
        
        CGFloat needWidth = 0;
        if (size.width + 12 < 20) {
            needWidth = 20;
        } else {
            needWidth = size.width + 12;
        }
        [_unReadCounButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(needWidth));
        }];
        
        UIImage *newImage =  [_unReadCounButton.currentBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        [_unReadCounButton setBackgroundImage:newImage forState:UIControlStateNormal];
    }
    NSString *count = @"";
    if (unReadCount > 99) {
        count = @"99+";
    } else {
        count = [NSString stringWithFormat:@"%ld", unReadCount];
    }
    
    [_unReadCounButton setTitle:count forState:UIControlStateNormal];
    [_unReadCounButton setTitle:count forState:UIControlStateSelected];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GGSConnectListCell";
    GGSConnectListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSConnectListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews {
    [self.contentView addSubview:self.userIconButton];
    // 头像
    [self.contentView addSubview:self.userIconImageView];
    // 姓名
    [self.contentView addSubview:self.userNameLabel];
    // 最后一条信息
    [self.contentView addSubview:self.lastMessageLabel];
    // 创建日期
    [self.contentView addSubview:self.createDateLabel];
    // 未读信息条数
    [self.contentView addSubview:self.unReadCounButton];
    // 官方客服
    [self.contentView addSubview:self.servierLabel];
    
    __weak typeof(self) weakSelf = self;
    [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.mas_top).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.mas_top).offset(0);
        make.left.equalTo(weakSelf.userIconImageView.mas_right).offset(10);
        make.right.equalTo(weakSelf.createDateLabel.mas_left).offset(-10);
    }];
    [self.unReadCounButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_userIconImageView.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    [self.lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userIconImageView.mas_right).offset(10);
        make.bottom.equalTo(_userIconImageView.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.unReadCounButton.mas_left).offset(-10);
        make.height.lessThanOrEqualTo(@30);
    }];
    [self.servierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userIconImageView.mas_right).offset(10);
        make.width.equalTo(@45);
        make.centerY.equalTo(_userIconImageView.mas_centerY);
    }];
}

/**
 *  创建新的群聊背景图
 *
 *  @param backImage  背景图
 *  @param imageArray 图片数组
 *
 *  @return 背景图片
 */
- (UIImage *)p_groupImageWithBackImage:(UIImage *)backImage
                        needImageArray:(NSArray<UIImage *> *)imageArray {
    CGSize size = backImage.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [backImage drawAtPoint:CGPointMake(0, 0)];
    [backImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGFloat betweenWidth = 2;
    for (int i = 0; i < imageArray.count; i++) {
        NSInteger wDirect = i % 3; // 横向
        NSInteger hDirect = i / 3; // 纵向
        
        UIImage *image = imageArray[i];
        // 获取长宽
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        
        CGFloat wPoint = (betweenWidth + width) * wDirect + betweenWidth + 1;
        CGFloat hPoint = (betweenWidth + height) * hDirect + betweenWidth + 1;

//        if (wDirect == 0) {
//            wPoint = wPoint + 1;
//        }
        
//        if (i == 0) {
//            [image drawAtPoint:CGPointMake(3, 2)];
//            [image drawInRect:CGRectMake(3, 2, width, height)];
//        } else {

            [image drawAtPoint:CGPointMake(wPoint, hPoint)];
            [image drawInRect:CGRectMake(wPoint, hPoint, width, height)];
//        [image drawAsPatternInRect:CGRectMake(wPoint, hPoint, width, height)];
//        }

    }
    
    UIImage *needImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return needImage;
}


// 获取到新的图片 重置图片大小
- (UIImage *)p_drawImage:(UIImage *)image inSize:(CGSize)size index:(NSInteger)index {
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    if (index == 0) {
      [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    } else {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//// 绘制有圆角的图片
//- (UIImage *)p_imageWithRadius:(CGFloat)radius
//                     bordWidth:(CGFloat)bordWidth
//                          size:(CGSize)size
//                     bordColor:(UIColor *)bordColor
//                     backColor:(UIColor *)backColor {
//
//    CGFloat halfBorderWidth = bordWidth / 2.0;
//    //
//    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 划线
//    CGContextSetLineWidth(context, bordWidth);
//    // 设置边框颜色
//    CGContextSetStrokeColorWithColor(context, bordColor.CGColor);
//    // 设置填充色
//    CGContextSetFillColorWithColor(context, backColor.CGColor);
//    
//    CGFloat width = size.width;
//    CGFloat height = size.height;
//    // 画边框
//    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth);
//    // 开始坐标右边开始
//    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);
//    // 右下角角度
//    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius);
//    // 左下角角度
//    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius);
//    // 左上角
//    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius);
//    // 右上角
//    // 填充context
//    CGContextDrawPath(context, kCGPathFillStroke);
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

#pragma mark - Getter
- (UIImageView *)userIconImageView {
    if (_userIconImageView == nil) {
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.backgroundColor = kBACKGROUND_COLOR;
        _userIconImageView.layer.cornerRadius = 4.5f;
        _userIconImageView.layer.masksToBounds = YES;
        _userIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _userIconImageView;
}

- (UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        _userNameLabel = [UILabel zm_labelWithFont:17 textAlignment:NSTextAlignmentLeft textColor:kMAINTITLE_COLOR];
    }
    return _userNameLabel;
}

- (UILabel *)lastMessageLabel {
    if (_lastMessageLabel == nil) {
        _lastMessageLabel = [UILabel zm_labelWithFont:14
                                        textAlignment:NSTextAlignmentLeft textColor:kSECTITLE_COLOR];
    }
    return _lastMessageLabel;
}

- (UILabel *)createDateLabel {
    if (_createDateLabel == nil) {
        _createDateLabel = [UILabel zm_labelWithFont:13
                                       textAlignment:NSTextAlignmentRight textColor:kSECTITLE_COLOR];
    }
    return _createDateLabel;
}

- (UIButton *)unReadCounButton {
    if (_unReadCounButton == nil) {
        _unReadCounButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unReadCounButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _unReadCounButton.userInteractionEnabled = NO;
        UIImage *backImage = [UIImage zm_createImageWithColor:[UIColor colorWithRed:0.9887 green:0.3781 blue:0.2629 alpha:1.0] size:CGSizeMake(20, 20)];
        backImage = [backImage zm_addCornorWithRadius:12 size:CGSizeMake(20, 20)];
        [_unReadCounButton setBackgroundImage:backImage forState:UIControlStateNormal];
    }
    return _unReadCounButton;
}

- (UILabel *)servierLabel {
    if (_servierLabel == nil) {
        _servierLabel = [UILabel zm_labelWithFont:9
                                  bakcgroundColor:kSECBUTTON_COLOR
                                    textAlignment:NSTextAlignmentCenter
                                        textColor:[UIColor whiteColor]];
        _servierLabel.text = @"官方客服";
        _servierLabel.layer.cornerRadius = 2.f;
        _servierLabel.layer.masksToBounds = YES;
    }
    return _servierLabel;
}

@end
