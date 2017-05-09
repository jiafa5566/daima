//
//  GGSShowMessageAdapter.h
//  GGSPlantform
//
//  Created by min zhang on 2017/3/8.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGSCoachConnectList.h"

@interface GGSShowMessageAdapter : NSObject

+ (instancetype)shareAdapter;


/**
 通过当前的消息配置显示的艺术字

 @param body 当前消息
 @return 返回的艺术字
 */
- (NSMutableAttributedString *)showArtMessageWithMeesageBody:(NSString *)body;


/**
 通过当前消息的内容配置显示的消息

 @param body 纤细内容
 @param staticImageArray 静态图片数组
 @return item
 */
- (NSMutableAttributedString *)staticImageArtStringWithMessageBody:(NSString *)body staticImageArray:(NSMutableArray *)staticImageArray;


/**
 通过本地发送消息的内容配置发送的消息

 @param body 发送消息的内容
 @param staticImageArray 静态图片数组
 @return 需要发送到服务器的消息
 */
- (NSString *)sendToServerStringWithMessageBody:(NSString *)body staticImageArray:(NSMutableArray *)staticImageArray;



/**
 <#Description#>

 @param body <#body description#>
 @param connectType <#connectType description#>
 @param staticImageArray <#staticImageArray description#>
 @param threadId <#threadId description#>
 @param isShowLastSendTime <#isShowLastImage description#>
 @return <#return value description#>
 */
- (GGSCoachConnectList *)preSendConnectInfoWithMessageBody:(NSString *)body
                                               connectType:(GGSConnectMessageType)connectType
                                          staticImageArray:(NSMutableArray *)staticImageArray
                                                  threadId:(NSInteger)threadId
                                        isShowLastSendTime:(BOOL)isShowLastSendTime
                                                  chatIcon:(NSString *)chatIcon;

//- (GGSCoachConnectList *)receiveConnectInfoWith;

/** 根据消息内容设置消息的样式 */
- (GGSConnectMessageType)connectMeesageTypeWithMessageBody:(NSString *)body;

/**
 通过当前的图片名称 和 消息的样式处理显示的gif图片

 @param imageName 图片名称
 @param connectType 链接的样式
 @return gif图片
 */
- (NSString *)gifImageNameWithImageName:(NSString *)imageName
                            connectType:(GGSConnectMessageType)connectType;


/**
 最后一条消息显示的内容

 @param string 需要配置的消息
 @param staticImageArray 静态表情
 @return item
 */
- (NSString *)connectListShowLastMessageStringWithString:(NSString *)string
                                        staticImageArray:(NSMutableArray *)staticImageArray;



//{
//    if ([body hasPrefix:@"[gif:"] && [body hasSuffix:@":]"]) {
//        return GGSConnectMessageTypeGifImage;
//    } else if ([body containsString:@"[gif:"] && [body containsString:@":]"]) {
//        return GGSConnectMessageTypeStaticImage;
//    }
//    return GGSConnectMessageTypeStaticImage;
//}

@end

#if 0


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 更新未读信息条数
    [self p_updateUnReadMessageCount];
    
    // 获取Thread 详情
    __weak typeof(self) weakSelf = self;
    if (_userThread == nil) {
        [SVProgressHUD show];
        [self p_requestThreadDetailWithThreadId:_threadId completeBlock:^(GGSUserThread *userThread) {
            weakSelf.userThread = userThread;
            // 设置显示用的title
            weakSelf.navigationItem.title = [weakSelf p_navigationTitleWithUserThread:weakSelf.userThread];
            // 获取聊天详情列表
            [weakSelf p_loadMessageWithCurrentPage:weakSelf.currentPage threadId:weakSelf.threadId userThread:weakSelf.userThread  block:^(NSMutableArray *messageArray) {
                weakSelf.connectListArray = messageArray;
                [weakSelf.tableView reloadData];
                // 滑动到底部
                [weakSelf p_scrollToBottomWithMessageListArray:weakSelf.connectListArray];
                [SVProgressHUD dismiss];
                // 发送预 发送消息
                [weakSelf textView:weakSelf.inputToolBar.inputTextView sendMessage:weakSelf.presendMessage];
                [SVProgressHUD dismiss];
            }];
        }];
    }
    // 添加代理
    [JMessage addDelegate:self withConversation:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"[失望][心花怒放][心花怒放][心花怒放][心花怒放][心花怒放][心花怒放]"];
    //    string = [self p_replaceCurrentArtStringWithCompareString:@"[失望]" artString:string];
}

#pragma mark - Private Method
/** 更新未读信息条数 */
- (void)p_updateUnReadMessageCount {
    NSDictionary *paramter = @{@"thread_id" : @(_threadId)};
    [[NetManager shareManger] POST:@"api/v1/thread" parameters:paramter progress:nil success:nil failure:nil];
}

/**
 根据聊天详细获取显示的title
 
 @param userThread 聊天详情
 @return 返回显示用的title
 */
