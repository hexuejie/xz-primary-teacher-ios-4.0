//
//  GFMallChooseAreaViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallChooseAreaViewController.h"
#import "GFMallAddressCitysListModel.h"
@interface GFMallChooseAreaViewController ()
@property(nonatomic, strong) GFMallAddressCitysListModel * listModel;
@end

@implementation GFMallChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择城市";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = project_line_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    [self requestListTeacherAddressCitys];
}

- (void)requestListTeacherAddressCitys{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr: NetRequestType_ListTeacherAddressCitys] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherAddressCitys];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_ListTeacherAddressCitys) {
            strongSelf.listModel = [[GFMallAddressCitysListModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateTableView];
        }
    }];
}

- (void)registerCell{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellIdentifier"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterViewIdentifier"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (self.listModel) {
        section = [self.listModel.citys count];
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GFMallAddressProvinceModel *provinceModel = self.listModel.citys[section];
    NSInteger row = [provinceModel.city count];
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    cell.backgroundColor = project_background_gray;
    
    GFMallAddressProvinceModel *provinceModel = self.listModel.citys[indexPath.section];
    GFMallAddressCityModel * cityModel  = provinceModel.city[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",cityModel.cityName];
    cell.textLabel.font = fontSize_14;
    cell.textLabel.textColor = UIColorFromRGB(0x6b6b6b);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   UITableViewHeaderFooterView * headerView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterViewIdentifier"];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [headerView viewWithTag:333333];
     GFMallAddressProvinceModel *provinceModel = self.listModel.citys[section];
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-0, 44)];
        label.textColor = UIColorFromRGB(0x6b6b6b);
        label.font = fontSize_14;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 333333;
        [headerView addSubview:label];
    }
    label.text = provinceModel.provinceName;
    
    
    UIView * lineV = [headerView viewWithTag:4444444];
 
    if (!label) {
        lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        lineV.backgroundColor = project_line_gray;
        lineV.tag = 4444444;
        [headerView addSubview:label];
    }
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self chooseAreaAtIndexPath:indexPath];
}

- (void)chooseAreaAtIndexPath:(NSIndexPath *)indexPath{
    NSString * area = @"";
    NSString * province = @"";
    NSString * city = @"";
     GFMallAddressProvinceModel *provinceModel = self.listModel.citys[indexPath.section];
      GFMallAddressCityModel * cityModel  = provinceModel.city[indexPath.row];
    
    area = [NSString stringWithFormat:@"%@%@",provinceModel.provinceName,cityModel.cityName];
    province = provinceModel.province;
    city = cityModel.city;
    if (self.chooseAreaBlock) {
        self.chooseAreaBlock(area, province, city);
    }
    [self backViewController];
}
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
