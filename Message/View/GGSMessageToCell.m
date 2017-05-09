//
//  GGSMessageToCell.m
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © kActivityHeight16年 zhangmin. All rights reserved.
//

#import "GGSMessageToCell.h"
#import "GGSCoachConnectList.h"
#import "GGSUserInfoManager.h"
#import "UIView+CornorRadious.h"
#import "UIImage+Color.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "GGSDateStringManager.h"
#import <ImageIO/ImageIO.h>

/** 聊天头像的高度 */
static const CGFloat kChatIconHeight = 40.f;

//static const CGFloat kMaxContainerViewWidth = 2kActivityHeight.f;
/** 最大图片宽度 */
static const CGFloat kMaxChatImageViewWidth = 40.f;
/** 最大图片高度 */
static const CGFloat kMaxChatImageViewHeight = 300.f;

static const CGFloat kBaseBottomMargin = 18.f;
/** 指示器高度 */
static const CGFloat kActivityHeight = 20.f;

@interface GGSMessageToCell ()
// 头像按钮
@property (nonatomic, strong) UIButton *userIconButton;
// 头像
//@property (nonatomic, strong) UIImageView *userIconToImageView;
// 背景图
@property (nonatomic, strong) UIImageView *backImageView;
// 消息显示内容
@property (nonatomic, strong) UILabel *messageLabel;
// 转圈提示
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 包含图
@property (nonatomic, strong) UIView *containerView;
// 创建时间button
@property (nonatomic, strong) UIButton *createTimeButton;
// 创建时间的背景图片
@property (nonatomic, strong) UIImageView *createTimeImageView;
// 创建时间
@property (nonatomic, strong) UILabel *createTimeLabel;

@property (nonatomic, strong) UIView *timeContentView;

@property (nonatomic, strong) UIImageView *messageImageView;

@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation GGSMessageToCell

