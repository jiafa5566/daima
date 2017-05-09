//
//  GGSViewController.m
//  GGSPlantform
//
//  Created by 简而言之 on 2017/5/9.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSViewController.h"

@interface GGSViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GGSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    　　static NSString *CellIdentifier = @"cell1";
//    
//    　　UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    　　if (cell == nil) {
//        
//        　　cell = ［UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        　　UILabel *labelTest = ［UILabel alloc]init];
//        
//        　　[labelTest setFrame:CGRectMake(2, 2, 80, 40)];
//        
//        　　[labelTest setBackgroundColor:[UIColor clearColor］;
//                                         
//                                         　　[labelTest setTag:1];
//                                         
//                                         　　［cell contentView]addSubview:labelTest];
//        
//        　　}
//    
//    　　UILabel *label1 = (UILabel*)[cell viewWithTag:1];
//    
//    　　[label1 setText:[self.tests objectAtIndex:indexPath.row］;
//                       
//                       　　return cell;
//                       
//                       　　}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
//    
//    　　static NSString *CellIdentifier = @"cell1";
//    
//    　　UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    　　if (cell == nil) {
//        
//        　　cell = ［UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        　　}
//    
//    　　UILabel *labelTest = ［UILabel alloc]init];
//    
//    　　[labelTest setFrame:CGRectMake(2, 2, 80, 40)];
//    
//    　　[labelTest setBackgroundColor:[UIColor clearColor］; //之所以这里背景设为透明，就是为了后面让大家看到cell上叠加的label。
//                                     
//                                     　　[labelTest setTag:1];
//                                     
//                                     　　［cell contentView]addSubview:labelTest];
//    
//    　　[labelTest setText:[self.tests objectAtIndex:indexPath.row］;
//                          
//                          　　return cell;
//                          
//                          　　}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
