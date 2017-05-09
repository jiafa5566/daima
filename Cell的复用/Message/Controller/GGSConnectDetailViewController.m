 //
//  GGSConnectDetailViewController.m
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSConnectDetailViewController.h"
#import "GGSCoachInfoViewController.h"

#import "GGSRefreshHeaderView.h"
#import "GGSMessageToCell.h"
#import "GGSTopToolBar.h"
#import "GGSEmoticonView.h"
#import "GGSChatInputTextView.h"
#import "GGSMessageInputView.h"

#import "GGSDateStringManager.h"
#import "GGSCoachConnectList.h"
#import "GGSConnectDetailInfo.h"
#import "GGSUserInfoManager.h"
#import "GGSMessageSend.h"
#import "GGSBaseThread.h"
#import <MJExtension/MJExtension.h>
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "GGSUserThread.h"
#import "GGSParticipants.h"
#import "GGSTeachInfoAddDetail.h"
#import <MJRefresh/MJRefresh.h>
#import "ZMApiManager.h"
#import "GGSCoachInfoIcon.h"
#import "UIViewController+GGSBackButtonHandel.h"
#import "GGSGGSLastMessage.h"
#import "GGSPTPusherData.h"
#import "GGSThreadSubItem.h"
//#import "GGSShowRedPackageView.h"
#import "ZHMTabBarController.h"
#import "GGSPTPusherManager.h"
#import <JMessage/JMessage.h>
#import "UIImage+Color.h"
#import "GGSTopToolBar.h"
#import "GGSJMessageLogin.h"
#import "GGSJMessageUser.h"
#import "GGSJMessagePayload.h"
#import "GGSChatJMessage.h"
#import "GGSJMessageLoginManager.h"
#import "GGSJMessageContent.h"
#import "GGSEmoticonItem.h"
#import "GGSShowMessageAdapter.h"

static const CGFloat kInputContainerViewH = 50.f;
static const CGFloat kEmoticonToBottomMargin = 250.f;
/** 消息间隔时长 */
static NSInteger kMessageBetweenTime = 60 * 2;
static NSString *jpush_appKey = @"8e2e0621dc03f15e304f45b4";

typedef NS_ENUM(NSInteger, GGSChatLoadRefreshType) {
    /** 无 */
    GGSChatLoadRefreshTypeNone = 0,
    /** header 刷新 */
    GGSChatLoadRefreshTypeHeader,
    /** footer 刷新 */
    GGSChatLoadRefreshTypeFooter,
};

@interface GGSConnectDetailViewController ()
<UITextViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
JMessageDelegate,
JMSGConversationDelegate,
GGSEmoticonDelegate,
GGSMessageInputDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *connectListArray;

// 分之id
@property (nonatomic, assign) NSInteger threadId;
// 是否正在编辑
@property (nonatomic, assign) BOOL isEditing;
// 高度字典
@property (nonatomic, strong) NSMutableDictionary *heightDictionary;

@property (nonatomic, assign) NSInteger keyBoardHeight;
// 当前页面
@property (nonatomic, assign) NSInteger currentPage;
/** 最后一次发送消息的时间 */
@property (nonatomic, assign) long long lastMessageTime;
/** 发送的信息 */
@property (nonatomic, strong) NSString *presendMessage;

@property (nonatomic, strong) GGSUserThread *userThread;
/** 表情 */
@property (nonatomic, strong) GGSEmoticonView *emoticonView;
/** 底部的表情 */
@property (nonatomic, strong) NSMutableArray <NSString *>*bottomEmoticonArray;
/** 表情图标 */
@property (nonatomic, strong) NSMutableArray <GGSEmoticonItem *>*emoticonArray;
/** 静态图片 */
@property (nonatomic, strong) NSMutableArray <GGSEmoticonItem *>*staticEmoticonArray;
/** 添加的元素 */
@property (nonatomic, strong) NSMutableArray *addedRangeArray;
/** 消息输入控件 */
@property (nonatomic, strong) GGSMessageInputView *messageInputView;

@end

@implementation GGSConnectDetailViewController

- (instancetype)init {
    NSAssert(nil, @"不能通过init 方法创建 只能通过 initWithThreadId:");
    return nil;
}

- (instancetype)initWithThreadId:(NSInteger)threadId {
    return [self initWithThreadId:threadId preMessage:@""];
}

- (instancetype)initWithThreadId:(NSInteger)threadId preMessage:(NSString *)preMessage {
    self = [super init];
    if (self) {
        _threadId = threadId;
        _presendMessage = preMessage;
        _lastMessageTime = 0;
    }
    return self;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableView的起始点在导航栏下方
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBACKGROUND_COLOR;

    // 下级控件自动布局
    [self p_setupSubViewAutoLayout];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 注册下拉刷新
    self.tableView.mj_header = [GGSRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(headerLoadMoreMessage)];
    // 注册上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadNewestMessage)];
}
// 设置navigationBar样式 暂时放这里，后续自己调，模拟器好了 写错地方了

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
                [weakSelf p_sendCurrentMessage:weakSelf.presendMessage];
//                [weakSelf textView:weakSelf.inputToolBar.inputTextView sendMessage:weakSelf.presendMessage];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除代理
    [JMessage removeDelegate:self withConversation:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}