- (void)setConnectList:(GGSCoachConnectList *)connectList {
    _connectList = connectList;
    // 设置聊天时间
    [self setupChatTimeWithConnectList:_connectList];
    // 设置聊天头像
    [self setupMessageChatIconWithConnectList:_connectList];
    
    if (_connectList.connectMessageType == GGSConnectMessageTypeGifImage) {

        if (connectList.messageType == GGSMessageTypeSendToOthers) {
            self.activityView.sd_resetLayout
            .rightSpaceToView(self.containerView, 10)
            .centerYEqualToView(self.backImageView)
            .widthIs(kActivityHeight)
            .heightIs(kActivityHeight);
        } else {
            self.activityView.sd_resetLayout
            .leftSpaceToView(self.containerView, 10)
            .centerYEqualToView(self.backImageView)
            .widthIs(kActivityHeight)
            .heightIs(kActivityHeight);
        }
        
        _messageLabel.text = @"";
        // cell 复用时 清除只有文字的情况下设置的container 宽度自适应
        [self.containerView clearAutoWidthSettings];
        self.messageImageView.hidden = NO;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:_connectList.gifImageName ofType:@".gif"];
        // 获取gif数据
        CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], NULL);
        // 获取gif文件个数
        size_t count = CGImageSourceGetCount(source);
        // gif 播放完整一次所需事件
        CGFloat allTime = 0;
        // 获取git 所有图片的数组
        NSMutableArray *allImagesArray = [NSMutableArray array];
        // 遍历GIF 图片
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageItem = CGImageSourceCreateImageAtIndex(source, i, NULL);
            UIImage *needImage = [UIImage imageWithCGImage:imageItem];
            [allImagesArray addObject:needImage];
            
            // 获取图片信息
            NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            
            // 统计动画所需事件
            NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)(kCGImagePropertyGIFDictionary)];
            CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
            allTime += time;
        }
        
        if (allImagesArray.count) {
            
            UIImage *showImage = allImagesArray[0];
            self.messageImageView.image = showImage;
            
            CGFloat defaultRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
            
            CGFloat widthHeightRatio = 0;
            CGFloat currentImageW = showImage.size.width;
            CGFloat currentimageH = showImage.size.height;
            
            if (currentImageW > kMaxChatImageViewWidth || currentImageW > kMaxChatImageViewHeight) {
                widthHeightRatio = currentImageW / currentimageH;
                
                if (widthHeightRatio > defaultRatio) {
                    currentImageW = kMaxChatImageViewWidth;
                    currentimageH = currentImageW * (showImage.size.height / showImage.size.width);
                } else {
                    currentimageH = kMaxChatImageViewHeight;
                    currentImageW = currentimageH * widthHeightRatio;
                }
            }
            if (currentImageW < kChatIconHeight) {
                currentimageH = (currentimageH / currentImageW) * kChatIconHeight;
                currentImageW = kChatIconHeight;
            }
            if (currentimageH < kChatIconHeight) {
                currentImageW = (currentImageW / currentimageH) * kChatIconHeight;
                currentimageH = kChatIconHeight;
            }
            
            
            
            self.messageImageView.size_sd = CGSizeMake(currentImageW, currentimageH);
            _containerView.sd_layout.widthIs(currentImageW).heightIs(currentimageH);
            
            [_containerView setupAutoHeightWithBottomView:_messageImageView bottomMargin:kBaseBottomMargin];
            
            //            self.containerView.layer.mask = self.maskImageView.layer;
            __weak typeof(self) weakSelf = self;
            [_backImageView setDidFinishAutoLayoutBlock:^(CGRect rect) {
                //                weakSelf.maskImageView.size_sd = CGSizeMake(currentImageW, currentimageH);
                weakSelf.backImageView.image = [UIImage new];
            }];
            
//            self.containerView.backgroundColor = [UIColor redColor];
//            self.messageImageView.backgroundColor = [UIColor yellowColor];
            _messageImageView.animationImages = allImagesArray;
            _messageImageView.animationDuration = allTime;
            [_messageImageView startAnimating];
        } else {
            self.messageImageView.size_sd = CGSizeMake(kChatIconHeight, kChatIconHeight);
            _containerView.sd_layout.widthIs(kChatIconHeight).heightIs(kChatIconHeight);
            
            [_containerView setupAutoHeightWithBottomView:_messageImageView bottomMargin:kBaseBottomMargin];
            
            self.containerView.layer.mask = self.maskImageView.layer;
            __weak typeof(self) weakSelf = self;
            [_messageImageView setDidFinishAutoLayoutBlock:^(CGRect rect) {
                weakSelf.backImageView.image = [UIImage new];
            }];
        }
    } else {
        
        if (connectList.messageType == GGSMessageTypeSendToOthers) {
            self.activityView.sd_resetLayout
            .rightSpaceToView(self.containerView, 10)
            .centerYEqualToView(self.messageLabel)
            .widthIs(kActivityHeight)
            .heightIs(kActivityHeight);
        } else {
            self.activityView.sd_resetLayout
            .leftSpaceToView(self.containerView, 10)
            .centerYEqualToView(self.messageLabel)
            .widthIs(kActivityHeight)
            .heightIs(kActivityHeight);
        }
        
        [_containerView.layer.mask removeFromSuperlayer];
        
        self.messageImageView.hidden = YES;
        
        _backImageView.didFinishAutoLayoutBlock = nil;
        
        _messageLabel.sd_resetLayout
        .topSpaceToView(self.containerView, 10)
        .leftSpaceToView(self.containerView, 15)
        .autoHeightRatio(0);
        // 配置显示字符
        self.messageLabel.attributedText = _connectList.showArtString;
        
        _messageLabel.isAttributedContent = YES;
        // 设置label横向自适应
        [_messageLabel setSingleLineAutoResizeWithMaxWidth:(SCREEN_WIDTH - 170)];
        // container 宽度自适应
        [_containerView setupAutoWidthWithRightView:_messageLabel rightMargin:15];
        // 设置container 高度自适应
        [_containerView setupAutoHeightWithBottomView:_messageLabel bottomMargin:kBaseBottomMargin];
    }
//    _messageLabel.backgroundColor = [UIColor redColor];
}

