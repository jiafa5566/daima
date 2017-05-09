//
//  GGSGroupMemberViewController.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/4.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSGroupMemberViewController.h"

#import "GGSGroupMemberViewCell.h"
#import "GGSCustomerServiceCell.h"
#import "GGSChooseMessageTypeView.h"
#import "GGSGroupMemberTopView.h"
#import "GGSChineseSortTool.h"
#import "Person.h"
@interface GGSGroupMemberViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 排序后数据源内出现的拼音首字母数组 */
@property (nonatomic, strong) NSMutableArray *indexArray;
/** 排序好的结果数组 */
@property (nonatomic, strong) NSMutableArray *letterResultArray;
/** 顶部选择 */
@property (nonatomic, strong) GGSChooseMessageTypeView *topSelectView;
/** headView */
@property (nonatomic, strong) GGSGroupMemberTopView *headView;
/** 喜欢的成员 */
@property (nonatomic, strong) NSMutableArray *preferMemberArray;
@end

@implementation GGSGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self p_setupDatasourceWithDataArray:self.dataArray];
    // 特别关注
    [self p_setupPreferMemberDatasourceWithDataArray:[NSMutableArray arrayWithArray:@[@"特别关注1",@"特别关注2"]]];
    [self setupSubViewsLayout];
    // 注册block
    [self p_setupSelectedBlock];
    // 注册cell
    static NSString *identifier = @"GGSGroupMemberViewCell";
    [_tableView registerClass:[GGSGroupMemberViewCell class] forCellReuseIdentifier:identifier];
}

/** 添加subViewLayout */
- (void)setupSubViewsLayout
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topSelectView];
    __weak typeof(self) weakSelf = self;
    [_topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(90));
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(90, 0, 0, 0));
    }];
    _tableView.tableHeaderView = self.headView;
}

#pragma mark ----- PrivationMetthod
- (void)p_setupDatasourceWithDataArray:(NSMutableArray *)dataArray
{
   NSMutableArray *newDataArray = (NSMutableArray *)[dataArray sortedArrayUsingSelector:@selector(localizedCompare:)];
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Person *p = [[Person alloc] init];
        p.name = (NSString *)obj;
        p.number = idx;
        [modelArray addObject:p];
    }];
    self.indexArray = [GGSChineseSortTool IndexWithArray:modelArray Key:@"name"];
    self.letterResultArray = [GGSChineseSortTool sortObjectArray:modelArray Key:@"name"];
}

/** 针对特别关心的列表进行操作 */
- (void)p_setupPreferMemberDatasourceWithDataArray:(NSMutableArray *)dataArray
{
    NSMutableArray *newDataArray = (NSMutableArray *)[dataArray sortedArrayUsingSelector:@selector(localizedCompare:)];
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Person *p = [[Person alloc] init];
        p.name = (NSString *)obj;
        p.number = idx;
        [modelArray addObject:p];
    }];
    self.preferMemberArray = modelArray;
}

#pragma mark ----- UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count] + 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return [self.preferMemberArray count];
        }
            break;
        default:
        {
           return [[self.letterResultArray objectAtIndex:section - 2] count];
        }
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self p_cellWithTableView:tableView indexPath:indexPath];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self p_tableViewSetupHeadViewInSectionWith:section];
}