/** 检测 控制器 pop 方法 */
- (BOOL)navigationShouldPopOnBackButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    [UIView performWithoutAnimation:^{
        [self.view endEditing:YES];
    }];
    return NO;
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
        [thread handelShowItem];
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
                switch (connectList.connectMessageType) {
                    case GGSConnectMessageTypeMessageText:
                    {   // 纯文本
                        connectList.showArtString = [weakSelf p_artStringWithMessageBody:connectList.body];
                    }
                        break;
                    case GGSConnectMessageTypeStaticImage:
                    {   // 静态图片
                        connectList.showArtString = [[GGSShowMessageAdapter shareAdapter] staticImageArtStringWithMessageBody:connectList.body
                                                                                                             staticImageArray:weakSelf.staticEmoticonArray];
                    }
                        break;
                    case GGSConnectMessageTypeGifImage:
                    {   // GIF 图
                        connectList.gifImageName = [[GGSShowMessageAdapter shareAdapter] gifImageNameWithImageName:connectList.body
                                                                                                       connectType:GGSConnectMessageTypeGifImage];
                    }
                        break;
                    default:
                        break;
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

#pragma mark - Notification
/** 键盘弹起事件处理 */
- (void)keyBoradWillShow:(NSNotification *)notification {
    
    NSDictionary *dictionary = notification.userInfo;
    CGRect keyBoradRect = [dictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = CGRectGetHeight(keyBoradRect);
    _keyBoardHeight = keyBoardHeight;
    
    _messageInputView.currentInputMode = GGSMessageInputModeKeyBoard;
    
//    // 是否显示占位符
//    _inputToolBar.inputTextView.isShowPlaceHolder = NO;
    
    self.tableView.scrollEnabled = NO;
    _isEditing = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.messageInputView.sd_layout.bottomSpaceToView(self.view, (_keyBoardHeight));
        [self.messageInputView updateLayout];
        // 滑动到底部
        [self p_scrollToBottomWithMessageListArray:_connectListArray];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.f), dispatch_get_main_queue(), ^{
            self.tableView.scrollEnabled = YES;
            _isEditing = YES;
        });
    }];
    
    [self.messageInputView changeModeButtonState:NO];
    
    // 更改字体颜色
    [self.messageInputView updateInputViewStateWithMessageType:GGSConnectMessageTypeMessageText];
}

