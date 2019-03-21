//
//  AddressListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AddressListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ContentAddressCell.h"
#import "ContentAddressSchoolCell.h"
#import "CityListViewController.h"
#import "AddressSchoolsModel.h"
#import "ProvinceListViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import "SessionHelper.h"
#import "SessionModel.h"
#import "ResponseViewController.h"


#define   CITY_NORMAL    @"未获取到位置信息"


NSString * const ContentAddressCellIdentifier = @"ContentAddressCellIdentifier";
NSString * const ContentAddressSchoolCellIdentifier = @"ContentAddressSchoolCellIdentifier";

@interface AddressListViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString * cityName;
@property(nonatomic, copy) NSString * provinceName;
@property(nonatomic, copy) NSString * subLocality;

/**
 绑定学校对象
 */
@property(nonatomic, strong) AddressSchoolModel * bindingSchoolMode;

@property(nonatomic, strong) AddressSchoolsModel * schoolModels;

/**经过搜索之后的数据源*/
@property (nonatomic, strong) AddressSchoolsModel *searchResultSchoolModels;


@property(nonatomic, strong) UISearchController *searchController;
@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"选择学校"];
    [self setupRightBarButtonItem];
    self.cityName = CITY_NORMAL;
    [self setupSubView];
    [self setupSearchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCityList:) name:UPDATACITY_NotificationKey  object:nil];
  
    [self performSelector:@selector(startLocation) withObject:nil afterDelay:1.0f];
    
    [self showHUDInfoByType:HUDInfoType_Loading];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.trailing.mas_equalTo(self.view.mas_trailing);
    }];
    
    [self nameSpace];
}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

- (void)setupSubView{

    [self.view addSubview:self.tableView];
}


- (UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:NULL];
        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.placeholder =   @"请输入搜索内容";
        _searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
         /// 点击搜索按钮进行搜索
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.returnKeyType = UIReturnKeySearch;
        
//        /// 实时搜索
//       _searchController.searchBar.returnKeyType = UIReturnKeyDone;
//       _searchController.searchResultsUpdater = self;
   
      
        /// 去除 searchBar 上下两条黑线
        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
        barImageView.layer.borderWidth = 1;
      
        
        [_searchController.searchBar sizeToFit];
    }
    
    return _searchController;
}



- (void)setupSearchBar{
    /**配置Search相关控件*/
    
     self.tableView.tableHeaderView = self.searchController.searchBar;
  
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:project_main_blue];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
   
}



- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat searchH  = FITSCALE(0);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  searchH,self.view.frame.size.width, self.view.frame.size.height - searchH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContentAddressCell class]) bundle:nil] forCellReuseIdentifier:ContentAddressCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContentAddressSchoolCell class]) bundle:nil] forCellReuseIdentifier:ContentAddressSchoolCellIdentifier];
    }
    return _tableView;
}
- (void)setupRightBarButtonItem{

    UIButton * rightBtn = [UIButton buttonWithType:0];
    [rightBtn setTitle:@"未找到学校" forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 80, 44)];
    [rightBtn setImage:[[UIImage imageNamed:@"address_help"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = rightBarButtonItem_font;
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, rightBtn.imageView.bounds.size.width-rightBtn.titleLabel.bounds.size.width - FITSCALE(10), 0 ,5);//设置title在button
    
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake( 0, 0, 0 , -rightBtn.imageView.bounds.size.width- rightBtn.titleLabel.bounds.size.width - 50*scale_x);//设置img在button
    
  
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn ];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
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
            // 5.临时开启后台定位  iOS9新增方法  必须要配置info.plist文件 后台定位不然直接崩溃
//            self.locationManager.allowsBackgroundLocationUpdates = YES;
//        }
        
        
        NSLog(@"start gps");
        
    }else{
       
      
            NSString * title = @"提示";
            NSString * content = @"无法获取您的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许小佳老师使用定位服务。";
            NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, nil)];
            [self showNormalAlertTitle:title content:content items:items block:nil];
        
        [self hideHUD];
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
            NSString * state =  [placemark.addressDictionary objectForKey:@"State"];
            // 省