- (NSString *)p_navigationTitleWithUserThread:(GGSUserThread *)userThread {
    if (userThread.participants.count >= 2) {
        // 设置显示的title
        NSString *userName = userThread.chatUserName;
        if ([userThread.chatUserName length] >= 10) {
            userName = [userName substringToIndex:10];
            userName = [NSString stringWithFormat:@"%@...", userName];
        }
        return userName;
    } else {
        return @"";
    }
}

/**
 根据threadId 获取thread 详情
 
 @param threadId 聊天id
 @param completeBlock 完成之后的回调
 */
- (void)p_requestThreadDetailWithThreadId:(NSInteger)threadId completeBlock:(void(^)(GGSUserThread *userThread))completeBlock {
    // 根据threadId 获取聊天详情
    NSString *threadRequest = [NSString stringWithFormat:@"api/v1/thread/%ld", threadId];
    // 根据threaId 获取详情
    [ZMApiManager apiSendGETRequestWithApiString:threadRequest parmater:nil success:^(id responseObject, NSError *error) {
        GGSUserThread *thread = [GGSUserThread mj_objectWithKeyValues:responseObject[@"data"]];
        // 解析子item
        NSMutableArray *array = [NSMutableArray array];
        [thread.participants enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGSParticipants *participants = [GGSParticipants mj_objectWithKeyValues:obj];
            [array addObject:participants];
        }];
        thread.participants = array;
        // 设置数据
        if (completeBlock) {
            completeBlock(thread);
        }
    } fail:^(id responseObject, NSError *error) {
        if (completeBlock) {
            completeBlock(nil);
        }
    }];
}

/** 下拉加载更多 */
- (void)headerLoadMoreMessage {
    self.currentPage++;
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [self p_loadMessageWithCurrentPage:_currentPage threadId:_threadId userThread:_userThread block:^(NSMutableArray *messageArray) {
        // 加载更多数据
        if (messageArray.count == 0) {
            weakSelf.currentPage--;
        } else {
            if (weakSelf.connectListArray.count) {
                // 添加数组最后一个元素
                // 现有数组第一个元素比较时间
                GGSCoachConnectList *connect1 = [messageArray lastObject];
                GGSCoachConnectList *connect2 = [weakSelf.connectListArray firstObject];
                if (connect1.isShowMessageSendTime == YES) {
                    if (connect2.created_at < (connect1.created_at + kMessageBetweenTime)) {
                        connect2.isShowMessageSendTime = NO;
                    }
                }
                NSRange range = NSMakeRange(0, (messageArray.count));
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [weakSelf.connectListArray insertObjects:messageArray atIndexes:indexSet];
            } else {
                weakSelf.connectListArray = messageArray;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        });
        // 滑动到顶部
        if (messageArray.count > 0 && (weakSelf.connectListArray.count - messageArray.count > 1)) {
            NSInteger rowCount = messageArray.count;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount inSection:0];
            // 滑动到顶部 时间处理
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        [SVProgressHUD dismiss];
    }];
}

// 加载最新消息
- (void)footerLoadNewestMessage {
    self.currentPage = 1;
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [self p_loadMessageWithCurrentPage:_currentPage threadId:_threadId userThread:_userThread block:^(NSMutableArray *messageArray) {
        // 刷新数据
        weakSelf.connectListArray = messageArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    }];
}

#pragma mark - Action Event
/** 根据请求的类型获取聊天消息列表信息 刷新的类型： 正常 下拉加载 上拉刷新 */
- (void)p_loadMessageWithCurrentPage:(NSInteger)currentPage
                            threadId:(NSInteger)threadId
                          userThread:(GGSUserThread *)userThread
                               block:(void(^)(NSMutableArray *messageArray))block {
    __weak typeof(self) weakSelf = self;
    // 请求的参数
    NSDictionary *parmater = @{@"page" : @(currentPage),
                               @"thread_id" : @(threadId)};
    [ZMApiManager apiSendGETRequestWithApiString:@"api/v1/message" parmater:parmater success:^(id responseObject, NSError *error) {
        // 处理请求回来的数据
        GGSConnectDetailInfo *connectInfo = [GGSConnectDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
        NSLog(@"开始处理数据");
        NSMutableArray *connectListArray = [NSMutableArray array];
        [connectInfo.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGSCoachConnectList *connectList = [GGSCoachConnectList mj_objectWithKeyValues:obj];
            // 特殊消息手机端不作处理
            if ([connectList.type isEqualToString:@"booking_preference"] == NO && [NSString isBlankString:connectList.body] == NO) {
                [connectList handelShowItems];
                // 判断当前消息的类型
                connectList.connectMessageType = [weakSelf p_connectMeesageTypeWithMessageBody:connectList.body];
                if (connectList.connectMessageType == GGSConnectMessageTypeStaticImage) {
                    // 处理显示的富文本
                    connectList.showArtString = [weakSelf p_artStingWithMessage:connectList.body];
                } else if (connectList.connectMessageType == GGSConnectMessageTypeGifImage) {
                    // 处理Gif
                    connectList.gifImageName = [weakSelf p_gifShowImageNameWithName:connectList.body meesageConnectType:GGSConnectMessageTypeGifImage];
                } else if (connectList.connectMessageType == GGSConnectMessageTypeMessageText) {
                    // 处理纯文本
                    connectList.showArtString = [weakSelf p_ArtStringWithString:connectList.body];
                }
                // 配置用户头像id
                connectList.userProfilePic = [weakSelf p_chatUserIconWithChatMessageType:connectList.messageType userThread:userThread];
                [connectListArray addObject:connectList];
            }
        }];
        // 排序后的数据
        NSMutableArray *dataArray = [weakSelf sortMessageListArray:connectListArray];
        // 消息最后时间显示处理后的数组
        NSMutableArray *listedArray = [weakSelf p_messageShowTimeArrayWithMessageArray:dataArray];
        NSLog(@"处理数据完成");
        // 根据请求的样式 不同处理事件
        if (block) {
            block(listedArray);
        }
    } fail:^(id responseObject, NSError *error) {
        if (block) {
            block([NSMutableArray array]);
        }
    }];
}