/** 键盘回收 */
- (void)keyboardWillHide:(NSNotification *)notification {
    if (_messageInputView.currentInputMode == GGSMessageInputModeKeyBoard) {
        [UIView animateWithDuration:0.2 animations:^{
            self.messageInputView.sd_layout.bottomSpaceToView(self.view, 0);
            [self.messageInputView  updateLayout];
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
- (BOOL)p_isCurrentMessageId:(NSInteger)messageId containInConnectListArray:(NSMutableArray <GGSCoachConnectList *>*)connectListArray {
    __block BOOL isContain = NO;
    [connectListArray enumerateObjectsUsingBlock:^(GGSCoachConnectList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id == messageId) {
            isContain = YES;
            *stop = YES;
        }
    }];
    return isContain;
}

/** 控件的自动布局 */
- (void)p_setupSubViewAutoLayout {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageInputView];
    [self.view insertSubview:self.emoticonView belowSubview:_messageInputView];

    
    _messageInputView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .rightEqualToView(self.view)
    .heightIs(kInputContainerViewH);
    
    _emoticonView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .rightEqualToView(self.view)
    .heightIs(kInputContainerViewH);
    
    _tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomSpaceToView(_messageInputView, 0)
    .rightEqualToView(self.view);
}

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
- (NSMutableAttributedString *)p_artStringWithMessageBody:(NSString *)body {
    // 判断为空的情况
    if ([NSString isBlankString:body]) {
        return [NSMutableAttributedString new];
    }
    
    NSMutableAttributedString *artString = [[NSMutableAttributedString alloc] initWithString:body];
    NSMutableDictionary *parmater = [NSMutableDictionary dictionary];
    // 行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:1.f];
    paragraphStyle1.minimumLineHeight = 25.f;
    paragraphStyle1.alignment = NSTextAlignmentLeft;
    paragraphStyle1.lineBreakMode = NSLineBreakByCharWrapping;
    parmater[NSParagraphStyleAttributeName] = paragraphStyle1;
    // 字间距
    parmater[NSKernAttributeName] = @(0.5f);
    [artString setAttributes:parmater range:NSMakeRange(0, [body length])];
    
    return artString;
}


/**
 处理发送过来的消息数据

 @param message 发送的消息
 @return 处理之后的富文本消息
 */
- (NSMutableAttributedString *)p_staticImageArtStringWithMessageBody:(NSString *)body {
    // 处理显示的艺术字
    __block NSMutableAttributedString *artString = [self p_artStringWithMessageBody:body];
    [self.staticEmoticonArray enumerateObjectsUsingBlock:^(GGSEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([body containsString:obj.en_name]) {
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
            if (connectList.messageType == GGSMessageTypeSendToOthers) {
                if ([weakSelf.tabBarController isKindOfClass:[ZHMTabBarController class]]) {
                    ZHMTabBarController *tabbarVC = (ZHMTabBarController *)weakSelf.tabBarController;
//                    [tabbarVC selectTabBarItemWithType:ZHMTabBarControllerTypeMine];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollViewDidScroll:tableView];
}

#pragma mark - GGSMessageInputDelegate
/** 更改当前的输入样式 */
- (void)inputTextView:(GGSMessageInputView *)inputTextView didChangeCurrentInputMode:(GGSMessageInputMode)inputMode {
    if (inputMode == GGSMessageInputModeKeyBoard) {
        // 键盘
        _isEditing = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.emoticonView.sd_layout
            .heightIs(0);
            [weakSelf.emoticonView updateLayout];
        } completion:^(BOOL finished) {
            weakSelf.isEditing = YES;
        }];
        // 隐藏键盘
        [inputTextView showInputView];
//        [_inputToolBar.inputTextView resignFirstResponder];
        // 更新输入框的状态
        [_messageInputView updateInputViewStateWithMessageType:GGSConnectMessageTypeMessageText];
    } else if (inputMode == GGSMessageInputModeEmoticon) {
        // 表情
        __weak typeof(self) weakSelf = self;
        _messageInputView.currentInputMode = GGSMessageInputModeEmoticon;
        _isEditing = NO;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.messageInputView.sd_layout.bottomSpaceToView(self.view, kEmoticonToBottomMargin);
            weakSelf.emoticonView.sd_layout
            .heightIs(kEmoticonToBottomMargin);
            [weakSelf.emoticonView updateLayout];
        } completion:^(BOOL finished) {
            // 滑动到底部
            [weakSelf p_scrollToBottomWithMessageListArray:_connectListArray];
            weakSelf.isEditing = YES;
        }];
        // 显示键盘
        [inputTextView hideInputView];
//        [_inputToolBar.inputTextView becomeFirstResponder];
        // 更新输入框的状态
        if (_emoticonView.defaultSelectedIndex == 1) {
            [_messageInputView updateInputViewStateWithMessageType:GGSConnectMessageTypeGifImage];
        } else {
            [_messageInputView updateInputViewStateWithMessageType:GGSConnectMessageTypeStaticImage];
        }
    }
}

- (void)beginEditInputTextView:(UITextView *)textView {
    CGFloat height = [self p_currentInputViewHeightWithInputText:textView.text];
    [UIView animateWithDuration:0.1 animations:^{
        // 更新布局
        _messageInputView.sd_layout
        .heightIs(height);
        [_messageInputView updateLayout];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeEditInputTextView:(UITextView *)textView text:(NSString *)text {
    CGFloat height = [self p_currentInputViewHeightWithInputText:textView.text];
    [UIView animateWithDuration:0.1 animations:^{
        // 更新布局
        _messageInputView.sd_layout
        .heightIs(height);
        [_messageInputView updateLayout];
    } completion:^(BOOL finished) {
        
    }];
    // 更新发送按钮的状态
    [_emoticonView changeSendButtonStateWithCurrentText:textView.text];
}

- (CGFloat)p_currentInputViewHeightWithInputText:(NSString *)inputText {
    CGFloat height = [NSString zm_titleLimitSize:CGSizeMake(SCREEN_WIDTH - 65, CGFLOAT_MAX)
                                           title:inputText
                                            font:[UIFont systemFontOfSize:16]].height;
    
    NSLog(@"needHeight ----- %.f", height);
    // 获取当前输入文本的高度
    CGFloat showHeight = height + 30;
    if (showHeight < 50) {
        showHeight = 50;
    } else if (showHeight > 120) {
        showHeight = 120;
    }
    return showHeight;
}

/** 发送消息 */
- (void)inputView:(GGSMessageInputView *)inputView sendCurrentText:(NSString *)text {
    [self p_sendCurrentMessage:text];
}

- (void)p_sendCurrentMessage:(NSString *)message {
    if ([NSString isBlankString:message]) {
        [_messageInputView hideInputView];
        return;
    }
    
    GGSCoachConnectList *connectInfo = [GGSCoachConnectList preSendconnectInfoWithUserId:[[GGSUserInfoManager shareInstance].user_id integerValue]
                                                                             messageBody:message
                                                                              createTime:[[NSDate date] timeIntervalSince1970]];
    
    // 更新相应的约束
    switch (connectInfo.connectMessageType) {
        case GGSConnectMessageTypeMessageText:
        {   // 纯文本
            self.addedRangeArray = [NSMutableArray array];
            [_messageInputView clearCurrentShowText];
            self.messageInputView.sd_layout.heightIs(50);
            [self.messageInputView updateLayout];
            
            connectInfo.showArtString = [self p_artStringWithMessageBody:connectInfo.body];
        }
            break;
        case GGSConnectMessageTypeStaticImage:
        {   // 静态图片
            self.addedRangeArray = [NSMutableArray array];
            [_messageInputView clearCurrentShowText];
            self.messageInputView.sd_layout.heightIs(50);
            [self.messageInputView updateLayout];

            message = [[GGSShowMessageAdapter shareAdapter] sendToServerStringWithMessageBody:message staticImageArray:self.staticEmoticonArray];
            connectInfo.showArtString = [self p_staticImageArtStringWithMessageBody:message];
        }
            break;
        case GGSConnectMessageTypeGifImage:
        {   // GIF 图片
            connectInfo.gifImageName = [self p_gifShowImageNameWithName:message meesageConnectType:GGSConnectMessageTypeGifImage];
        }
            break;
            
        default:
            break;
    }
    // 是否显示时间
    BOOL isShowMessageTime = [self p_isShowSendTimeAtMessageArray:self.connectListArray];
    connectInfo.isShowMessageSendTime = isShowMessageTime;
    // 显示的头像
    NSString *userIcon = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToOthers userThread:_userThread];
    connectInfo.userProfilePic = userIcon;
    [self.connectListArray addObject:connectInfo];
    [self.tableView reloadData];
    
    // 配置能显示信息 先做显示如果 发送时显示小圆圈 发送成功再做处理
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
        // 更新发送按钮的状态
        [weakSelf.emoticonView changeSendButtonStateWithCurrentText:@""];
        [weakSelf p_sendSeverMessage:message messageType:connectInfo.connectMessageType threadId:_threadId block:^{
            // JMessage 发送消息
            [weakSelf p_sendToJMessageWithTextMessage:message messageType:connectInfo.connectMessageType];
            // 发送完成消息置空
            weakSelf.presendMessage = @"";
            // 结束发送动作
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell endAnimation];
                [weakSelf.tableView reloadData];
                weakSelf.isEditing = YES;
            });
        }];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滑动结束编辑
    if (scrollView == self.tableView && self.tableView.scrollEnabled == YES && _isEditing == YES) {
        [_messageInputView hideInputView];
        
        if (_emoticonView.height_sd == 250) {
            // 更改切换按钮的状态
            [UIView animateWithDuration:0.25 animations:^{
                _messageInputView.sd_layout.bottomSpaceToView(self.view, 0);
                _emoticonView.sd_layout
                .heightIs(0);
                [_messageInputView updateLayout];
                [_emoticonView updateLayout];
            }];
        }
        [self.messageInputView changeModeButtonState:NO];
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
    BOOL isContain = [self p_isCurrentMessageId:messageContent.id containInConnectListArray:self.connectListArray];
    if (isContain) {
        return;
    }
    // 判断当前接受的对话是否有效
    if (messageContent.thread_id != _threadId) {
        return;
    }
    // 创建数据模型
    GGSCoachConnectList *connectInfo = [GGSCoachConnectList connectInfoWithMessageContent:messageContent];
    connectInfo.userProfilePic = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToMe userThread:_userThread];
    switch (connectInfo.connectMessageType) {
        case GGSConnectMessageTypeMessageText:
        {   // 纯文本
            connectInfo.showArtString = [self p_artStringWithMessageBody:connectInfo.body];
        }
            break;
        case GGSConnectMessageTypeStaticImage:
        {   // 静态图片
            connectInfo.showArtString = [[GGSShowMessageAdapter shareAdapter] staticImageArtStringWithMessageBody:connectInfo.body
                                                                                                 staticImageArray:self.staticEmoticonArray];
        }
            break;
        case GGSConnectMessageTypeGifImage:
        {   // GIF 图
            connectInfo.gifImageName = [[GGSShowMessageAdapter shareAdapter] gifImageNameWithImageName:connectInfo.body
                                                                                           connectType:GGSConnectMessageTypeGifImage];
        }
            break;
        default:
            break;
    }
    // 是否显示时间
    BOOL isShowMessageTime = [self p_isShowSendTimeAtMessageArray:self.connectListArray];
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
- (BOOL)p_isShowSendTimeAtMessageArray:(NSMutableArray <GGSCoachConnectList *> *)messageArray {
    NSArray *array = [[messageArray reverseObjectEnumerator] allObjects];
    __block BOOL isShowTime = NO;
    long long currentTime = [[NSDate date] timeIntervalSince1970];
    [array enumerateObjectsUsingBlock:^(GGSCoachConnectList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isShowMessageSendTime == YES) {
            if (currentTime > (obj.created_at + kMessageBetweenTime)) {
                isShowTime = YES;
            }
            // 停止循环
            *stop = YES;
        }
    }];
    return isShowTime;
}

/** 处理消息显示处理 */
NSInteger sortMessageType(id object1, id object2, void *cha) {
    GGSCoachConnectList *connect1 = (GGSCoachConnectList *)object1;
    GGSCoachConnectList *connect2 = (GGSCoachConnectList *)object2;
   
    if (connect1.created_at > connect2.created_at) {
        return NSOrderedDescending;
    } else if (connect1.created_at < connect2.created_at) {
        return  NSOrderedAscending;
    }
    return NSOrderedSame;
}

- (NSMutableArray *)sortMessageListArray:(NSMutableArray *)messageListArray {
    NSArray *array = [messageListArray sortedArrayUsingFunction:sortMessageType context:nil];
    return [NSMutableArray arrayWithArray:array];
}

#pragma mark - GGSEmoticonDelegate
/** 发送选中的图片选中的图片 */
- (void)emotiocnView:(GGSEmoticonView *)emoticonView didClickedItemAtIndex:(NSInteger)index bottomIndex:(NSInteger)bottomIndex {
    NSString *imageName = @"";
    switch (bottomIndex) {
        case 0:
        {   // 发送静态图片
            if ((index % kEachPageCount) == 20) {
                [_messageInputView deleteInputViewBackWard];
            } else {
                // 发送静态表情
                GGSEmoticonItem *emoticonItem = _staticEmoticonArray[index];
                imageName = emoticonItem.imageName;
                NSString *currentText = _messageInputView.currentShowText;
                if ([NSString isBlankString:currentText]) {
                    _messageInputView.currentShowText = emoticonItem.imageChineseName;
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
                    _messageInputView.currentShowText = currentText;
                }
            }
            // 更新高度
            CGFloat height = [self p_currentInputViewHeightWithInputText:_messageInputView.currentShowText];
            [UIView animateWithDuration:0.1 animations:^{
                // 更新布局
                _messageInputView.sd_layout
                .heightIs(height);
                [_messageInputView updateLayout];
            } completion:^(BOOL finished) {
                
            }];
            // 更改按钮的状态
            [_emoticonView changeSendButtonStateWithCurrentText:_messageInputView.currentShowText];
            // 更新输入框偏移量
            [_messageInputView updateInputViewContentOffSet];
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
                [self p_sendCurrentMessage:gifName];
            }
        }
            break;
        default:
            break;
    }
    
    return;
}

/** 点击底部的图片 */
- (void)emotiocnView:(GGSEmoticonView *)emoticonView didClickedBottomItemAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            emoticonView.emoticonArray = self.staticEmoticonArray;
            [self.messageInputView updateInputViewStateWithMessageType:GGSConnectMessageTypeStaticImage];
            [self.emoticonView changeSendButtonStateWithCurrentText:_messageInputView.currentShowText];
        }
            break;
        case 1:
        {
            emoticonView.emoticonArray = self.emoticonArray;
            [self.messageInputView updateInputViewStateWithMessageType:GGSConnectMessageTypeGifImage];
            [self.emoticonView changeSendButtonStateWithCurrentText:@""];
        }
            break;
        default:
            break;
    }
}

