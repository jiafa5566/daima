//
//  GGSGroupSettingViewController.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/6.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupSettingViewController.h"

#import "GGSGroupInfoSettingCell.h"
#import "GGSBaseGroupInfoCell.h"

@interface GGSGroupSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *dataArray;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 标题栏 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 退群按钮 */
@property (nonatomic, strong) UIButton *exitGroupButton;
@end

@implementation GGSGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets= NO;
    [self setupSubViewsLayout];
    // Do any additional setup after loading the view.
}

/** 添加SubViewsLayout */
- (void)setupSubViewsLayout
{
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ----- lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark ----- UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        GGSGroupInfoSettingCell *cell = [GGSGroupInfoSettingCell cellWithTableView:tableView];
        cell.backgroundColor = HexColor(0xFDEADD);
        cell.celldata = sectionArray[indexPath.row];
        return cell;
    } else {
        GGSBaseGroupInfoCell *cell = [GGSBaseGroupInfoCell cellWithTableView:tableView];
        cell.celldata= sectionArray[indexPath.row];
        cell.backgroundColor = HexColor(0xFDEADD);
        return cell;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self p_setupTableViewTopSectionView];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footView = [[UIView alloc] init];
        [footView addSubview:self.exitGroupButton];
        [_exitGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footView.mas_top).offset(20);
            make.left.equalTo(footView.mas_left).offset(15);
            make.right.equalTo(footView.mas_right).offset(-15);
            make.bottom.equalTo(footView.mas_bottom);
        }];
        return footView;
    }
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 60;
    }
    return 0;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 75;
    }
    return 30;
}

#pragma mark ----- PrivationMethod
- (UIView *)p_setupTableViewTopSectionView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    topView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:self.backButton];
    [topView addSubview:self.titleLabel];
    __weak typeof(self) weakSelf = self;
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(15);
        make.top.equalTo(topView.mas_top).offset(30);
        make.bottom.equalTo(topView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.backButton.mas_height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backButton.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    return topView;
}

- (void)backBUttonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)exitBUttonAction:(UIButton *)sender
{
    // 退出该群
    
}

#pragma mark ----- Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray<NSArray *> *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        GGSTitleCellData *celldata0 = [[GGSTitleCellData alloc] initLeftTitle:@"消息免打扰" isShowAccessory:NO rightTitle:@"nil" destVC:nil];
        GGSTitleCellData *celldata1 = [[GGSTitleCellData alloc] initLeftTitle:@"置顶聊天" isShowAccessory:NO rightTitle:@"nil" destVC:nil];
        GGSTitleCellData *celldata2 = [[GGSTitleCellData alloc] initLeftTitle:@"创建多人会话" isShowAccessory:NO rightTitle:@"nil" destVC:nil];
        GGSTitleCellData *celldata3 = [[GGSTitleCellData alloc] initLeftTitle:@"查看聊天记录" isShowAccessory:NO rightTitle:nil destVC:nil];
        GGSTitleCellData *celldata4 = [[GGSTitleCellData alloc] initLeftTitle:@"清除聊天记录" isShowAccessory:NO rightTitle:@"nil" destVC:nil];
        GGSTitleCellData *celldata5 = [[GGSTitleCellData alloc] initLeftTitle:@"举报" isShowAccessory:NO rightTitle:@"nil" destVC:nil];
        _dataArray = [NSMutableArray arrayWithArray:@[@[celldata0,celldata1],@[celldata2,celldata3,celldata4,celldata5]]];
    }
    return _dataArray;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [UIButton zm_buttonWithFont:16 title:@"返回" titleColor:[UIColor blackColor] backgroundColor:HexColor(0x86CCC9) target:self action:@selector(backBUttonAction:)];
        _backButton.layer.cornerRadius = 17.5;
        _backButton.layer.masksToBounds = YES;
    }
    return _backButton;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"群设置";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIButton *)exitGroupButton
{
    if (_exitGroupButton == nil) {
        _exitGroupButton = [UIButton zm_buttonWithFont:20 title:@"退出该群" titleColor:[UIColor blackColor] backgroundColor:HexColor(0xF4B383) target:self action:@selector(exitBUttonAction:)];
    }
    return _exitGroupButton;
}
@end