/** 根据消息内容设置消息的样式 */
- (GGSConnectMessageType)p_connectMeesageTypeWithMessageBody:(NSString *)body {
    if ([body hasPrefix:@"[gif:"] && [body hasSuffix:@":]"]) {
        return GGSConnectMessageTypeGifImage;
    } else if ([body containsString:@"[gif:"] && [body containsString:@":]"]) {
        return GGSConnectMessageTypeStaticImage;
    }
    return GGSConnectMessageTypeStaticImage;
}

/** 处理GIF 图片显示的名称 */
- (NSString *)p_gifShowImageNameWithName:(NSString *)name meesageConnectType:(GGSConnectMessageType)connectType {
    if (connectType == GGSConnectMessageTypeGifImage) {
        name = [name stringByReplacingOccurrencesOfString:@"[gif:" withString:@""];
        name = [name stringByReplacingOccurrencesOfString:@":]" withString:@""];
        return name;
    }
    return name;
}

/** 更换显示的text */
- (NSMutableAttributedString *)p_replaceCurrentArtStringWithCompareString:(NSString *)compareString artString:(NSMutableAttributedString *)artString imageName:(NSString *)imageName {
    NSRange range = [[artString string] rangeOfString:compareString];
    if (range.location != NSNotFound) {
        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        textAtt.bounds = CGRectMake(0, -4.5, 25, 25);
        textAtt.image = [UIImage imageNamed:imageName];
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:textAtt];
        [artString replaceCharactersInRange:range withAttributedString:string];
        // 递归调用
        [self p_replaceCurrentArtStringWithCompareString:compareString artString:artString imageName:imageName];
    }
    return artString;
}

/** 活动到底部 */
- (void)p_scrollToBottomWithMessageListArray:(NSMutableArray *)messageListArray {
    if (self.tableView.contentSize.height > self.tableView.height) {
        // 滑动到底部
        if (messageListArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(messageListArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

/** 对消息的发送时间进行处理后的消息数组 */
- (NSMutableArray <GGSCoachConnectList *> *)p_messageShowTimeArrayWithMessageArray:(NSArray<GGSCoachConnectList *>*)messageArray {
    NSMutableArray *listedArray = [NSMutableArray array];
    __block long long lastMessageTime = 0;
    [messageArray enumerateObjectsUsingBlock:^(GGSCoachConnectList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            lastMessageTime = obj.created_at;
            obj.isShowMessageSendTime = YES;
        } else {
            if (obj.created_at > (lastMessageTime + kMessageBetweenTime)) {
                obj.isShowMessageSendTime = YES;
                lastMessageTime = obj.created_at;
            } else {
                obj.isShowMessageSendTime = NO;
            }
        }
        [listedArray addObject:obj];
    }];
    return listedArray;
}

- (void)changeInputButtonClicked:(UIButton *)sender {
    sender.selected = YES ^ sender.selected;
    
    if (sender.selected) {
        [_inputToolBar.inputTextView resignFirstResponder];
        __weak typeof(self) weakSelf = self;
        _isEditing = NO;
        [UIImageView animateWithDuration:0.2 animations:^{
            _inputContainerView.sd_layout.bottomSpaceToView(self.view, 250);
            _emoticonView.sd_layout
            .heightIs(250);
            [_emoticonView updateLayout];
        } completion:^(BOOL finished) {
            // 滑动到底部
            [weakSelf p_scrollToBottomWithMessageListArray:_connectListArray];
            _isEditing = YES;
        }];
    } else {
        _isEditing = NO;
        [UIImageView animateWithDuration:0.2 animations:^{
            _emoticonView.sd_layout
            .heightIs(0);
            [_emoticonView updateLayout];
        } completion:^(BOOL finished) {
            _isEditing = YES;
        }];
        [_inputToolBar.inputTextView becomeFirstResponder];
    }
}

#pragma mark - Notification
/** 键盘弹起事件处理 */
- (void)keyBoradWillShow:(NSNotification *)notification {
    
    NSDictionary *dictionary = notification.userInfo;
    CGRect keyBoradRect = [dictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = CGRectGetHeight(keyBoradRect);
    _keyBoardHeight = keyBoardHeight;
    
    // 是否显示占位符
    _inputToolBar.inputTextView.isShowPlaceHolder = NO;
    
    self.tableView.scrollEnabled = NO;
    _isEditing = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.inputContainerView.sd_layout.bottomSpaceToView(self.view, (_keyBoardHeight));
        [self.inputContainerView updateLayout];
        // 滑动到底部
        [self p_scrollToBottomWithMessageListArray:_connectListArray];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.f), dispatch_get_main_queue(), ^{
            self.tableView.scrollEnabled = YES;
            _isEditing = YES;
        });
    }];
    
    _changeInputButton.selected = NO;
}