- (void)sendCurrentInputText {
    // 发送当前的输入信息
    [self p_sendCurrentMessage:_messageInputView.currentShowText];
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
            BOOL isShowTime = [weakSelf p_isShowSendTimeAtMessageArray:self.connectListArray];
            response.isShowMessageSendTime = isShowTime;
            response.messageType = GGSMessageTypeSendToOthers;
            response.showTime = [GGSDateStringManager showStringWithSecond:response.created_at];
            if (messageType == GGSConnectMessageTypeMessageText) {
                response.showArtString = [weakSelf p_artStringWithMessageBody:response.body];
            } else if (messageType == GGSConnectMessageTypeStaticImage) {
                response.showArtString = [weakSelf p_staticImageArtStringWithMessageBody:response.body];
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

#pragma mark - Getter
- (NSMutableArray *)connectListArray {
    if (_connectListArray == nil) {
        _connectListArray = [NSMutableArray array];
    }
    return _connectListArray;
}

- (NSMutableDictionary *)heightDictionary {
    if (_heightDictionary == nil) {
        _heightDictionary = [NSMutableDictionary dictionary];
    }
    return _heightDictionary;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = kBACKGROUND_COLOR;
    }
    return _tableView;
}

- (NSInteger)currentPage {
    if (_currentPage <= 0) {
        _currentPage = 1;
    }
    return _currentPage;
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
        GGSEmoticonItem *emoticon = [GGSEmoticonItem emoticonWithImageName:@"ggs_normal_emoticon"
                                                          imageChineseName:@"测试"
                                                                    enName:@""];
        GGSEmoticonItem *emoticon1 = [GGSEmoticonItem emoticonWithImageName:@"ggs_gif_emoticon"
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
        _emoticonArray = [NSMutableArray array];
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
        _staticEmoticonArray = [NSMutableArray array];
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
                GGSEmoticonItem *item = [GGSEmoticonItem emoticonWithImageName:@"ggs_emoticon_delete"
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
        // 替换最后一个元素
        GGSEmoticonItem *item = [GGSEmoticonItem emoticonWithImageName:@"ggs_emoticon_delete"
                                                      imageChineseName:@""
                                                                enName:@""];
        [_staticEmoticonArray replaceObjectAtIndex:_staticEmoticonArray.count - 1 withObject:item];
    }
    return _staticEmoticonArray;
}

- (GGSMessageInputView *)messageInputView {
    if (_messageInputView == nil) {
        _messageInputView = [[GGSMessageInputView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)
                                                              delegate:self];
    }
    return _messageInputView;
}

- (NSMutableArray *)addedRangeArray {
    if (_addedRangeArray == nil) {
        _addedRangeArray = [NSMutableArray array];
    }
    return _addedRangeArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#if 0


//#pragma mark - GGSTopToolBarDelegate
///** <#Description#> */
//- (void)inputTxtViewShouldBeginEdit:(GGSChatInputTextView *)messageInputTextView {
//    CGFloat height = [self getInputToolBarHeight:messageInputTextView];
//    [self p_autoChangeAutoLayoutHeiht:height];
//}
//
//- (void)inputTextViewDidChange:(GGSChatInputTextView *)messageInputTextView {
//    NSLog(@"---textView 高度 == %.f", [self getTextViewContentH:messageInputTextView]);
//
//    CGFloat height = [self getInputToolBarHeight:messageInputTextView];
//    [self p_autoChangeAutoLayoutHeiht:height];
//}
//
//- (void)inputTextViewDidBeginEdit:(GGSChatInputTextView *)messageInputTextView {
//    CGFloat height = [self getInputToolBarHeight:messageInputTextView];
//    [self p_autoChangeAutoLayoutHeiht:height];
//}
//
//- (void)inpuTextViewDidEndEdit:(GGSChatInputTextView *)messageInputTextView {
//    CGFloat height = [self getInputToolBarHeight:messageInputTextView];
//    [self p_autoChangeAutoLayoutHeiht:height];
//}
//
//- (CGFloat)getInputToolBarHeight:(UITextView *)textView {
//    CGFloat textViewHeight = [self getTextViewContentH:textView];
//    textViewHeight = textViewHeight + 10;
//    // 最高的toolBar 高度
//    if (textViewHeight >= 110) {
//        textViewHeight = 110;
//    }
//    return textViewHeight;
//}
//
///** 设置当前的自动布局 */
//- (void)p_autoChangeAutoLayoutHeiht:(CGFloat)height {
////    // 获取当前输入文本的高度
////    CGSize textSize = [NSString zm_titleLimitSize:CGSizeMake(self.inputContainerView.width_sd - 20, MAXFLOAT) title:_inputToolBar.inputTextView.text font:[UIFont systemFontOfSize:16]];
////    CGFloat textHeigth = textSize.height;
////
////    // textView 的计算高度
////    CGFloat inputHeight = textHeigth + 10;
////    // 当前textView 的contentSize的height
////    CGFloat maxInputHeight = MAX(inputHeight, (height - 10));
////    // 如果输入文本的高度 大于 textView 最大允许的contentSize 重新设置contentSize
////    if (textHeigth > (height - 10)) {
////        textHeigth = height - 10;
////    }
////    // 配置textView的contentSize
////    CGFloat contentWidth = _inputToolBar.inputTextView.width_sd;
//////    CGSize contentSize = CGSizeMake(contentWidth, maxInputHeight);
////
////    [UIView animateWithDuration:0.1 animations:^{
////        // 更新布局
////        _inputContainerView.sd_layout
////        .heightIs(height);
////        [_inputContainerView updateLayout];
////        // 重新设置contentSize
//////        _inputToolBar.inputTextView.contentSize = contentSize;
////    } completion:^(BOOL finished) {
////
////    }];
//}

///** 发送聊天信息的 */
//- (void)p_sendTextMessage:(NSString *)textMessage block:(void(^)())block {
////    if ([NSString isBlankString:textMessage]) {
////        [_inputToolBar.inputTextView resignFirstResponder];
////        return;
////    }
////
////    GGSCoachConnectList *connectInfo = [GGSCoachConnectList preSendconnectInfoWithUserId:[[GGSUserInfoManager shareInstance].user_id integerValue]
////                                                                             messageBody:textMessage
////                                                                              createTime:[[NSDate date] timeIntervalSince1970]];
////
////    // 更新相应的约束
////    switch (connectInfo.connectMessageType) {
////        case GGSConnectMessageTypeMessageText:
////        {   // 纯文本
////            self.addedRangeArray = [NSMutableArray array];
////            self.inputToolBar.inputTextView.text = @"";
////            self.inputContainerView.sd_layout.heightIs(50);
////            [self.inputContainerView updateLayout];
////
////            connectInfo.showArtString = [self p_artStringWithMessageBody:connectInfo.body];
////        }
////            break;
////        case GGSConnectMessageTypeStaticImage:
////        {   // 静态图片
////            self.addedRangeArray = [NSMutableArray array];
////            self.inputToolBar.inputTextView.text = @"";
////            self.inputContainerView.sd_layout.heightIs(50);
////            [self.inputContainerView updateLayout];
////
////            connectInfo.showArtString = [self p_staticImageArtStringWithMessageBody:connectInfo.body];
////            textMessage = [[GGSShowMessageAdapter shareAdapter] sendToServerStringWithMessageBody:textMessage staticImageArray:self.staticEmoticonArray];
////        }
////            break;
////        case GGSConnectMessageTypeGifImage:
////        {   // GIF 图片
////            connectInfo.gifImageName = [self p_gifShowImageNameWithName:textMessage meesageConnectType:GGSConnectMessageTypeGifImage];
////        }
////            break;
////
////        default:
////            break;
////    }
////    // 是否显示时间
////    BOOL isShowMessageTime = [self p_isShowSendTimeAtMessageArray:self.connectListArray];
////    connectInfo.isShowMessageSendTime = isShowMessageTime;
////    // 显示的头像
////    NSString *userIcon = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToOthers userThread:_userThread];
////    connectInfo.userProfilePic = userIcon;
////    [self.connectListArray addObject:connectInfo];
////    [self.tableView reloadData];
////
////    // 配置能显示信息 先做显示如果 发送时显示小圆圈 发送成功再做处理
////    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.connectListArray.count - 1 inSection:0];
////
////    __weak typeof(self) weakSelf = self;
////    _isEditing = NO;
////    [UIView animateWithDuration:0.2 animations:^{
////        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
////    } completion:^(BOOL finished) {
////        // 开启转圈动画
////        GGSMessageToCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
////        // 开始发送消息
////        [cell startAnimation];
////
////        [weakSelf p_sendSeverMessage:textMessage messageType:connectInfo.connectMessageType threadId:_threadId block:^{
////            // JMessage 发送消息
////            [weakSelf p_sendToJMessageWithTextMessage:textMessage messageType:connectInfo.connectMessageType];
////            // 发送完成消息置空
////            weakSelf.presendMessage = @"";
////            // 结束发送动作
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [cell endAnimation];
////                [weakSelf.tableView reloadData];
////                weakSelf.isEditing = YES;
////            });
////            if (block) {
////                block();
////            }
////        }];
////    }];
//}


///** 发送消息 */
//- (void)textView:(GGSChatInputTextView *)textView sendMessage:(NSString *)message {
//    [self p_sendTextMessage:message block:nil];
//}
//
//#pragma mark - 3DTouch
//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
//    if (self.isShowPeekUnRead) {
//        __weak typeof(self) weakSelf = self;
//        UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"标记已读" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//            // 标记为已读点击事件
//            if ([action.title isEqualToString:@"标记已读"]) {
//                // 更新未读消息数
//                [weakSelf p_updateUnReadMessageCount];
//                // 返回事件处理
//                if (weakSelf.PreViewActionBlock) {
//                    weakSelf.PreViewActionBlock();
//                }
//            }
//        }];
//        return @[action1];
//    } else {
//        return @[];
//    }
//}
//
//- (void)p_changeSubInputViewState:(BOOL)state {
//    self.inputToolBar.hidden = state;
//}


//- (GGSTopToolBar *)inputToolBar {
//    if (_inputToolBar == nil) {
//        _inputToolBar = [[GGSTopToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
//        _inputToolBar.delegate = self;
//        _inputToolBar.backgroundColor = [UIColor brownColor];
//    }
//    return _inputToolBar;
//}

//- (UIView *)inputContainerView {
//    if (_inputContainerView == nil) {
//        _inputContainerView = [[UIView alloc] init];
//        _inputContainerView.backgroundColor = kBACKGROUND_COLOR;
//    }
//    return _inputContainerView;
//}
//
//- (UIButton *)changeInputButton {
//    if (_changeInputButton == nil) {
//        _changeInputButton = [UIButton zm_buttonWithTitle:@""
//                                                     font:0
//                                          bakcgroundColor:[UIColor colorWithWhite:0.9 alpha:0.8]
//                                                    image:@""
//                                                   target:self
//                                                   action:@selector(changeInputButtonClicked:)];
//        [_changeInputButton setImage:[UIImage imageNamed:@"ggs_input_emoticon"] forState:UIControlStateNormal];
//        [_changeInputButton setImage:[UIImage imageNamed:@"ggs_input_keyboard"] forState:UIControlStateSelected];
//        _changeInputButton.selected = NO;
//    }
//    return _changeInputButton;
//}



///** 创建connectInfo 聊天信息 */
//- (GGSCoachConnectList *)p_createConnectDetailInfoWithTextMessage:(NSString *)textMessage {
//    // 配置能显示信息 先做显示如果 发送时显示小圆圈 发送成功再做处理
//    GGSCoachConnectList *connectInfo = [[GGSCoachConnectList alloc] init];
//    connectInfo.user_id = [[GGSUserInfoManager shareInstance].user_id integerValue];
//    // 用户头像数据
//    connectInfo.messageType = GGSMessageTypeSendToOthers;
//    connectInfo.userProfilePic = [self p_chatUserIconWithChatMessageType:GGSMessageTypeSendToOthers userThread:_userThread];
//    connectInfo.body = textMessage;
//    connectInfo.showArtString = [self p_artStingWithMessage:connectInfo.body];
//    connectInfo.thread_id = _userThread.thread_id;
//    connectInfo.created_at = [[NSDate date] timeIntervalSince1970];
//    connectInfo.showTime = [GGSDateStringManager showStringWithSecond:connectInfo.created_at];
//    // 是否显示最后一条信息的时间
//    BOOL isShowMessageTime = [self p_isShowSendMessageTimeWithSendMessage:connectInfo messageArray:self.connectListArray];
//    connectInfo.isShowMessageSendTime = isShowMessageTime;
//    return connectInfo;
//}
//


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

- (BOOL)p_isShowLastMessageWithMessage:(GGSCoachConnectList *)message
nextMessage:(GGSCoachConnectList *)nextMessage {
    long long messageTime = message.created_at;
    long long nextMessageTime = nextMessage.created_at;
    
    if (nextMessageTime > (messageTime + kMessageBetweenTime)) {
        return YES;
    } else {
        return NO;
    }
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
    BOOL isShowMessageTime = [self p_isShowSendTimeAtMessageArray:self.connectListArray];
    connectInfo.isShowMessageSendTime = isShowMessageTime;
    return connectInfo;
}


#endif


///** 根据用户id配置显示的用户头像数据 */
//
///**
// 根据用户id 和 聊天详情配置显示使用的用户头像
// 
// @param userId 用户id
// @param userThread 聊天详情
// @return 用户图像
// */
//- (NSString *)p_handelUserProfilePicWithUserId:(NSInteger)userId userThread:(GGSUserThread *)userThread {
//    if (userId <= 0) {
//        return @"";
//    }
//    // 当前用户id
//    NSInteger currentUserId = [[GGSUserInfoManager shareInstance].user_id integerValue];
//    if (currentUserId == userId) {
//        return userThread.currentUserPic;
//    } else if (userThread.chatId == userId) {
//        return userThread.chatPic;
//    }
//    return @"";
//}


//    JMSGMessage *message = [[[GGSJMessageContent alloc] init] createMessageConnectWithUserId:userId
//                                                                                       idTag:connect.id
//                                                                                    threadId:_threadId
//                                                                                   createdAt:[[NSDate date] timeIntervalSince1970]
//                                                                                        body:textMessage
//                                                                                 contentText:@"文本消息"
//                                                                                      chatId:_userThread.chatId];
//    // 发送文本消息
//    [JMSGMessage sendMessage:message];

//#pragma mark - Action Event
///** 根据请求的类型获取聊天消息列表信息 刷新的类型： 正常 下拉加载 上拉刷新 */
//- (void)p_loadMessageWithRefreshType:(GGSChatLoadRefreshType)refreshType blockItem:(void(^)())blockItem {
//    switch (refreshType) {
//        case GGSChatLoadRefreshTypeNone:
//        {
//            _currentPage = 1;
//            [SVProgressHUD show];
//        }
//            break;
//        case GGSChatLoadRefreshTypeHeader:
//        {
//            self.currentPage++;
//        }
//            break;
//        case GGSChatLoadRefreshTypeFooter:
//        {
//            _currentPage = 1;
//        }
//            break;
//        default:
//            break;
//    }
//    __weak typeof(self) weakSelf = self;
//    // 请求的参数
//    NSDictionary *parmater = @{@"page" : @(_currentPage),
//                               @"thread_id" : _threadId};
//    [ZMApiManager apiSendGETRequestWithApiString:@"api/v1/message" parmater:parmater success:^(id responseObject, NSError *error) {
//        // 处理请求回来的数据
//        GGSConnectDetailInfo *connectInfo = [GGSConnectDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
//        NSMutableArray *connectListArray = [NSMutableArray array];
//        [connectInfo.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            GGSCoachConnectList *connectList = [GGSCoachConnectList mj_objectWithKeyValues:obj];
//            // 配置用户头像id
//            connectList.userProfilePic = [weakSelf p_handelUserProfilePicWithUserId:connectList.user_id];
//            // 特殊消息手机端不作处理
//            if ([connectList.type isEqualToString:@"booking_preference"] == NO) {
//                [connectListArray addObject:connectList];
//            }
//        }];
//        // 排序后的数据
//        NSMutableArray *dataArray = [weakSelf sortMessageListArray:connectListArray];
//        // 消息最后时间显示处理后的数组
//        NSMutableArray *listedArray = [weakSelf p_messageShowTimeArrayWithMessageArray:dataArray];
//        // 根据请求的样式 不同处理事件
//        switch (refreshType) {
//            case GGSChatLoadRefreshTypeNone:
//            {
//                [SVProgressHUD dismiss];
//                weakSelf.connectListArray = listedArray;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView reloadData];
//                    // 滑动到底部
//                    [weakSelf p_scrollToBottomWithMessageListArray:listedArray];
//                });
//            }
//                break;
//            case GGSChatLoadRefreshTypeHeader:
//            {
//                // 加载更多数据
//                if (listedArray.count == 0) {
//                    weakSelf.currentPage--;
//                } else {
//                    if (weakSelf.connectListArray.count) {
//                        // 添加数组最后一个元素
//                        // 现有数组第一个元素比较时间
//                        GGSCoachConnectList *connect1 = [listedArray lastObject];
//                        GGSCoachConnectList *connect2 = [weakSelf.connectListArray firstObject];
//                        if (connect1.isShowMessageSendTime == YES) {
//                            if (connect2.created_at < (connect1.created_at + kMessageBetweenTime)) {
//                                connect2.isShowMessageSendTime = NO;
//                            }
//                        }
//                        NSRange range = NSMakeRange(0, (listedArray.count));
//                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//                        [weakSelf.connectListArray insertObjects:listedArray atIndexes:indexSet];
//                    } else {
//                        weakSelf.connectListArray = listedArray;
//                    }
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView.mj_header endRefreshing];
//                    [weakSelf.tableView reloadData];
//                });
//                // 滑动到顶部
//                if (listedArray.count > 0 && (_connectListArray.count - listedArray.count > 1)) {
//                    NSInteger rowCount = listedArray.count;
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount inSection:0];
//                    // 滑动到顶部 时间处理
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                    });
//                }
//            }
//                break;
//            case GGSChatLoadRefreshTypeFooter:
//            {
//                // 刷新数据
//                weakSelf.connectListArray = listedArray;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView.mj_footer endRefreshing];
//                    [weakSelf.tableView reloadData];
//                });
//            }
//                break;
//            default:
//                break;
//        }
//        // 默认发送消息
//        if (refreshType == GGSChatLoadRefreshTypeNone && [NSString isBlankString:weakSelf.presendMessage] == NO) {
//            [weakSelf.tableView reloadData];
//            [weakSelf toolBarsendTextMessage:weakSelf.presendMessage];
//        }
//        [SVProgressHUD dismiss];
//        // 回调事件
//        if (blockItem) {
//            blockItem();
//        }
//    } fail:^(id responseObject, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (blockItem) {
//            blockItem();
//        }
//    }];
//}