//            NSLog(@"state,%@",state);
//            // 位置名
//            NSLog(@"name,%@",placemark.name);
//            // 街道
//            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
//            // 子街道
//            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
//            // 市
//            NSLog(@"locality,%@",placemark.locality);
//            // 区
//            NSLog(@"subLocality,%@",placemark.subLocality);
//            // 国家
//            NSLog(@"country,%@",placemark.country);
            self.cityName = city;
            self.provinceName = state;
            
            self.subLocality =placemark.subLocality;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
            
            [self requesetCitySchool];
        };
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
           [self hideHUD];
    }
}

#pragma mark ==

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /**对TableView进行判断，如果是搜索结果展示视图，返回不同数据源*/
    if (self.searchController.active) {
        return 1;
    }else
      return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchResultSchoolModels.schools count];
    } else{
        if (section ==  0) {
            return 1;
        }else
            return  [self.schoolModels.schools count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell ;
    if (self.searchController.active) {
        ContentAddressSchoolCell *schollCell = [tableView dequeueReusableCellWithIdentifier:ContentAddressSchoolCellIdentifier];
  
         NSArray * schools= self.searchResultSchoolModels.schools;
        AddressSchoolModel * model = schools[indexPath.row];
        
        [schollCell setupSchoolModel:model];
        cell = schollCell;
    }else{
        
        if (indexPath.section == 0) {
            ContentAddressCell* addressCell = [ tableView dequeueReusableCellWithIdentifier:ContentAddressCellIdentifier];
            addressCell.block = ^{
                
                [self startLocation];
            };
            [addressCell setupTitle:self.cityName];
            cell = addressCell;
        }else{
            ContentAddressSchoolCell *schollCell = [tableView dequeueReusableCellWithIdentifier:ContentAddressSchoolCellIdentifier];
            [schollCell setupSchoolModel:self.schoolModels.schools[indexPath.row]];
            cell = schollCell;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    return FITSCALE(50);
}
- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (self.searchResultSchoolModels)  {
         AddressSchoolModel * model = self.searchResultSchoolModels.schools[indexPath.row];
           [self requesetBindingTeacherSchool:model ];
        
    }else{
        if (indexPath.section == 0) {
            if (![self.cityName isEqualToString:CITY_NORMAL]) {
                [self gotoCityListVC];
            }else{
                
                [self gotoProvinceListVC];
            }
        }else{
            AddressSchoolModel * model = self.schoolModels.schools[indexPath.row];
            [self requesetBindingTeacherSchool:model ];
            
        }
    }
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
 
    return YES;
}
#pragma mark - 👀 这里主要处理非实时搜索的配置 👀 💤

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   
    if ([searchBar.text length]>0) {
        
//       self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
       [self requestSearchSchool:searchBar.text];
        
    }
 
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
//    if (self.searchController.active) {
//      self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  );
//    }
    [self.searchController.searchBar resignFirstResponder];
    
}

#pragma mark - 👀 这里主要处理实时搜索的配置 👀 💤

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
  
}