/** 键盘回收 */
- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (_changeInputButton.selected == NO) {
        if ([NSString isBlankString:_inputToolBar.inputTextView.text]) {
            _inputToolBar.inputTextView.isShowPlaceHolder = YES;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.inputContainerView.sd_layout.bottomSpaceToView(self.view, 0);
            [self.inputContainerView  updateLayout];
        } completion:^(BOOL finished) {
            
        }];
    }
}

/** textView内容改变的通知 */
- (void)textViewDidChangeNotification:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    
    NSString *currentText = textView.text;
    
    __block NSValue *deleteValue = nil;
    [self.addedRangeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
        NSInteger stringLength = range.location + range.length;
        if ([currentText length] < stringLength) {
            deleteValue = obj;
            *stop = YES;
        }
    }];
    if (deleteValue) {
        // 当前显示的字符
        NSRange deleteRange = [deleteValue rangeValue];
        currentText = [currentText substringToIndex:deleteRange.location];
        if ([self.addedRangeArray containsObject:deleteValue]) {
            [self.addedRangeArray removeObject:deleteValue];
        }
        textView.text = currentText;
    }
}


/** 查看新推送的信息和已获得的信息是否重复 */
- (BOOL)p_isPushMessageContent:(GGSJMessageContent *)messageContent
     containInContentListArray:(NSMutableArray <GGSCoachConnectList *> *)contentListArray {
    __block BOOL isContain = NO;
    [contentListArray enumerateObjectsUsingBlock:^(GGSCoachConnectList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id == messageContent.id) {
            isContain = YES;
            *stop = YES;
        }
    }];
    return isContain;
}

/** 控件的自动布局 */
- (void)p_setupSubViewAutoLayout {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputContainerView];
    [self.view insertSubview:self.emoticonView belowSubview:_inputContainerView];
    [_inputContainerView addSubview:self.inputToolBar];
    [_inputContainerView addSubview:self.changeInputButton];
    
    _inputContainerView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .rightEqualToView(self.view)
    .heightIs(45);
    
    _emoticonView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .rightEqualToView(self.view)
    .heightIs(45);
    //
    //    _emoticonView.backgroundColor = [UIColor redColor];
    
    _changeInputButton.sd_layout
    .topEqualToView(_inputContainerView)
    .bottomEqualToView(_inputContainerView)
    .rightEqualToView(_inputContainerView)
    .widthIs(80);
    
    _inputToolBar.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 80));
    
    _tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomSpaceToView(_inputContainerView, 0)
    .rightEqualToView(self.view);
}

//- (void)scrollToBottom {
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_connectListArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//}

#pragma mark - PrivateMethod
// 获取当前输入文本的高度
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

/** 创建显示的艺术字 */
- (NSMutableAttributedString *)p_ArtStringWithString:(NSString *)string {
    // 判断为空的情况
    if ([NSString isBlankString:string]) {
        return [NSMutableAttributedString new];
    }
    
    NSMutableAttributedString *artString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableDictionary *parmater = [NSMutableDictionary dictionary];
    // 行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:1.f];
    paragraphStyle1.minimumLineHeight = 25.f;
    paragraphStyle1.alignment = NSTextAlignmentCenter;
    parmater[NSParagraphStyleAttributeName] = paragraphStyle1;
    // 字间距
    parmater[NSKernAttributeName] = @(0.5f);
    [artString setAttributes:parmater range:NSMakeRange(0, [string length])];
    
    return artString;
}


/**
 处理发送过来的消息数据
 
 @param message 发送的消息
 @return 处理之后的富文本消息
 */