//#pragma mark - Notification
//- (void)jMessageLoginCurrentUser {
//    // 更新未读信息条数
//    [self p_updateUnReadMessageCount];
//    // 登录完成立即设置代理对象
//    [JMessage addDelegate:self withConversation:nil];
//    // 获取聊天信息内容
//    [self p_loadMessageWithRefreshType:GGSChatLoadRefreshTypeNone blockItem:nil];
//
////    [self p_loadMessageWithRefreshType:GGSChatLoadRefreshTypeNone blockItem:^{
////        // 添加代理
////        [JMessage addDelegate:weakSelf withConversation:nil];
////    }];
//}

///** 注册通知 */
//- (void)p_registeJMessageNotification {
//    // 添加通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForenground) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jmLogoutAction) name:kJMoutLoginAction object:nil];
//}
//
///** 注销通知 */
//- (void)p_unregisteJMessageNotification {
//    // 添加通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJMoutLoginAction object:nil];
//}

///** 进入前台 */
//- (void)enterForenground {
//    [JMessage addDelegate:self withConversation:nil];
//    // 更新未读信息条数
//    [self p_updateUnReadMessageCount];
//    // 更新消息列表
//    [self p_loadMessageWithRefreshType:GGSChatLoadRefreshTypeNone blockItem:nil];
//    [[GGSJMessageLoginManager manager] loginCurrentUser];
//}
//
///** 进入后台 */
//- (void)enterBackground {
//    [JMessage removeDelegate:self withConversation:nil];
////    [JMSGUser logout:^(id resultObject, NSError *error) {
////
////    }];
//
//    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
//        NSLog(@"%@", resultObject);
//        if (error.code != 863004) {
//            [JMSGUser logout:nil];
//        }
//    }];
//}
//
//- (void)jmLogoutAction {
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        // 添加代理
//        [JMessage addDelegate:self withConversation:nil];
//        if ([JMSGUser myInfo] == nil) {
//            [[GGSJMessageLoginManager manager] loginCurrentUser];
//        }
//    }
//}


//- (void)changeInputButtonClicked:(UIButton *)sender {
//    sender.selected = YES ^ sender.selected;
//
//    if (sender.selected) {
//        [_inputToolBar.inputTextView resignFirstResponder];
//        __weak typeof(self) weakSelf = self;
//        _isEditing = NO;
//        [UIImageView animateWithDuration:0.2 animations:^{
//            _inputContainerView.sd_layout.bottomSpaceToView(self.view, 250);
//            _emoticonView.sd_layout
//            .heightIs(250);
//            [_emoticonView updateLayout];
//        } completion:^(BOOL finished) {
//            // 滑动到底部
//            [weakSelf p_scrollToBottomWithMessageListArray:_connectListArray];
//            _isEditing = YES;
//        }];
//    } else {
//        _isEditing = NO;
//        [UIImageView animateWithDuration:0.2 animations:^{
//            _emoticonView.sd_layout
//            .heightIs(0);
//            [_emoticonView updateLayout];
//        } completion:^(BOOL finished) {
//            _isEditing = YES;
//        }];
//        [_inputToolBar.inputTextView becomeFirstResponder];
//    }
//}