/** 设置聊天时间 */
- (void)setupChatTimeWithConnectList:(GGSCoachConnectList *)connectList {
    if (connectList.isShowMessageSendTime) {
        _createTimeLabel.text = connectList.showTime;
        
        _timeContentView.sd_resetLayout.topSpaceToView(self.contentView, 3)
        .centerXEqualToView(self.contentView);
        
        _createTimeLabel.sd_resetLayout
        .topSpaceToView(_timeContentView, 2)
        .leftSpaceToView(_timeContentView, 2)
        .autoHeightRatio(0);
        
        // 设置当行文本宽度适应
        [_createTimeLabel setSingleLineAutoResizeWithMaxWidth:160];
        
        [_timeContentView setupAutoWidthWithRightView:_createTimeLabel rightMargin:2];
        [_timeContentView setupAutoHeightWithBottomView:_createTimeLabel bottomMargin:2];
        
    } else {
        _createTimeLabel.text = [NSString stringWithFormat:@"不显示时间 -- %@", [GGSDateStringManager showStringWithSecond:connectList.created_at]];
        _createTimeLabel.text = @"";
        
        
        _timeContentView.sd_resetLayout.topSpaceToView(self.contentView, 0)
        .centerXEqualToView(self.contentView);
        
        _createTimeLabel.sd_resetLayout
        .topSpaceToView(_timeContentView, 0)
        .leftSpaceToView(_timeContentView, 0)
        .autoHeightRatio(0);
        
        // 设置当行文本宽度适应
        [_createTimeLabel setSingleLineAutoResizeWithMaxWidth:160];
        
        [_timeContentView setupAutoWidthWithRightView:_createTimeLabel rightMargin:0];
        [_timeContentView setupAutoHeightWithBottomView:_createTimeLabel bottomMargin:0];
    }
}

/** 设置聊天头像 */
- (void)setupMessageChatIconWithConnectList:(GGSCoachConnectList *)connectList {
    // 设置头像
    [_userIconButton sd_setBackgroundImageWithURL:kBaseImageURL(_connectList.userProfilePic) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ggs_chat_defaulticon"]];
    [_userIconButton sd_setBackgroundImageWithURL:kBaseImageURL(_connectList.userProfilePic) forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"ggs_chat_defaulticon"]];
    [_userIconButton sd_setBackgroundImageWithURL:kBaseImageURL(_connectList.userProfilePic) forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"ggs_chat_defaulticon"]];
    
    if (connectList.messageType == GGSMessageTypeSendToOthers) {
        // 用户头像
        self.userIconButton.sd_resetLayout
        .topSpaceToView(self.timeContentView, 3)
        .rightSpaceToView(self.contentView, 10)
        .widthIs(kChatIconHeight)
        .heightIs(kChatIconHeight);
        
        self.containerView.sd_resetLayout.topEqualToView(self.userIconButton)
        .rightSpaceToView(self.userIconButton, 10);
        
        UIImage *image = [UIImage imageNamed:@"ggs_sendertext"];
        int height = image.size.height * 0.5;
        int width = image.size.width * 0.5;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height - 1, width - 1) resizingMode:UIImageResizingModeStretch];
        self.backImageView.image = image;
        
        //        self.activityView.sd_resetLayout
        //        .rightSpaceToView(self.containerView, 10)
        //        .centerYEqualToView(self.containerView)
        //        .widthIs(kActivityHeight)
        //        .heightIs(kActivityHeight);
        
    } else {
        // 用户头像
        self.userIconButton.sd_resetLayout
        .topSpaceToView(self.timeContentView, 3)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(kChatIconHeight)
        .heightIs(kChatIconHeight);
        
        self.containerView.sd_resetLayout.topEqualToView(self.userIconButton)
        .leftSpaceToView(self.userIconButton, 10);
        
        UIImage *image = [UIImage imageNamed:@"ggs_receivertext"];
        int height = image.size.height * 0.5;
        int width = image.size.width * 0.5;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height - 1, width - 1) resizingMode:UIImageResizingModeStretch];
        self.backImageView.image = image;
        
        //        self.activityView.sd_resetLayout
        //        .leftSpaceToView(self.containerView, 10)
        //        .centerYEqualToView(self.containerView)
        //        .widthIs(kActivityHeight)
        //        .heightIs(kActivityHeight);
    }
    
    self.maskImageView.image = self.backImageView.image;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GGSMessageToCell";
    GGSMessageToCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GGSMessageToCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setupCellContentSubViews {
    // 发送信息头像
    [self.contentView addSubview:self.userIconButton];
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.messageLabel];
    [self.containerView addSubview:self.messageImageView];
    self.maskImageView = [UIImageView new];
    
    
    [self.containerView insertSubview:self.backImageView atIndex:0];
    
    [self.contentView addSubview:self.timeContentView];
    [self.timeContentView addSubview:self.createTimeLabel];
    [self.timeContentView insertSubview:self.createTimeImageView atIndex:0];
    [self.contentView addSubview:self.activityView];
    
    // containerView 自适应高度
    [self setupAutoHeightWithBottomView:self.containerView bottomMargin:0];
    self.backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.createTimeImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.activityView.hidden = YES;
}