- (NSMutableAttributedString *)p_artStingWithMessage:(NSString *)message {
    // 处理显示的艺术字
    __block NSMutableAttributedString *artString = [self p_ArtStringWithString:message];
    [self.staticEmoticonArray enumerateObjectsUsingBlock:^(GGSEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([message containsString:obj.en_name]) {
            // 显示的艺术字
            artString = [self p_replaceCurrentArtStringWithCompareString:obj.en_name artString:artString imageName:obj.imageName];
            NSLog(@"测试测试 ---- %@", artString);
        }
    }];
    return artString;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 聊天cell
    GGSMessageToCell *cell = [GGSMessageToCell cellWithTableView:tableView indexPath:indexPath];
    // 设置content
    if (indexPath.row < self.connectListArray.count) {
        GGSCoachConnectList *connectList = self.connectListArray[indexPath.row];
        cell.connectList = connectList;
        cell.backgroundColor = kBACKGROUND_COLOR;
        // 点击教练头像处理
        __weak typeof(self) weakSelf = self;
        [cell setIconBlock:^ {
            // 如果id 为 当前用户id 跳转 控制器我的GOGOSU
            if (connectList.messageType == GGSMessageTypeSendToMe) {
                if ([weakSelf.tabBarController isKindOfClass:[ZHMTabBarController class]]) {
                    ZHMTabBarController *tabbarVC = (ZHMTabBarController *)weakSelf.tabBarController;
                    [tabbarVC selectTabBarItemWithType:ZHMTabBarControllerTypeMine];
                }
                // 跳转控制器
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else { // 不是则检查是否为教练 是的话跳转
                [weakSelf p_chatIconTouchWithUserId:connectList.user_id];
            }
        }];
    }
    // 设置cell 缓存
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.connectListArray[indexPath.row] keyPath:@"connectList" cellClass:[GGSMessageToCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滑动结束编辑
    if (scrollView == self.tableView && self.tableView.scrollEnabled == YES && _isEditing == YES) {
        [_inputToolBar.inputTextView resignFirstResponder];
        
        if (_emoticonView.height_sd == 250) {
            [UIView animateWithDuration:0.25 animations:^{
                _inputContainerView.sd_layout.bottomSpaceToView(self.view, 0);
                _emoticonView.sd_layout
                .heightIs(0);
                [_inputContainerView updateLayout];
                [_emoticonView updateLayout];
            }];
        }
    }
}

/** 处理个人头像点击事件 */
- (void)p_chatIconTouchWithUserId:(NSInteger)userId {
    __weak typeof(self) weakSelf = self;
    // 请求地址
    NSString *requestString = [NSString stringWithFormat:@"api/v1/coach/%ld", userId];
    [ZMApiManager apiSendGETRequestWithApiString:requestString parmater:nil success:^(id responseObject, NSError *error) {
        BOOL state = [responseObject[@"error"] boolValue];
        GGSCoachInfoIcon *infoIcon = [GGSCoachInfoIcon mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (error == nil && state == NO && infoIcon.approved == 1) {
            GGSCoachInfoViewController *coachInfoVC = [[GGSCoachInfoViewController alloc] initWithGameId:infoIcon.game_id coachId:@(userId)];
            // 结束编辑
            [UIView performWithoutAnimation:^{
                [weakSelf.view endEditing:YES];
            }];
            // 跳转到教练信息详情 页
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:coachInfoVC animated:YES];
            });
        }
    } fail:^(id responseObject, NSError *error) {
        
    }];
}

/** 配置当前聊天显示的icon */
- (NSString *)p_chatUserIconWithChatMessageType:(GGSMessageType)messageType userThread:(GGSUserThread *)userThread {
    // 自己接收的消息
    if (messageType == GGSMessageTypeSendToOthers) {
        return userThread.currentUserPic;
    } // 发送给他人的消息
    else if (messageType == GGSMessageTypeSendToMe) {
        return userThread.chatPic;
    }
    return @"";
}


#pragma mark -- JMessageDelegate
/** 发送消息 */
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    NSLog(@"发送消息");
}

// 通知事件监听
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    switch (event.eventType) {
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend:
            NSLog(@"Friend Notification Event ");
            break;
        case kJMSGEventNotificationLoginKicked:
            NSLog(@"LoginKicked Notification Event ");
            break;
        case kJMSGEventNotificationServerAlterPassword:
            NSLog(@"Server Alter Password Notification Event ");
            break;
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"User login status unexpected Notification Event ");
            break;
        default:
            NSLog(@"Other Notification Event ");
            break;
    }
}

/** 接受消息 */
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    NSLog(@"接收消息");
    // 更新未读消息数
    [self p_updateUnReadMessageCount];
    
    // 解析新消息
    GGSJMessageContent *messageContent = [GGSJMessageContent messageContentWithMessage:message];
    // 检查消息是否重复
    BOOL isContain = [self p_isPushMessageContent:messageContent containInContentListArray:self.connectListArray];
    if (isContain) {
        return;
    }
    // 判断当前接受的对话是否有效
    if (messageContent.thread_id != _threadId) {
        return;
    }
    // 创建数据模型
    GGSCoachConnectList *connectInfo = [[GGSCoachConnectList alloc] init];
    connectInfo.user_id = messageContent.user_id;
    // 用户头像数据
    connectInfo.messageType = GGSMessageTypeSendToMe;
    connectInfo.userProfilePic = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToMe userThread:_userThread];
    connectInfo.body = messageContent.body;
    connectInfo.showArtString = [self p_artStingWithMessage:connectInfo.body];
    connectInfo.created_at = messageContent.created_at;
    connectInfo.showTime = [GGSDateStringManager showStringWithSecond:connectInfo.created_at];
    
    // 是否显示时间
    BOOL isShowMessageTime = [self p_isShowSendMessageTimeWithSendMessage:connectInfo messageArray:self.connectListArray];
    connectInfo.isShowMessageSendTime = isShowMessageTime;
    [self.connectListArray addObject:connectInfo];
    [self.tableView reloadData];
    
    // 滑动到底部
    NSInteger rowCount = self.connectListArray.count;
    if (rowCount > 0) {
        if (self.isEditing == YES) {
            self.isEditing = NO;
        }
        [UIView animateWithDuration:0.2 animations:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(rowCount - 1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } completion:^(BOOL finished) {
            self.isEditing = YES;
        }];
    }
}

