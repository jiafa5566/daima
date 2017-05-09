//
//  GGSConnectViewController.m
//  GGSPlantform
//
//  Created by zhangmin on 16/5/31.
//  Copyright © 2016年 zhangmin. All rights reserved.
//

#import "GGSConnectViewController.h"
#import "GGSConnectDetailViewController.h"
#import "ZHMTabBarController.h"
#import "GGSLoginViewController.h"
#import "ZHMNavigationController.h"
#import "GGSTestPageViewController.h"
#import "GGSDocumentListViewController.h"
#import "GGSUniqueHeroesViewController.h"
#import "GGSPlaySoonStarTimeViewController.h"
#import "GGSPlaySoonScoreViewController.h"
#import "GGSPlaySoonViewController.h"

#import "GGSConnectListCell.h"
#import "GGSRefreshHeaderView.h"
#import "GGSCommonAlertView.h"
#import "GGSBaseNormalTableViewHeader.h"

#import "GGSUserThread.h"
#import "GGSParticipants.h"
#import "GGSUserInfoManager.h"
#import "GGSCoachConnectList.h"
#import <MJExtension/MJExtension.h>
#import "GGSGGSLastMessage.h"
#import "GGSBadgeManager.h"
#import "GGSShowRedPackageView.h"
#import "ZMApiManager.h"
#import "GGSPTPusherManager.h"
#import "GGSPTPusherData.h"
#import "GGSRefreshType.h"
#import "GGSThreadSubItem.h"
#import <JMessage/JMessage.h>
//#import "JPUSHService.h"
#import "GGSJMessageLogin.h"
#import "GGSJMessageUser.h"
#import "GGSJMessagePayload.h"
#import "GGSChatJMessage.h"
#import "GGSJMessageLoginManager.h"
#import "GGSJMessageContent.h"
#import "GGSDataIdResponse.h"
#import "GGSDateStringManager.h"
#import "GGSBaseThread.h"
#import "GGSJMessageContent.h"

@interface GGSConnectViewController ()
<JMessageDelegate,
JMSGConversationDelegate,
// UIViewControllerPreviewingDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *connectListArray;

