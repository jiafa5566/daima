//
//  GGSMessageViewController.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/3.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSMessageViewController.h"
#import "GGSGroupTypeView.h"

#import "GGSChatMessageCell.h"
#import "GGSChooseMessageTypeView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface GGSMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GGSChooseMessageTypeView *topSelectView;
@property (nonatomic, strong) GGSGroupTypeView *sectionView;
@end

@implementation GGSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViewsLayout];
    // 点击回调
    [self p_setupTopViewSelectBlock];
}

- (void)setupSubViewsLayout
{
    [self.view addSubview:self.topSelectView];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [_topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(100));
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(100, 0, 0, 0));
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGSChatMessageCell *cell = [GGSChatMessageCell cellWithTableView:tableView];
    cell.data = @"数据";
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGSGroupTypeView *headView = [[GGSGroupTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 35)
                                                                   array:[NSMutableArray arrayWithArray:@[@"群基地",@"讨论组"]]];
    headView.backgroundColor = HexColor(0xF1F4F8);
    _sectionView = headView;
    return _sectionView;

}

#pragma mark ----- PrivationMethod
- (void)p_setupTopViewSelectBlock
{
    _topSelectView.didSelectBlock = ^(NSInteger indexPath_row) {
        switch (indexPath_row) {
            case 0:
            {  // 全部
                NSLog(@"0");
            }
                break;
            case 1:
            {  // 通知
                NSLog(@"1");
            }
                break;
            case 2:
            {  // 群
                NSLog(@"2");
            }
            default:
                break;
        }
  
    };
    
    _sectionView.ItemSlectedBlock = ^(NSInteger indexPath_row) {
        switch (indexPath_row) {
            case 0:
            {  // 全部
                NSLog(@"群基地");
            }
                break;
            case 1:
            {  // 通知
                NSLog(@"讨论组");
            }
            default:
                break;
        }

    };
}


#pragma mark ----- Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = kBACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (GGSChooseMessageTypeView *)topSelectView
{
    if (_topSelectView == nil) {
        _topSelectView = [[GGSChooseMessageTypeView alloc] initWithFrame:CGRectZero];
        _topSelectView.backgroundColor = kBACKGROUND_COLOR;
    }
    return _topSelectView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