/** 接受消息失败 */
- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
    NSLog(@"接受消息失败");
}

/** 发送文本消息 */
- (void)p_sendToJMessageWithTextMessage:(NSString *)textMessage messageType:(GGSConnectMessageType)messageType {
    GGSCoachConnectList *connect = [_connectListArray lastObject];
    // 用户id
    NSInteger userId = [[GGSUserInfoManager shareInstance].user_id integerValue];
    //    // 每条消息对应的唯一标识id
    //    NSInteger tagId = connect.id + 1;
    // 聊天信息处理
    [self.userThread.participants enumerateObjectsUsingBlock:^(GGSParticipants *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.user_id != userId) {
            JMSGMessage *message = [[[GGSJMessageContent alloc] init] createMessageConnectWithUserId:userId
                                                                                               idTag:connect.id
                                                                                            threadId:_threadId
                                                                                           createdAt:[[NSDate date] timeIntervalSince1970]
                                                                                                body:textMessage
                                                                                         contentText:@"文本消息"
                                                                                              chatId:obj.user_id];
            // 发送文本消息
            [JMSGMessage sendMessage:message];
        }
    }];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    NSLog(@"%@", conversation);
}

/**
 1.获取当前消息时间和最新的消息时间
 2.比较两者之间的间距
 3.大于5分钟显示 小于5分钟不显示
 */
- (void)p_showSendMessageTimeWithLastMessage:(GGSCoachConnectList *)connectList
                                       block:(void(^)(long long currentSecond, BOOL isShow))block {
    // 创建时间
    long long createTime = connectList.created_at;
    // 当前时间
    long long currentTime = [[NSDate date] timeIntervalSince1970];
    if (currentTime > (createTime + kMessageBetweenTime)) {
        if (block) {
            block(currentTime, YES);
        }
    } else {
        if (block) {
            block(0, NO);
        }
    }
}


- (BOOL)p_isShowSendMessageTimeWithSendMessage:(GGSCoachConnectList *)sendMessage
                                  messageArray:(NSMutableArray <GGSCoachConnectList *> *)messageArray {
    NSArray *array = [[messageArray reverseObjectEnumerator] allObjects];
    __block BOOL isShowTime = NO;
    [array enumerateObjectsUsingBlock:^(GGSCoachConnectList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isShowMessageSendTime == YES) {
            if (sendMessage.created_at > (obj.created_at + kMessageBetweenTime)) {
                isShowTime = YES;
            }
            // 停止循环
            *stop = YES;
        }
    }];
    return isShowTime;
}


#pragma mark - GGSEmoticonDelegate
/** 发送选中的图片选中的图片 */
- (void)emotiocnView:(GGSEmoticonView *)emoticonView didClickedItemAtIndex:(NSInteger)index bottomIndex:(NSInteger)bottomIndex {
    NSString *imageName = @"";
    switch (bottomIndex) {
        case 0:
        {   // 发送静态图片
            if ((index % kEachPageCount) == 20) {
                [_inputToolBar.inputTextView deleteBackward];
            } else {
                // 发送静态表情
                GGSEmoticonItem *emoticonItem = _staticEmoticonArray[index];
                imageName = emoticonItem.imageName;
                NSString *currentText = _inputToolBar.inputTextView.text;
                if ([NSString isBlankString:currentText]) {
                    _inputToolBar.inputTextView.text = emoticonItem.imageChineseName;
                    // 添加编辑数据
                    NSRange range = NSMakeRange(0, [emoticonItem.imageChineseName length]);
                    NSValue *value = [NSValue valueWithRange:range];
                    [self.addedRangeArray addObject:value];
                } else {
                    // 添加编辑数据
                    NSRange range = NSMakeRange([currentText length], [emoticonItem.imageChineseName length]);
                    NSValue *value = [NSValue valueWithRange:range];
                    
                    [self.addedRangeArray addObject:value];
                    currentText = [NSString stringWithFormat:@"%@%@", currentText, emoticonItem.imageChineseName];
                    _inputToolBar.inputTextView.text = currentText;
                }
                // 更改输入框的高度
                CGFloat height = [self getInputToolBarHeight:_inputToolBar.inputTextView];
                [self p_autoChangeAutoLayoutHeiht:height];
            }
        }
            break;
        case 1:
        {   // 发送动态图片
            GGSEmoticonItem *emoticonItem = _emoticonArray[index];
            NSString *gifName = emoticonItem.imageName;
            if ([gifName hasSuffix:@".gif"]) {
                gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
                gifName = [NSString stringWithFormat:@"[gif:%@:]", gifName];
            }
            if ([NSString isBlankString:gifName] == NO) {
                [self p_sendTextMessage:gifName block:nil];
            }
        }
            break;
        default:
            break;
    }
    
    return;
}