//#pragma mark - PrivateMethod
//- (NSMutableAttributedString *)p_attributeString:(NSString *)string {
//    // 判断为空的情况
//    if ([NSString isBlankString:string]) {
//        return [NSMutableAttributedString new];
//    }
//    
//    NSMutableAttributedString *artString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSMutableDictionary *parmater = [NSMutableDictionary dictionary];
//    // 行间距
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:2.5f];
//    parmater[NSParagraphStyleAttributeName] = paragraphStyle1;
//    // 字间距
//    parmater[NSKernAttributeName] = @(1.0f);
//    [artString setAttributes:parmater range:NSMakeRange(0, [string length])];
//    
//    return artString;
//}

#pragma mark - ActionEvent
- (void)buttonClicked {
    if (self.IconBlock) {
        self.IconBlock(_connectList.user_id);
    }
}

#pragma mark - 开启转圈动画
- (void)startAnimation {
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

#pragma mark - 关闭转圈动画
- (void)endAnimation {
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
}

#pragma mark - Getter
- (UIButton *)userIconButton {
    if (_userIconButton == nil) {
        _userIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userIconButton setBackgroundImage:[UIImage imageNamed:@"ggs_chat_defaulticon"] forState:UIControlStateNormal];
        [_userIconButton setBackgroundImage:[UIImage imageNamed:@"ggs_chat_defaulticon"] forState:UIControlStateSelected];
        _userIconButton.highlighted = NO;
        [_userIconButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userIconButton;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [UILabel zm_labelWithTitle:@""
                                              font:16 bakcgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _messageLabel;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    }
    return _activityView;
}

- (UIButton *)createTimeButton {
    if (_createTimeButton == nil) {
        _createTimeButton = [UIButton zm_buttonWithTitle:@""
                                                    font:11
                                         bakcgroundColor:kWHITE_COLOR
                                                   image:@""];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kActivityHeight, kActivityHeight)];
        
        UIImage *image = [view ygd_drawRectWithRoundedCornerRadius:2.f
                                                       borderWidth:0
                                                   backgroundColor:[UIColor colorWithWhite:0.793 alpha:1.000]
                                                       borderColor:kBACKGROUND_COLOR];
        
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
        
        [_createTimeButton setBackgroundImage:image forState:UIControlStateNormal];
        [_createTimeButton setBackgroundImage:image forState:UIControlStateSelected];
        
    }
    return _createTimeButton;
}

- (UILabel *)createTimeLabel {
    if (_createTimeLabel == nil) {
        _createTimeLabel = [UILabel zm_labelWithFont:12
                                       textAlignment:NSTextAlignmentCenter
                                           textColor:kWHITE_COLOR];
        _createTimeLabel.backgroundColor = [UIColor colorWithWhite:0.793 alpha:1.000];
        
    }
    return _createTimeLabel;
}

