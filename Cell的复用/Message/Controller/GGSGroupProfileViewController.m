//
//  GGSGroupProfileViewController.m
//  
//
//  Created by 简而言之 on 2017/5/4.
//
//

#import "GGSGroupProfileViewController.h"
#import "GGSGroupMemberViewController.h"
#import "GGSGroupSettingViewController.h"

#import "GGSGroupPartNumberCell.h"
#import "GGSGroupInfoDetailCell.h"
#import "GGSGroupTopView.h"
#import "GGSTitleCellData.h"

@interface GGSGroupProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 显示数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GGSGroupProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;  // 设置从顶部开始显示
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
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark ----- UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGSTitleCellData *cellData = self.dataArray[indexPath.row];
    if (indexPath.row == 3) {
        GGSGroupPartNumberCell *cell = [GGSGroupPartNumberCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.data = cellData;
        cell.backgroundColor = HexColor(0xFDEADD);
        return cell;
    }
    else
    {
        GGSGroupInfoDetailCell *cell = [GGSGroupInfoDetailCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.celldata = cellData;
        cell.backgroundColor = HexColor(0xFDEADD);
        return cell;
    }
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
        GGSGroupTopView *headView = [[GGSGroupTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
        headView.selectedBlock = ^(NSInteger selected_index) {
            switch (selected_index) {
                case 1:
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                case 2:
                {
                    [self.navigationController pushViewController:[GGSGroupSettingViewController new] animated:YES];
                }
                default:
                    break;
            }
        };
        _tableView.tableHeaderView = headView;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        GGSTitleCellData *celldata0 = [[GGSTitleCellData alloc] initLeftTitle:@"游戏" isShowAccessory:NO rightTitle:@"DOTA2" destVC:nil];
        GGSTitleCellData *celldata1 = [[GGSTitleCellData alloc] initLeftTitle:@"公告" isShowAccessory:NO rightTitle:@"快了很快就会考虑将来是否给" destVC:nil];
        GGSTitleCellData *celldata2 = [[GGSTitleCellData alloc] initLeftTitle:@"教练" isShowAccessory:NO rightTitle:@"布吉岛" destVC:nil];
        GGSTitleCellData *celldata3 = [[GGSTitleCellData alloc] initLeftTitle:@"成员" isShowAccessory:NO rightTitle:nil destVC:nil];
        GGSTitleCellData *celldata4 = [[GGSTitleCellData alloc] initLeftTitle:@"创建时间" isShowAccessory:NO rightTitle:@"2016-05-08" destVC:nil];
       
        _dataArray = [NSMutableArray arrayWithArray:@[celldata0,celldata1,celldata2,celldata3,celldata4]];
    }
    return _dataArray;
}
@end