/**
 创建提前显示的消息
 
 @param textMessage 消息的内容
 @param messageType 消息的样式
 @return item
 */
- (GGSCoachConnectList *)p_preShowConnectInfoWithTextMessage:(NSString *)textMessage
                                                 messageType:(GGSConnectMessageType)messageType {
    // 配置能显示信息 先做显示如果 发送时显示小圆圈 发送成功再做处理
    GGSCoachConnectList *connectInfo = [[GGSCoachConnectList alloc] init];
    connectInfo.user_id = [[GGSUserInfoManager shareInstance].user_id integerValue];
    // 用户头像数据
    connectInfo.messageType = GGSMessageTypeSendToOthers;
    connectInfo.userProfilePic = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToOthers userThread:_userThread];
    connectInfo.body = textMessage;
    connectInfo.gifImageName = [self p_gifShowImageNameWithName:textMessage
                                             meesageConnectType:messageType];
    // 消息的样式
    connectInfo.connectMessageType = messageType;
    // 显示的内容
    if (messageType == GGSConnectMessageTypeStaticImage) {
        connectInfo.showArtString = [self p_artStingWithMessage:textMessage];
    } else if (messageType == GGSConnectMessageTypeMessageText) {
        connectInfo.showArtString = [self p_ArtStringWithString:textMessage];
    }
    connectInfo.thread_id = _userThread.thread_id;
    connectInfo.created_at = [[NSDate date] timeIntervalSince1970];
    connectInfo.showTime = [GGSDateStringManager showStringWithSecond:connectInfo.created_at];
    // 是否显示最后一条信息的时间
    BOOL isShowMessageTime = [self p_isShowSendMessageTimeWithSendMessage:connectInfo messageArray:self.connectListArray];
    connectInfo.isShowMessageSendTime = isShowMessageTime;
    return connectInfo;
}

//
//// 更新输入框高度
//weakSelf.inputContainerView.sd_layout.heightIs(45);
//[weakSelf.inputContainerView updateLayout];

/** 发送聊天信息的 */
- (void)p_sendTextMessage:(NSString *)textMessage block:(void(^)())block {
    if ([NSString isBlankString:textMessage]) {
        [_inputToolBar.inputTextView resignFirstResponder];
        return;
    }
    // 获取当前显示的信息类型
    GGSConnectMessageType messageType = [self p_connectMeesageTypeWithMessageBody:textMessage];
    // 更新相应的约束
    if (messageType == GGSConnectMessageTypeNone) {
        // 初始化添加的表情
        self.addedRangeArray = [NSMutableArray array];
        self.inputToolBar.inputTextView.text = @"";
        self.inputContainerView.sd_layout.heightIs(45);
        [self.inputContainerView updateLayout];
    }
    else if (messageType == GGSConnectMessageTypeStaticImage) {
        // 静态图片
        __block NSString *sendMessage = textMessage;
        [self.staticEmoticonArray enumerateObjectsUsingBlock:^(GGSEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sendMessage containsString:obj.imageChineseName]) {
                // 替换输入的文字
                sendMessage = [sendMessage stringByReplacingOccurrencesOfString:obj.imageChineseName withString:obj.en_name];
            }
        }];
        textMessage = sendMessage;
    }
    // 配置能显示信息 先做显示如果 发送时显示小圆圈 发送成功再做处理
    GGSCoachConnectList *connectInfo = [self p_preShowConnectInfoWithTextMessage:textMessage
                                                                     messageType:messageType];
    [self.connectListArray addObject:connectInfo];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.connectListArray.count - 1 inSection:0];
    __weak typeof(self) weakSelf = self;
    _isEditing = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } completion:^(BOOL finished) {
        // 开启转圈动画
        GGSMessageToCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        // 开始发送消息
        [cell startAnimation];
        
        [weakSelf p_sendSeverMessage:textMessage messageType:messageType threadId:_threadId block:^{
            // JMessage 发送消息
            [weakSelf p_sendToJMessageWithTextMessage:textMessage messageType:messageType];
            // 发送完成消息置空
            weakSelf.presendMessage = @"";
            // 结束发送动作
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell endAnimation];
                [weakSelf.tableView reloadData];
                weakSelf.isEditing = YES;
            });
            if (block) {
                block();
            }
        }];
    }];
}