- (UIImageView *)createTimeImageView {
    if (_createTimeImageView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kActivityHeight, kActivityHeight)];
        UIImage *image = [view ygd_drawRectWithRoundedCornerRadius:2.f
                                                       borderWidth:0
                                                   backgroundColor:[UIColor colorWithWhite:0.793 alpha:1.000]
                                                       borderColor:kBACKGROUND_COLOR];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
        _createTimeImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _createTimeImageView;
}

- (UIView *)timeContentView {
    if (_timeContentView == nil) {
        _timeContentView = [[UIView alloc] init];
        _timeContentView.backgroundColor = kBACKGROUND_COLOR;
    }
    return _timeContentView;
}

- (UIImageView *)messageImageView {
    if (_messageImageView == nil) {
        _messageImageView = [[UIImageView alloc] init];
        _messageImageView.contentMode = UIViewContentModeCenter;
    }
    return _messageImageView;
}

- (UIImageView *)maskImageView {
    if (_maskImageView == nil) {
        _maskImageView = [[UIImageView alloc] init];
    }
    return _maskImageView;
}

@end

//- (void)p_playGifImageWithConnectInfo:(GGSCoachConnectList *)connectList {
//    NSString *name = [connectList.body stringByReplacingOccurrencesOfString:@".gif" withString:@""];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@".gif"];
//    // 获取gif数据
//    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], NULL);
//    // 获取gif文件个数
//    size_t count = CGImageSourceGetCount(source);
//    // gif 播放完整一次所需事件
//    CGFloat allTime = 0;
//    // 获取git 所有图片的数组
//    NSMutableArray *allImagesArray = [NSMutableArray array];
//    // 遍历GIF 图片
//    for (size_t i = 0; i < count; i++) {
//        CGImageRef imageItem = CGImageSourceCreateImageAtIndex(source, i, NULL);
//        UIImage *needImage = [UIImage imageWithCGImage:imageItem];
//        [allImagesArray addObject:needImage];
//
//        // 获取图片信息
//        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
//
//        // 统计动画所需事件
//        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)(kCGImagePropertyGIFDictionary)];
//        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
//        allTime += time;
//    }
//
//    _messageImageView.animationImages = allImagesArray;
//    _messageImageView.animationDuration = allTime;
//    [_messageImageView startAnimating];
//}


//    if (connectList.messageType == GGSMessageTypeSendToOthers) {
//        // 用户头像
//        self.userIconButton.sd_resetLayout
//        .topSpaceToView(self.timeContentView, 3)
//        .rightSpaceToView(self.contentView, 10)
//        .widthIs(40)
//        .heightIs(40);
//
//        self.containerView.sd_resetLayout.topEqualToView(self.userIconButton)
//        .rightSpaceToView(self.userIconButton, 10);
//
//        UIImage *image = [UIImage imageNamed:@"ggs_sendertext"];
//        int height = image.size.height * 0.5;
//        int width = image.size.width * 0.5;
//        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height - 1, width - 1) resizingMode:UIImageResizingModeStretch];
//        self.backImageView.image = image;
//
//        self.activityView.sd_resetLayout
//        .rightSpaceToView(self.containerView, 10)
//        .centerYEqualToView(self.containerView)
//        .widthIs(kActivityHeight)
//        .heightIs(kActivityHeight);
//
//    } else {
//        // 用户头像
//        self.userIconButton.sd_resetLayout
//        .topSpaceToView(self.timeContentView, 3)
//        .leftSpaceToView(self.contentView, 10)
//        .widthIs(40)
//        .heightIs(40);
//
//        self.containerView.sd_resetLayout.topEqualToView(self.userIconButton)
//        .leftSpaceToView(self.userIconButton, 10);
//
//        UIImage *image = [UIImage imageNamed:@"ggs_receivertext"];
//        int height = image.size.height * 0.5;
//        int width = image.size.width * 0.5;
//        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height - 1, width - 1) resizingMode:UIImageResizingModeStretch];
//        self.backImageView.image = image;
//
//        self.activityView.sd_resetLayout
//        .leftSpaceToView(self.containerView, 10)
//        .centerYEqualToView(self.containerView)
//        .widthIs(kActivityHeight)
//        .heightIs(kActivityHeight);
//    }

