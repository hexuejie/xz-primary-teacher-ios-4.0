//
//  CityListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CityListViewController.h"
#import "ProvinceListViewController.h"
#import "QueryCitysModel.h"
#import "CityListProvinceCell.h"
#import "CityListContentLoactionCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>

NSString * const CityListCellIdentifier = @"CityListCellIdentifier";
NSString * const CityListProvinceCellIdentifier = @"CityListProvinceCellIdentifier";
NSString * const CityListContentLoactionCellIdentifier = @"CityListContentLoactionCellIdentifier";

#define NO_CityName  @"未获取到位置信息"
@interface CityListViewController ()<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,assign) CityListViewFromType fromType;

/**
  
 */
@property(nonatomic,strong) NSString *cityName;
@property(nonatomic,strong) NSString *provinceName;
@property(nonatomic,assign) NSNumber *provinceID;
@property(nonatomic, strong) QueryCitysModel * citysModel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation CityListViewController
- (instancetype)initWithType:(CityListViewFromType)type withCityName:(NSString *)cityName withProvinceName:(NSString *)provinceName withProvinceID:(NSNumber *)provinceID{

    if (self == [super init]) {
        self.fromType = type;
        self.cityName = cityName;
        self.provinceName = provinceName;
        self.provinceID = provinceID;
    }
    return self;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class]  forCellReuseIdentifier:CityListCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CityListContentLoactionCell class]) bundle:nil ]    forCellReuseIdentifier:CityListContentLoactionCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CityListProvinceCell class]) bundle:nil ]   forCellReuseIdentifier:CityListProvinceCellIdentifier];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"选择地区"];
    
    [self.view addSubview:self.tableView];
    
    [self requesetQueryCity];
    
  
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (self.fromType == CityListViewFromType_Province) {
        [self startLocation];
    }
}
- (void)startLocation
{
    
    if ([CLLocationManager locationServicesEnabled])  //确定用户的位置服务启用
        
        
    {
        self.locationManager = [[CLLocationManager alloc] init];
        
        // 2.想用户请求授权(iOS8之后方法)   必须要配置info.plist文件
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 以下方法选择其中一个
            // 请求始终授权   无论app在前台或者后台都会定位
            //  [locationManager requestAlwaysAuthorization];
            // 当app使用期间授权    只有app在前台时候才可以授权
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 距离筛选器   单位:米   100米:用户移动了100米后会调用对应的代理方法didUpdateLocations
        // kCLDistanceFilterNone  使用这个值得话只要用户位置改动就会调用定位
        self.locationManager.distanceFilter = 100.0;
        // 期望精度  单位:米   100米:表示将100米范围内看做一个位置 导航使用kCLLocationAccuracyBestForNavigation
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        // 3.设置代理
        self.locationManager.delegate = self;
        
        // 4.开始定位 (更新位置)
        [self.locationManager startUpdatingLocation];
        
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
//            // 5.临时开启后台定位  iOS9新增方法  必须要配置info.plist文件 不然直接崩溃
//            self.locationManager.allowsBackgroundLocationUpdates = YES;
//        }
        
        
        NSLog(@"start gps");
        
    }else{
      
            NSString * title = @"提示";
            NSString * content = @"无法获取您的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许小佳老师使用定位服务。";
            NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, nil)];
            [self showNormalAlertTitle:title content:content items:items block:nil];
      
   
        
        //        if (IOS8) {
        //            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        //            if ([[UIApplication sharedApplication] canOpenURL:url]) {
        //                [[UIApplication sharedApplication] openURL:url];
        //            }
        //        } else {
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        //        }
        
        
        
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    //    CLLocation *location = newLocation;
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f===", coordinate.latitude, coordinate.longitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0){
            CLPlacemark * placemark = placemarks[0];
            
            
            
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            //            NSString * state = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES);
            //            CNPostalAddress * address = [[CNPostalAddress alloc]init];
            //          NSAttributedString * stateAttri = [CNPostalAddressFormatter attributedStringFromPostalAddress:address style:CNPostalAddressFormatterStyleMailingAddress withDefaultAttributes:placemark.addressDictionary ];
            
            NSString * state =  [placemark.addressDictionary objectForKey:@"State"];
            // 省
            NSLog(@"state,%@",state);
            // 位置名
            NSLog(@"name,%@",placemark.name);
            // 街道
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            // 子街道
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            // 市
            NSLog(@"locality,%@",placemark.locality);
            // 区
            NSLog(@"subLocality,%@",placemark.subLocality);
            // 国家
            NSLog(@"country,%@",placemark.country);
            self.cityName = city;
            self.provinceName = state;
            
           
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
           
        };
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else
        return  [self.citysModel.items count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    if (indexPath.section == 0) {
        CityListContentLoactionCell *tempCell =[tableView dequeueReusableCellWithIdentifier:CityListContentLoactionCellIdentifier];
        BOOL showImg ;
        if (!self.cityName||[self.cityName isEqualToString: NO_CityName]) {
            self.cityName = NO_CityName;
            showImg =  NO;
        }else{
            showImg =  YES;
        }
        [tempCell seutpCityName:self.cityName isShowImg:showImg];
        cell = tempCell;

    }else{
        if (indexPath.row == 0) {
            
            CityListProvinceCell * tempCell =[tableView dequeueReusableCellWithIdentifier:CityListProvinceCellIdentifier];
          
            [tempCell setupProvince:self.provinceName];
            
            cell = tempCell;

        }else{
            cell =[tableView dequeueReusableCellWithIdentifier:CityListCellIdentifier] ;
            CityModel * city =  self.citysModel.items[indexPath.row-1];
            cell.textLabel.text = city.name;
            cell.textLabel.textColor = UIColorFromRGB(0x6b6b6b);
            cell.textLabel.font = fontSize_15;
        }
      
    
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        if (indexPath.row == 0  ) {
            [self gotoProvinceVC];
        }else{
            [self backVC:indexPath];
        }

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     return FITSCALE(50);
     
}
#pragma mark ----
- (void)requesetQueryCity{
    NSDictionary * parameterDic;
    NetRequestType  type = 0;
    if (self.fromType == CityListViewFromType_Province) {
        parameterDic  =@{@"parent":self.provinceID};
        type = NetRequestType_QueryCity;
     
    }else if(self.fromType == CityListViewFromType_School){
        parameterDic  =@{@"name":self.cityName};
        type = NetRequestType_CityName;
    }
       [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:type] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:type];
    
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryCity) {
            strongSelf.citysModel = [[QueryCitysModel alloc]initWithDictionary:successInfoObj error:nil];
            
            [strongSelf.tableView reloadData];
        }else if (request.tag == NetRequestType_CityName){
         strongSelf.citysModel = [[QueryCitysModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark ---
- (void)gotoProvinceVC{
    
    ProvinceListViewController * provinceVC = [[ProvinceListViewController alloc]initWithType:ProvinceListViewFromType_City];
    provinceVC.selectedProvinceBlock = ^(NSString *provinceName, NSNumber *provinceID) {
        self.provinceName =  provinceName;
        self.provinceID = provinceID;
        self.fromType = CityListViewFromType_Province;
        [self requesetQueryCity];
    };
    
    [self pushViewController:provinceVC];
}


- (void)backVC:(NSIndexPath *)indexPath{

    CityModel * city =  self.citysModel.items[indexPath.row-1];
    if (self.fromType == CityListViewFromType_School) {
        if (self.selectedCityBlock) {
            self.selectedCityBlock(city.name);
        }
        [self backViewController];
    }else if (self.fromType == CityListViewFromType_Province){
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:UPDATACITY_NotificationKey object:nil userInfo:@{@"city":city.name,@"province":self.provinceName}];
        NSInteger index = [self.navigationController.viewControllers count]-3;
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
    }

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