- (void)p_sendSeverMessage:(NSString *)message messageType:(GGSConnectMessageType)messageType threadId:(NSInteger)threadId block:(void(^)())block {
    // 发送信息 发送完成结束转圈
    NSDictionary *parmaterMessage = @{@"message" : message,
                                      @"thread_id" : @(threadId)};
    __weak typeof(self) weakSelf = self;
    [NetHelp sendMessageWithParmater:parmaterMessage block:^(GGSCoachConnectList *response, NSError *error) {
        // 发送信息
        if (error == nil && response) {
            // 移除手动添加元素 并添加请求返回元素
            [weakSelf.connectListArray removeLastObject];
            // 是否显示最后一条信息的时间
            BOOL isShowTime = [weakSelf p_isShowSendMessageTimeWithSendMessage:response messageArray:weakSelf.connectListArray];
            response.isShowMessageSendTime = isShowTime;
            response.messageType = GGSMessageTypeSendToOthers;
            response.showTime = [GGSDateStringManager showStringWithSecond:response.created_at];
            if (messageType == GGSConnectMessageTypeMessageText) {
                response.showArtString = [weakSelf p_ArtStringWithString:response.body];
            } else if (messageType == GGSConnectMessageTypeStaticImage) {
                response.showArtString = [weakSelf p_artStingWithMessage:response.body];
            }
            response.connectMessageType = messageType;
            response.body = message;
            response.gifImageName = [weakSelf p_gifShowImageNameWithName:message
                                                      meesageConnectType:messageType];
            // 用户头像数据
            response.userProfilePic = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToOthers userThread:weakSelf.userThread];
            [weakSelf.connectListArray addObject:response];
            NSLog(@"%@", response.showTime);
        }
        if (block) {
            block();
        }
    }];
}

/** 发送消息 */
- (void)textView:(GGSChatInputTextView *)textView sendMessage:(NSString *)message {
    [self p_sendTextMessage:message block:nil];
}


- (GGSEmoticonView *)emoticonView {
    if (_emoticonView == nil) {
        _emoticonView = [[GGSEmoticonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)
                                                      delegate:self
                                            bottomEmotionArray:self.bottomEmoticonArray];
        _emoticonView.defaultSelectedIndex = 0;
        _emoticonView.emoticonArray = self.staticEmoticonArray;
        _emoticonView.backgroundColor = kBACKGROUND_COLOR;
    }
    return _emoticonView;
}

- (NSMutableArray *)bottomEmoticonArray {
    if (_bottomEmoticonArray == nil) {
        _bottomEmoticonArray = [NSMutableArray array];
        GGSEmoticonItem *emoticon = [GGSEmoticonItem emoticonWithImageName:@"ggs_test_emoticon"
                                                          imageChineseName:@"测试"
                                                                    enName:@""];
        GGSEmoticonItem *emoticon1 = [GGSEmoticonItem emoticonWithImageName:@"ggs_test_emoticon"
                                                           imageChineseName:@"测试"
                                                                     enName:@""];
        [_bottomEmoticonArray addObjectsFromArray:@[
                                                    emoticon,
                                                    emoticon1
                                                    ]];
    }
    return _bottomEmoticonArray;
}

- (NSMutableArray <GGSEmoticonItem *> *)emoticonArray {
    if (_emoticonArray == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ggs_emoticon_gif" ofType:@".plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *emoticonarray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGSEmoticonItem *emoticon = [GGSEmoticonItem mj_objectWithKeyValues:obj];
            [emoticonarray addObject:emoticon];
        }];
        _emoticonArray = emoticonarray;
        
        if ((_emoticonArray.count % kEachPageCount) != 0) {
            NSInteger needAddItemCount = kEachPageCount * (_emoticonArray.count / kEachPageCount + 1) - _emoticonArray.count;
            for (int i = 0; i < needAddItemCount; i++) {
                GGSEmoticonItem *emoticon = [GGSEmoticonItem emoticonWithImageName:@""
                                                                  imageChineseName:@""
                                                                            enName:@""];
                [_emoticonArray addObject:emoticon];
            }
        }
    }
    return _emoticonArray;
}

- (NSMutableArray <GGSEmoticonItem *> *)staticEmoticonArray {
    if (_staticEmoticonArray == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ggs_emoticon" ofType:@".plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *emoticonarray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGSEmoticonItem *emoticon = [GGSEmoticonItem mj_objectWithKeyValues:obj];
            [emoticonarray addObject:emoticon];
        }];
        // 插入元素
        [emoticonarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ((idx % kEachPageCount) == 20) {
                GGSEmoticonItem *item = [GGSEmoticonItem emoticonWithImageName:@"ggs_chat_delete"
                                                              imageChineseName:@""
                                                                        enName:@""];
                [emoticonarray insertObject:item atIndex:idx];
            }
        }];
        
        _staticEmoticonArray = emoticonarray;
        
        if ((_staticEmoticonArray.count % kEachPageCount) != 0) {
            NSInteger needAddItemCount = kEachPageCount * (_staticEmoticonArray.count / kEachPageCount + 1) - _staticEmoticonArray.count;
            for (int i = 0; i < needAddItemCount; i++) {
                GGSEmoticonItem *emoticon = [GGSEmoticonItem emoticonWithImageName:@""
                                                                  imageChineseName:@""
                                                                            enName:@""];
                [_staticEmoticonArray addObject:emoticon];
            }
        }
    }
    return _staticEmoticonArray;
}

#endif
