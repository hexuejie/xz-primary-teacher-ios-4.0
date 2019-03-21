//
//  ProvinceListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ProvinceListViewController.h"
#import "QueryCitysModel.h"
#import "CityListViewController.h"

NSString * const  ProvinceListCellIdentifier = @"ProvinceListCellIdentifier";
@interface ProvinceListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) QueryCitysModel * citysModel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) ProvinceListViewFromType fromType;
@end

@implementation ProvinceListViewController

- (instancetype)initWithType:(ProvinceListViewFromType) type{

    if (self == [super init]) {
        self.fromType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"选择省份"];
    [self.view addSubview:self.tableView];
    [self requesetQueryProvince];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class]  forCellReuseIdentifier:ProvinceListCellIdentifier];
        
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---
//
- (void)requesetQueryProvince{
    
  
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryProvince] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryProvince];
    
}

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryProvince) {
            strongSelf.citysModel = [[QueryCitysModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf.tableView reloadData];
        }
    }];
}
#pragma mark -----



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return  [self.citysModel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:ProvinceListCellIdentifier] ;
    CityModel * city =  self.citysModel.items[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x6b6b6b);
    cell.textLabel.text = city.name;
    cell.textLabel.font = fontSize_15;
    return cell;
    
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.fromType == ProvinceListViewFromType_School) {
        [self gotoCityListVC:self.citysModel.items[indexPath.row]];
    }else if (self.fromType == ProvinceListViewFromType_City){
        CityModel * model = self.citysModel.items[indexPath.row];
        
        if (self.selectedProvinceBlock) {
            self.selectedProvinceBlock(model.name, model.id);
        }
        [self backViewController ];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return FITSCALE(50);
  
}


- (void)gotoCityListVC:(CityModel *)cityModel{

    CityListViewController * cityListVC = [[CityListViewController alloc]initWithType:CityListViewFromType_Province withCityName:nil withProvinceName:cityModel.name withProvinceID:cityModel.id];
    [self pushViewController:cityListVC];
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