/** 索引 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

/** 索引点击事件 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in self.indexArray)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}

#pragma mark ----- PrivationMethod
- (NSString *)p_transform:(NSString *)chinese   // 将汉字转化为首字母
{
    // 将汉字转化为拼音
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    // 大写字母
    return [pinyin uppercaseString];
}

/** 根据分区返回headView */
- (UIView *)p_tableViewSetupHeadViewInSectionWith:(NSInteger )indexpath_section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 13)];
    headView.backgroundColor = HexColor(0xf1f3f5);
    switch (indexpath_section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            UIImageView *signImageView = [[UIImageView alloc] init];
            signImageView.image = [UIImage imageNamed:@"ggs_like"];
            [headView addSubview:signImageView];
            [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headView.mas_left).offset(kToLeftViewMarigin);
                make.top.equalTo(headView.mas_top).offset(1.5);
                make.bottom.equalTo(headView.mas_bottom).offset(-1.5);
                make.width.equalTo(signImageView.mas_height);
            }];
        }
            break;
        default:
        {
            UILabel *headLabel = [[UILabel alloc] init];
            [headView addSubview:headLabel];
            [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headView.mas_left).offset(kToLeftViewMarigin);
                make.top.bottom.equalTo(headView);
            }];
            headLabel.font = [UIFont systemFontOfSize:12];
            headLabel.textColor = HexColor(0xcccccc);
            NSString *keyString = self.indexArray[indexpath_section - 2];
            headLabel.text = keyString;
        }
            break;
    }
    return headView;
}

/** 根据不同的section返回不用的UITableViewCell */
- (UITableViewCell *)p_cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            GGSCustomerServiceCell *cell = [GGSCustomerServiceCell cellWithTableView:tableView];
            return cell;
        }
            break;
        case 1:
        {
            GGSGroupMemberViewCell *cell = [GGSGroupMemberViewCell cellWithTableView:tableView indexPath:indexPath];
            Person *p = [self.preferMemberArray objectAtIndex:indexPath.row];
            cell.data = p.name;
            return cell;
        }
            break;
        default:
        {
            GGSGroupMemberViewCell *cell = [GGSGroupMemberViewCell cellWithTableView:tableView indexPath:indexPath];
            Person *p = [[self.letterResultArray objectAtIndex:indexPath.section - 2] objectAtIndex:indexPath.row];
            cell.data = p.name;
            return cell;
        }
            break;
    }
    return nil;
}

/** blcok回调 */
- (void)p_setupSelectedBlock
{
    _topSelectView.didSelectBlock = ^(NSInteger indexPath_row) {
        switch (indexPath_row) {
            case 0:
            {  // 最新
                
            }
                break;
            case 1:
            {  // 联系人
                
            }
                break;
            default:
            { // 群
                
            }
                break;
        }
    };
    _headView.selectedBlock = ^(NSInteger indexNumber) {
        switch (indexNumber) {
            case 0:
            {  // 教练
                
            }
                break;
            case 1:
            {  // 狗友
                
            }
                break;
            case 2:
            {  // 关注
                
            }
                break;
            default:
            {  // 黑名单
                
            }
                break;
        }
    };
}

#pragma mark ----- Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionIndexColor = [UIColor redColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (GGSChooseMessageTypeView *)topSelectView
{
    if (_topSelectView == nil) {
        _topSelectView = [[GGSChooseMessageTypeView alloc] initWithFrame:CGRectZero];
        _topSelectView.backgroundColor = [UIColor whiteColor];
    }
    return _topSelectView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        _dataArray = [NSMutableArray arrayWithArray:@[ @"李白",@"张三",
                                                       @"重庆",@"重量",
                                                       @"调节",@"调用",
                                                       @"小白",@"小明",@"晓张",@"晓张张",@"千珏",
                                                       @"Z黄家驹", @"鼠标",@"hello",@"多美丽",@"肯德基",@"##",@"强盛",@"米建刚",@"徐弯弯",@"是的",@"@少荃",@"这是@测试"]];
    }
    return _dataArray;
}

- (NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)letterResultArray
{
    if (_letterResultArray == nil) {
        _letterResultArray = [NSMutableArray array];
    }
    return _letterResultArray;
}

- (GGSGroupMemberTopView *)headView
{
    if (_headView == nil) {
        _headView = [[GGSGroupMemberTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)
                                                     sourceArray:[NSMutableArray arrayWithArray:@[@"教练",@"狗友",@"关注",@"黑名单"]]];
        _headView.backgroundColor = HexColor(0xf1f3f5);
    }
    return _headView;
}

- (NSMutableArray *)preferMemberArray
{
    if (_preferMemberArray == nil) {
        _preferMemberArray = [NSMutableArray array];
    }
    return _preferMemberArray;
}
@end