@property (nonatomic, strong) UITableView *tableView;
/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation GGSConnectViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBACKGROUND_COLOR;
    self.navigationItem.title = @"聊天";
    // 添加控件
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    // 下拉刷新
    [self p_setupHeaderFooterRefresh];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ceshi"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(testAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ceshi"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(testAction1:)];
    
    // 设置代理
    [JMessage addDelegate:self withConversation:nil];
    // 设置用户交互
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    // 开始刷新数据
    self.currentPage = 1;
    [SVProgressHUD show];
    [self p_reloadConnectListArrayWithCurrentPage:self.currentPage block:^(NSMutableArray *messageArray, NSInteger unReadCount) {
        weakSelf.connectListArray = messageArray;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 检查用户id是否为空 为空跳转登录界面
    NSString *userId = [GGSUserInfoManager shareInstance].user_id;
    BOOL isUserIdNil = [NSString isBlankString:userId];
    if (isUserIdNil) {
        // 跳转到登录界面
        __weak typeof(self) weakSelf = self;
        [self p_pushToLoginViewControllerWithComfirmBlock:^{
            [weakSelf viewWillAppear:YES];
        } cancelBlock:^{
            // 设置默认选中教练列表
            if ([weakSelf.tabBarController isKindOfClass:[ZHMTabBarController class]]) {
                ZHMTabBarController *tabbarVC = (ZHMTabBarController *)weakSelf.tabBarController;
                [tabbarVC selectTabBarItemWithType:ZHMTabBarControllerTypeHomePage];
            }
        }];
        return;
    }
    
    // 更改未读消息数
    __weak typeof(self) weakSelf = self;
    [self p_getUserThreadUnReadMessageBlock:^(NSInteger unReadCount) {
        [weakSelf p_changeTabBarShowUnReadMessageCount:unReadCount];
    }];
    // 更新数据
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([NSString isBlankString:[GGSUserInfoManager shareInstance].user_id] == NO) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            UIUserNotificationSettings *settings = [UIApplication sharedApplication].currentUserNotificationSettings;
            if (settings.types == UIUserNotificationTypeNone) {
                // 教练的approved 为1
                if ([GGSUserInfoManager shareInstance].isCoach) {
                    [SVProgressHUD dismiss];
                    [self p_notificationNotOpenAlertShow];
                    NSLog(@"教练通知未开启");
                } else {
                    NSLog(@"学员通知未开启");
                }
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 结束刷新操作
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGSConnectListCell *cell = [GGSConnectListCell cellWithTableView:tableView indexPath:indexPath];
    if (indexPath.row < self.connectListArray.count) {
        cell.userConnectInfo = self.connectListArray[indexPath.row];
//        // iOS9 情况适配问题
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
//            // 注册3DTouch
//            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//                NSLog(@"3DTouch 可用");
//                // 给cell 注册3DTouch 的Peek预览 和 Pop功能
//                [self registerForPreviewingWithDelegate:self sourceView:cell];
//            } else {
//                NSLog(@"3DTouch 不可用");
//            }
//        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGSUserThread *userThread = self.connectListArray[indexPath.row];
    // 手动更新未读消息数
    userThread.unread_message_count = 0;
    // 跳转聊天界面
    GGSConnectDetailViewController *connectDetailVC = [[GGSConnectDetailViewController alloc] initWithThreadId:userThread.thread_id];
    [self.navigationController pushViewController:connectDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_connectListArray.count == 0) {
        return 50;
    } else {
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_connectListArray.count == 0) {
        GGSBaseNormalTableViewHeader *header = [GGSBaseNormalTableViewHeader headerWithTableView:tableView];
        header.showTitle = @"下单后就能立即获得跟教练的私聊权限哦";
        __weak typeof(self) weakSelf = self;
        [header setClickBlock:^{
            // 返回教练列表
            if ([weakSelf.tabBarController isKindOfClass:[ZHMTabBarController class]]) {
                ZHMTabBarController *tabBarVC = (ZHMTabBarController *)self.tabBarController;
                [tabBarVC selectTabBarItemWithType:ZHMTabBarControllerTypeCoach];
            }
        }];
        return header;
    } else {
        return [UIView new];
    }
}

#pragma mark - ActionEvent
- (void)testAction:(UIBarButtonItem *)item {
//    GGSDocumentListViewController *uniqueHerosVC = [[GGSDocumentListViewController alloc] init];
    GGSUniqueHeroesViewController *uniqueHerosVC = [[GGSUniqueHeroesViewController alloc] init];
    [self.navigationController pushViewController:uniqueHerosVC animated:YES];
//    GGSPlaySoonScoreViewController *uniqueHerosVC = [[GGSPlaySoonScoreViewController alloc] init];
//    [self.navigationController pushViewController:uniqueHerosVC animated:YES];
}

- (void)testAction1:(UIBarButtonItem *)item {
    GGSTestPageViewController *uniqueHerosVC = [[GGSTestPageViewController alloc] init];
    [self.navigationController pushViewController:uniqueHerosVC animated:YES];
}


#pragma mark - PrivateMethod
/** 跳转到登录界面和返回事件处理 */
- (void)p_pushToLoginViewControllerWithComfirmBlock:(void(^)())comfirmBlock
                                        cancelBlock:(void(^)())cancelBlock {
    GGSLoginViewController *loginVC = [[GGSLoginViewController alloc] initWithDismissType:GGSLoginControllerDismissTypeWindow completedBlock:comfirmBlock cancelBlock:cancelBlock];
    // 跳转登录界面
    ZHMNavigationController *navigationVC = [[ZHMNavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navigationVC animated:NO completion:nil];
}

/** 更新未读信息条数 */
- (void)p_updateUnReadMessageCountWithThreadId:(NSInteger)threadId {
    if (threadId <= 0) {
        return;
    }
    NSDictionary *paramter = @{@"thread_id" : @(threadId)};
    [[NetManager shareManger] POST:@"api/v1/thread" parameters:paramter progress:nil success:nil failure:nil];
}

/** 设置下拉刷新 */
- (void)p_setupHeaderFooterRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [GGSRefreshHeaderView headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [SVProgressHUD show];
        [self p_reloadConnectListArrayWithCurrentPage:weakSelf.currentPage block:^(NSMutableArray *messageArray, NSInteger unReadCount) {
            weakSelf.connectListArray = messageArray;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
        }];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [self p_reloadConnectListArrayWithCurrentPage:weakSelf.currentPage block:^(NSMutableArray *messageArray, NSInteger unReadCount) {
            if (messageArray.count == 0) {
                weakSelf.currentPage--;
            } else {
                [weakSelf.connectListArray addObjectsFromArray:messageArray];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
    footer.stateLabel.hidden = YES;
//    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
}

/** 获取未读消息数 */
- (void)p_getUserThreadUnReadMessageBlock:(void(^)(NSInteger unReadCount))block {
    [ZMApiManager apiSendGETRequestWithApiString:@"api/v1/getUnreadMessageCount" parmater:nil success:^(id responseObject, NSError *error) {
        GGSDataIdResponse *response = [GGSDataIdResponse mj_objectWithKeyValues:responseObject];
        NSDictionary *dictionary = [response.data mj_JSONObject];
        
        NSInteger unReadCount = 0;
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            unReadCount = [dictionary[@"unread_message_count"] integerValue];
        }
        if (block) {
            block(unReadCount);
        }
    } fail:^(id responseObject, NSError *error) {
        if (block) {
            block(0);
        }
    }];
}

/**
 根据当前页 获取消息列表
 
 @param currentPage 当前页码
 @param block 返回聊天详情
 */
- (void)p_reloadConnectListArrayWithCurrentPage:(NSInteger)currentPage
                                          block:(void(^)(NSMutableArray *messageArray, NSInteger unReadCount))block {
    NSDictionary *parmater = @{@"page" : @(currentPage)};
    [ZMApiManager apiSendGETRequestWithApiString:@"api/v1/thread" parmater:parmater success:^(id responseObject, NSError *error) {
        GGSDataIdResponse *response = [GGSDataIdResponse mj_objectWithKeyValues:responseObject];
        GGSBaseThread *baseThread = [GGSBaseThread mj_objectWithKeyValues:response.data];
        
        __block NSInteger unReadMessageCount = 0;
        NSMutableArray *itemArray = [NSMutableArray array];
        [baseThread.threads enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGSUserThread *userThread = [GGSUserThread mj_objectWithKeyValues:obj];
            // 处理显示数据
            [userThread handelShowItem];
            BOOL isThreadAvailable = [userThread isCurrentThreadDataAvaliable];
            if (isThreadAvailable) {
                unReadMessageCount += userThread.unread_message_count;
                [itemArray addObject:userThread];
            } else {
                return;
            }
        }];
        
        if (block) {
            block(itemArray, unReadMessageCount);
        }
    } fail:^(id responseObject, NSError *error) {
        if (block) {
            block([NSMutableArray array], 0);
        }
    }];
}

#pragma mark - JMessageDelegate
/** 更新未读消息数目 */
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    JMSGAbstractContent *jmContent = message.content;
    GGSJMessageContent *content = [GGSJMessageContent mj_objectWithKeyValues:[jmContent toJsonString]];
    GGSGGSLastMessage *lastMessage = [[GGSGGSLastMessage alloc] initWithMessageContent:content];
    __block NSInteger theSameIndex = 0;
    __block BOOL isContain = NO;
    [self.connectListArray enumerateObjectsUsingBlock:^(GGSUserThread * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.thread_id == content.thread_id) {
            obj.last_message_time = content.created_at;
            [obj handelShowItem];
            obj.last_message = lastMessage;
            theSameIndex = idx;
            isContain = YES;
            *stop = YES;
        }
    }];
    if (isContain) {
        // 当包含的时候处理数据
        if (theSameIndex != 0) {
            // 更换量元素的位置
            [self.connectListArray exchangeObjectAtIndex:0 withObjectAtIndex:theSameIndex];
        }
        [self.tableView reloadData];
    } else {
        // 当不包含的时候直接请求
        [self p_requestNewAddedThreadId:content.thread_id Block:^(GGSUserThread *newThread, BOOL state) {
            if (state == NO) {
                [self.connectListArray insertObject:newThread atIndex:0];
                [self.tableView reloadData];
            }
        }];
    }
}

/** 接收到的消息的处理 */
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    MJRefreshState headerState = self.tableView.mj_header.state;
    MJRefreshState footerState = self.tableView.mj_footer.state;
    BOOL isStateAvailable = (headerState == MJRefreshStateIdle || headerState == MJRefreshStateNoMoreData) || (footerState == MJRefreshStateIdle || footerState == MJRefreshStateNoMoreData);
    // 当当前数据刷新状态为空闲时
    if (isStateAvailable) {
        NSLog(@"%s --- 接收到消息 -- %@", __func__, message);
        // 消息内容
        GGSJMessageContent *messageConent = [GGSJMessageContent messageContentWithMessage:message];
        // 判断收到的消息的位置
        __block NSInteger receivedMessageIndex = 0;
        __block BOOL isContain = NO;
        __block BOOL isTheSameId = NO;
        [self.connectListArray enumerateObjectsUsingBlock:^(GGSUserThread *obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.thread_id == messageConent.thread_id) {
                // 当前发送的消息id 和 最新收的消息id 相同
                if (obj1.last_message.id == messageConent.id) {
                    isTheSameId = YES;
                }
                receivedMessageIndex = idx1;
                isContain = YES;
                *stop1 = YES;
            }
        }];
        // 如果最新刷新的消息的id 与 推送的消息id 相同则不做处理
        if (isTheSameId) {
            return;
        }
        // 最新的消息的内容
        GGSGGSLastMessage *lastMessage = [[GGSGGSLastMessage alloc] initWithMessageContent:messageConent];
        // 消息列表不包含最新的消息
        if (isContain == NO) {
            // 根据最新的消息获取消息的内容
            [self p_requestNewAddedThreadId:lastMessage.thread_id Block:^(GGSUserThread *newThread, BOOL state) {
                if (state == NO) {
                    [self.connectListArray insertObject:newThread atIndex:0];
                    [self.tableView reloadData];
                }
            }];
        } else {
            GGSUserThread *userThread = self.connectListArray[receivedMessageIndex];
            userThread.last_message_time = messageConent.created_at;
            userThread.last_message = lastMessage;
            userThread.unread_message_count++;
            [userThread handelShowItem];
            // 更新对应消息的位置
            if (receivedMessageIndex != 0) {
                [self.connectListArray exchangeObjectAtIndex:receivedMessageIndex withObjectAtIndex:0];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:receivedMessageIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

/**
 更新显示的未读消息数

 @return 未读消息数目
 */
- (void)p_changeTabBarShowUnReadMessageCount:(NSInteger)count {
    // 判断当前的窗口是否统一
    if ([self.tabBarController isKindOfClass:[ZHMTabBarController class]]) {
        ZHMTabBarController *tabBarVC = (ZHMTabBarController *)self.tabBarController;
        // 聊天显示的未读消息数
        [GGSBadgeManager shareBadge].chatBadge = count;
        [tabBarVC changeUnreadMessageCount:count];
        // 更新未读消息数
        NSInteger badgeCount = [GGSBadgeManager totalBadgeNumber];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
        // 更新badge数
        [JPUSHService setBadge:badgeCount];
    }
}

/** 根据当前的threadId 获取thread的方法 */
- (void)p_requestNewAddedThreadId:(NSInteger)threadId Block:(void(^)(GGSUserThread *threadId, BOOL state))block {
    if (threadId <= 0) {
        return;
    }
    NSString *threadRequest = [NSString stringWithFormat:@"api/v1/thread/%ld", threadId];
    // 根据threaId 获取详情
    [ZMApiManager apiSendGETRequestWithApiString:threadRequest parmater:nil success:^(id responseObject, NSError *error) {
        GGSUserThread *thread = [GGSUserThread mj_objectWithKeyValues:responseObject[@"data"]];
        BOOL requestState = [responseObject[@"error"] boolValue];
        // 处理显示数据
        [thread handelShowItem];
        BOOL isThreadAvailable = [thread isCurrentThreadDataAvaliable];
        
        if (isThreadAvailable) {
            if (block) {
                block(thread, requestState);
            }
        } else {
            if (block) {
                block(nil, NO);
            }
        }
    } fail:^(id responseObject, NSError *error) {
        if (block) {
            block(nil, YES);
        }
    }];
}

/** 显示通知未打开的弹窗 */
- (void)p_notificationNotOpenAlertShow {
    
    GGSCommonAlertView *alertView = [[GGSCommonAlertView alloc] initWithTitle:@"通知提示"
                                                                  showMessage:@"你的推送功能尚未开启, 不能及时看到好友发来的信息和订单消息, 请前往 设置 -> 通知 开启GOGOSU消息推送"];
    [alertView addAction:[GGSAlertAction actionWithShowMessage:@"取消"
                                                          type:GGSAlertActionTypeDefault
                                                   handelBlock:nil]];
    [alertView addAction:[GGSAlertAction actionWithShowMessage:@"去开启"
                                                          type:GGSAlertActionTypeCommon
                                                   handelBlock:^{
                                                       // 打开通知设置
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                   }]];
    [alertView show];
}

#pragma mark - Getter
- (NSMutableArray *)connectListArray {
    if (_connectListArray == nil) {
        _connectListArray = [NSMutableArray array];
    }
    return _connectListArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = kBACKGROUND_COLOR;
        _tableView.separatorColor = RGBCOLOR(239, 239, 239);
    }
    return _tableView;
}

- (NSInteger)currentPage {
    if (_currentPage <= 1) {
        _currentPage = 1;
    }
    return _currentPage;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#if 0

#pragma mark - 3DTouch USE

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    // 获取当前点击位置的IndexPath
    NSIndexPath *locationIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    // 获取聊天信息
    GGSUserThread *userThread = self.connectListArray[locationIndexPath.row];
    GGSConnectDetailViewController *connectDetailVC = [[GGSConnectDetailViewController alloc] initWithThreadId:userThread.thread_id];
    // 是否显示未读信息
    connectDetailVC.isShowPeekUnRead = (userThread.unread_message_count > 0);
    
    [connectDetailVC p_changeSubInputViewState:YES];
    connectDetailVC.preferredContentSize = CGSizeMake(0, 500);
    // peek点击事件处理
    __weak typeof(self) weakSelf = self;
    [connectDetailVC setPreViewActionBlock:^{
        [weakSelf p_reloadConnectListData];
    }];
    return connectDetailVC;
}

/** pop 用力点击进入 */
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    if ([viewControllerToCommit isKindOfClass:[GGSConnectDetailViewController class]]) {
        GGSConnectDetailViewController *connectDetailVC = (GGSConnectDetailViewController *)viewControllerToCommit;
        [connectDetailVC p_changeSubInputViewState:NO];
        [self showViewController:connectDetailVC sender:self];
    }
}

#endif