/**
 *  结束编辑的时候，显示搜索之前的界面，并将 _searchResults 清空
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
 
//    self.searchController.active = NO;
    self.searchResultSchoolModels = nil;
//    [self setupSearchBar];
    
//    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  );
    
    [self.tableView reloadData];
}
#pragma mark ----
- (void)requesetCitySchool{

    NSMutableDictionary * parameterDic = [[NSMutableDictionary alloc]init];
    if (self.cityName) {
        [parameterDic addEntriesFromDictionary:@{@"cityName":self.cityName}];
    }
    if (self.subLocality) {
        [parameterDic addEntriesFromDictionary:@{@"areaName":self.subLocality}];
    }
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QuerySchoolByCityName] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QuerySchoolByCityName];
   
}

//绑定教师学校
- (void)requesetBindingTeacherSchool:(AddressSchoolModel *)model{
    self.bindingSchoolMode = model;
    NSMutableDictionary * parameterDic = [[NSMutableDictionary alloc]init];
    [parameterDic addEntriesFromDictionary:@{@"schoolId":model.schoolId}];
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_SetTeacherSchool] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_SetTeacherSchool];
    
}

-(void)requestSearchSchool:(NSString *)schoolName{
    NSDictionary * parameterDic = @{@"schoolName":schoolName};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListSchoolByName] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListSchoolByName];
}


- (void)nameSpace{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QuerySchoolByCityName) {
            if(successInfoObj[@"schools"]){
            
               strongSelf.schoolModels = [[AddressSchoolsModel alloc]initWithDictionary:successInfoObj error:nil];
                
                [strongSelf.tableView reloadData];
            };
        } else if (request.tag == NetRequestType_SetTeacherSchool) {
            NSLog(@"%@===",successInfoObj);
            NSString * content = @"绑定学校成功，请创建或加入班级";
            strongSelf.searchController.active = NO;
            [strongSelf showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
                if (strongSelf.addressSuccessblock) {
                    strongSelf.addressSuccessblock();
                }
                SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
                sesstion.schoolId = strongSelf.bindingSchoolMode.schoolId;
                sesstion.schoolName = strongSelf.bindingSchoolMode.schoolName;
                NSLog(@"哈哈哈哈---%@",sesstion.schoolId);
                [[SessionHelper sharedInstance]saveCacheSession:sesstion];
                
                [strongSelf backViewController];
              
            }];
            
//            [PromptView showResultViewWithResult:TNStateOK withContent:@"绑定学校成功，请创建或加入班级" withDoneBlock:^{
//                if (strongSelf.addressSuccessblock) {
//                    strongSelf.addressSuccessblock();
//                }
//                SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
//                sesstion.schoolId = strongSelf.bindingSchoolMode.schoolId;
//                sesstion.schoolName = strongSelf.bindingSchoolMode.schoolName;
//                NSLog(@"哈哈哈哈---%@",sesstion.schoolId);
//                [[SessionHelper sharedInstance]setAppSession:sesstion];
//               
//                
//                [strongSelf backViewController];
//                [PromptView dismissAlertView];
//            }];
        }else if (request.tag == NetRequestType_ListSchoolByName){
            NSLog(@"%@===",successInfoObj);
            if(successInfoObj[@"schools"]){
                
                strongSelf.searchResultSchoolModels = [[AddressSchoolsModel alloc]initWithDictionary:successInfoObj error:nil];
              
                [strongSelf.tableView reloadData];
 
            };
            
        }
    }];
}

#pragma mark ----

- (void)rightAction:(id)sender{
    
    //问题反馈
    ResponseViewController * responseVC = [[ResponseViewController alloc]init];
    [self pushViewController:responseVC];
    
}


- (void)gotoProvinceListVC{
    ProvinceListViewController *list = [[ProvinceListViewController alloc]initWithType:ProvinceListViewFromType_School];
    [self pushViewController:list];
}

- (void)gotoCityListVC{
    CityListViewController *list = [[CityListViewController alloc]initWithType:CityListViewFromType_School withCityName:self.cityName withProvinceName:self.provinceName withProvinceID:nil  ];
    list.selectedCityBlock = ^(NSString *name) {
         self.cityName = name;
          [self requesetCitySchool];
    };
    [self pushViewController:list];
}

- (void)updateCityList:(NSNotification *)info{

    NSDictionary * dic = info.userInfo;
    self.cityName = dic[@"city"];
    self.provinceName = dic[@"province"];
    [self requesetCitySchool];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self clearDelegate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATACITY_NotificationKey object:nil];
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
