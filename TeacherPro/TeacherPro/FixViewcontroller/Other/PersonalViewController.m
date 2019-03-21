
//
//  PersonalViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//个人中心

#import "PersonalViewController.h"
#import "TNTabbarController.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "SettingController.h"
#import "ClassManagementNewViewController.h"
#import "GratitudeCurrencyViewController.h"
#import "PresonalUserInfoViewController.h"
#import "HeaderElasticBgView.h"
#import "ProUtils.h"
#import "PersonalViewCell.h"
#import "UIImageView+WebCache.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "XXYActionSheetView.h"
#import "UploadFileModel.h"
#import "TabbarConfigManager.h"
#import "UIViewController+HBD.h"
#import "MessageListViewController.h"
#import "ExchangeInstructionViewController.h"
#import "GFMallViewController.h"
#import "HelpViewController.h"

#define usernameLabelTag    10222
#define coinLabelTag        10223
#define schoolNameLabelTag  10224
#define userIdLabelTag      10225
#define headerBgViewTag     11111
#define userImgVTag     1111123


NSString * const  PersonalViewCellIdentifier = @"PersonalViewCellIdentifier";

@interface PersonalViewController ()<TZImagePickerControllerDelegate,XXYActionSheetViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CGFloat _gradientProgress;
}
@property (nonatomic,strong) NSArray *personList;
@property (nonatomic,strong) UIView *navigationBackgroundView;
@property(nonatomic, strong) NSMutableArray *selectedPhotos;//图片数据
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UploadFileModel *uplaodImageModel;//图片地址信息
@property(nonatomic, strong) NSString  *oldThumbnail;//旧图像地址

@property (nonatomic, strong) HeaderElasticBgView *headerView;
@property (nonatomic, assign) CGFloat  defultHeaderHeight;

@end

@implementation PersonalViewController

- (instancetype)init{

    self =  [super init];
    if (self) {
        //注册获取金币 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIcon) name:UPDATE_CHECKLIST_TEARCHER_COIN object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedAssets = [[NSMutableArray alloc]init];
    self.selectedPhotos = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
 
    // Do any additional setup after loading the view.
//    [self setNavigationItemTitle:@"个人中心"];
    
//    [self setupRightItem];

    NSArray *towSectionArray = @[@{@"title":@"感恩币",@"icon":@"Gratitude_icon"},
                                 @{@"title": @"个人资料",@"icon":@"preson_info_icon"},
                                 @{@"title": @"设置" ,@"icon":@"preson_setup_icon"}];
    NSArray *threeSectionArray = @[
                                 @{@"title": @"感恩币获取规则" ,@"icon":@"preson_guizhe_icon"},
                                 @{@"title": @"兑换商城",@"icon":@"preson_shop_icon"},
                                 ];
    
    self.personList = @[towSectionArray,threeSectionArray];
 
    [self setupTableViewHeader];

    self.tableView.bounces = YES;
    //取消loading
    self.startedBlock = nil;
//    [self updateIcon];

}


- (void)registerCell{

    [self.tableView registerNib: [UINib nibWithNibName:NSStringFromClass([PersonalViewCell class]) bundle:nil] forCellReuseIdentifier:PersonalViewCellIdentifier];
}


- (void)updateIcon{
    self.startedBlock = nil;
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherCoin] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherCoin];
    
}
- (void)updateTeacherAvatar{
    NSString *thumbnail = @"";
    if (self.uplaodImageModel){
        
       thumbnail =[self.uplaodImageModel.visitUrls allValues].firstObject;
        
    }
    if (thumbnail.length == 0) {
        NSLog(@"没有获取到图片地址");
        return;
    }
    NSDictionary * parameterDic = @{@"thumbnail":thumbnail};
     [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherUpdateAvatar] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherUpdateAvatar];
}
- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherCoin) {
            SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
            NSNumber * coinStr = successInfoObj[@"coin"];
          
            sesstion.coin = coinStr;
            
            [[SessionHelper sharedInstance]saveCacheSession:sesstion];
            [strongSelf updateTableView];
        }else if (request.tag == NetRequestType_TeacherUpdateAvatar){
            NSString * imgUrl = strongSelf.uplaodImageModel.visitUrls.allValues.firstObject;
            //存储图片地址
            SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
            strongSelf.oldThumbnail = sesstion.thumbnail;
            sesstion.thumbnail = imgUrl;
            [[SessionHelper sharedInstance]saveCacheSession:sesstion];
            [strongSelf setupUserImgV:imgUrl];
        }
    }];
}


- (void)setupUserImgV:(NSString *)imgUrl {

    NSString * sex = [[SessionHelper sharedInstance] getAppSession].sex;
    UIImage * userImg = nil;
    if ([sex isEqualToString:@"male"]) {
        userImg = [UIImage imageNamed:@"tearch_man"];
    }else {
        userImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    
    if ( self.oldThumbnail && [self.oldThumbnail isKindOfClass:[NSString class]] &&self.oldThumbnail.length > 0) {
        if ([[SDImageCache sharedImageCache] imageFromCacheForKey:self.oldThumbnail]) {
           userImg  = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.oldThumbnail];
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView * userImgV  =  [self.view viewWithTag:userImgVTag];
        [userImgV sd_setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:userImg];
 
    });
    
}


- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj{
    if (request.tag == NetRequestType_TeacherUploadImage) {
         self.uplaodImageModel = [[UploadFileModel alloc]initWithDictionary:infoObj error:nil];
        [self updateTeacherAvatar];
    }else{
        [super netRequest:request successWithInfoObj:infoObj];
    }
}

- (void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}

- (BOOL)getNavBarBgHidden{
    
    return YES;
}
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}

- (BOOL )getShowBackItem{
    
    return NO;
}
- (void)setupRightItem{

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"setting_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)setupTableViewHeader{
    CGFloat pading = NavigationBar_Height;
    
    CGFloat  headerHeight = 160;
    
    self.defultHeaderHeight = headerHeight;
    self.headerView = [[HeaderElasticBgView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,headerHeight)];
 
    self.headerView.backgroundColor = project_main_white;//个人中心背景渐变色
    self.headerView.tag = headerBgViewTag;
    
    [self.view insertSubview:self.headerView aboveSubview:self.tableView];
    [self confighHeaderSubView:pading];
}

- (void)confighHeaderSubView:(CGFloat) pading{
    self.tableView.backgroundColor = [UIColor whiteColor];;
    
    UIImageView * userImgV = [[UIImageView alloc]init ];
    userImgV.backgroundColor = [UIColor clearColor];
    userImgV.tag = userImgVTag;
    [self.headerView addSubview:userImgV];
    userImgV.contentMode = UIViewContentModeScaleAspectFill;
    
    userImgV.layer.masksToBounds = YES;
    userImgV.layer.borderColor = HexRGB(0xF0F0F0).CGColor;
    userImgV.layer.borderWidth = 1.0;
    
    NSString * sex = [[SessionHelper sharedInstance] getAppSession].sex;
    UIImage * userImg = nil;
    
    if ([sex isEqualToString:@"male"]) {
        userImg = [UIImage imageNamed:@"tearch_man"];
    }else {
        userImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    
    self.oldThumbnail = [[SessionHelper sharedInstance] getAppSession].thumbnail;
    [self setupUserImgV: [[SessionHelper sharedInstance] getAppSession].thumbnail];
    
    userImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSheetView)];
    [userImgV addGestureRecognizer:tap];
    
    UILabel *usernameLabel = [[UILabel alloc]init];
    usernameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.textColor = HexRGB(0x525B66);
    usernameLabel.tag = usernameLabelTag;
    [self.headerView addSubview:usernameLabel];
    
    UILabel * schoolNameLabel = [[UILabel alloc]init];
    schoolNameLabel.font = [UIFont systemFontOfSize:14];
    schoolNameLabel.backgroundColor = [UIColor clearColor];
    schoolNameLabel.textColor = HexRGB(0x8A8F99);
    schoolNameLabel.textAlignment = NSTextAlignmentLeft;
    schoolNameLabel.tag = schoolNameLabelTag;
    [self.headerView addSubview:schoolNameLabel];
    
    UILabel *userIdLabel = [[UILabel alloc]init];
    userIdLabel.font = [UIFont systemFontOfSize:12];
    userIdLabel.backgroundColor = HexRGB(0xF6F6F8);
    userIdLabel.textColor = HexRGB(0x8A8F99);
    userIdLabel.tag = userIdLabelTag;
    userIdLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:userIdLabel];
    
    userIdLabel.layer.masksToBounds = YES;
    userIdLabel.layer.cornerRadius = 26/2;
    
    UIView * lineView = [[UIView alloc]init ];
    lineView.backgroundColor = HexRGB(0xF7F7F7);
    [self.headerView addSubview:lineView];
    
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView);
        make.left.mas_equalTo(self.headerView);
        make.bottom.mas_equalTo(self.headerView);
        make.height.mas_equalTo(1);
    }];
    
    [userImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
        make.leading.equalTo(self.headerView.mas_leading).offset(18);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(27);

    }];
    userImgV.layer.cornerRadius = 60/2;
   
    [usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userImgV.mas_right).offset(20);
        make.top.mas_equalTo(userImgV).offset(5);
    }];
    [userIdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self getUserIdWidth]);
        make.height.mas_equalTo(26);
        make.left.mas_equalTo(usernameLabel.mas_right).offset(24);
        make.centerY.mas_equalTo(usernameLabel.mas_centerY);
    }];
    
    [schoolNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(usernameLabel.mas_left);
        make.top.mas_equalTo(usernameLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(self.headerView.mas_right).offset(16);
    }];
}
- (CGFloat)getUserIdWidth{
    CGFloat width = [ProUtils getWidthWithText:[self getUserId] height:20 font:fontSize_11] +20;
    
    return width;
}
- (NSString *)getUserId{
    NSString * userId = [NSString stringWithFormat:@"老师号码:%@",[[SessionHelper sharedInstance]getAppSession].inviteCode];
    return userId;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tnTabbarController setIsTabbarHidden:NO];
    [super viewWillAppear:animated];
    NSString * name = [[SessionHelper sharedInstance] getAppSession].name;
    
    UILabel *usernameLabel =[self.headerView viewWithTag:usernameLabelTag];
    usernameLabel.text = name;
    
//    [self setNavigationItemTitle:name];
    UILabel *schoolNameLabel = [self.headerView viewWithTag:schoolNameLabelTag];
    
    NSString * schoolName = @"";
    if ([[SessionHelper sharedInstance]getAppSession].schoolName) {
        schoolName = [[SessionHelper sharedInstance]getAppSession].schoolName ;
    }else{
        schoolName = @"未绑定学校";
    }
    schoolNameLabel.text = [NSString stringWithFormat:@"%@ ",schoolName];
    UILabel *userIdLabel = [self.headerView viewWithTag:userIdLabelTag];
    userIdLabel.text = [self getUserId];
     [self updateIcon];
    
    self.hbd_barAlpha = 0.0;
    [self hbd_setNeedsUpdateNavigationBar];
     [self navUIBarBackground:0];
}

#pragma mark uitableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.personList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.01;
    }
    return 20;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(16, 10, kScreenWidth, 1)];
    lineview.backgroundColor = HexRGB(0xF7F7F7);
    [whiteView addSubview:lineview];
    return whiteView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger  row =  [self.personList [section] count];
    return row;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalViewCellIdentifier];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.personList[indexPath.section][indexPath.row];
    
    NSString * coinStr = [NSString stringWithFormat:@"%@",[[SessionHelper sharedInstance] getAppSession].coin];
    if ([coinStr isKindOfClass:[NSNull class]] ||[coinStr isEqualToString:@"(null)"]) {
        coinStr = @"0";
    }
    if (indexPath.section != 0) {
        coinStr = @"";
    }
    [cell setupIcon:dic[@"icon"] withTitle:dic[@"title"]  withCoin:coinStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             [self gotoGratitudeVC];
        }else if (indexPath.row == 1) {
            [self gotoUserInfo];
        }else if (indexPath.row == 2) {
            [self settingAction];
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self gotoExChangeVC];
        }else if (indexPath.row == 1) {
            [self gotoShoppingVC];
        }
        
    }
}

#pragma mark --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        if (_gradientProgress < 0.1) {
            self.hbd_barStyle = UIBarStyleBlack;
            self.hbd_tintColor = UIColor.whiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:0] };
        } else {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = UIColor.whiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:_gradientProgress] };
        }
        
        self.hbd_barAlpha = _gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
    self.headerView.frame = [self headerImageFrame];
    
}
- (void)actionSheetView{
    
    XXYActionSheetView*  alertSheetView = [[XXYActionSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择" , nil];
    alertSheetView.textColor = project_main_blue;
    alertSheetView.textLabelFont = fontSize_14;
    alertSheetView.cancelBtnFont = fontSize_14;
    alertSheetView.cancelBtnColor = project_main_blue;
    alertSheetView.separatorLineColor = project_line_gray;
    
    //弹出视图
    [alertSheetView xxy_show];
}
#pragma mark - XXYActionSheetViewDelegate
- (void)actionSheet:(XXYActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

}
- (void)actionSheet:(XXYActionSheetView *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"delegate点击的是:%zd", buttonIndex);
    if (buttonIndex == 0) {
        
        [self takePhoto];
    }else if (buttonIndex == 1){
        
        [self pushImagePickerController];
    }
    else if (buttonIndex == 2){
        //取消
    }
    
}
#pragma mark --

- (void)gotoGratitudeVC{
    NSString * coinStr = [NSString stringWithFormat:@"%@",[[SessionHelper sharedInstance] getAppSession].coin];
    if ([coinStr isKindOfClass:[NSNull class]] ||[coinStr isEqualToString:@"(null)"]) {
        coinStr = @"0";
    }
  
 
    GratitudeCurrencyViewController * gratitudeVC = [[GratitudeCurrencyViewController alloc]initWithCoin: coinStr];
    [self pushViewController:gratitudeVC];
    
}
- (void)gotoUserInfo{

    PresonalUserInfoViewController * userInfoVC = [[PresonalUserInfoViewController  alloc]init];
    [self pushViewController:userInfoVC];
}
- (void)gotoClassManagement{

    ClassManagementNewViewController * classManagementVC = [[ClassManagementNewViewController alloc]initWithType:ClassManagementType_preson];
    [self pushViewController:classManagementVC];
}

- (void)gotoMessageVC{
    
    MessageListViewController * messageVC = [[MessageListViewController alloc]initWithType:MessageListType_Preson];
    [self pushViewController:messageVC];
    
}

//#pragma event
- (void)settingAction {
    SettingController *setVC = [[SettingController alloc]init];
    [self pushViewController:setVC];
}

- (void)gotoShoppingVC{
    GFMallViewController * mallVC = [[GFMallViewController alloc]init];
    [self pushViewController:mallVC];
    
}

- (void)gotoExChangeVC{
//    ExchangeInstructionViewController * ExChangeVC = [[ExchangeInstructionViewController alloc]init];
//    [self pushViewController:ExChangeVC];
    HelpViewController * helpVC = [[HelpViewController alloc]init];
    [self pushViewController:helpVC];
    
}
- (void)uploadImgV{
    WEAKSELF
    self.startedBlock = ^(NetRequest *request)
    {
        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
    NSURL * url = [NSURL URLWithString:Request_NameSpace_upload_internal];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.181/res-upload/resource-upload-req"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://res.ajia.cn/res-upload/resource-upload-req"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://res.ajia.cn/res-upload/resource-upload-req"]];//
    }
    
    NSDictionary * requestHeaders ;
    if ([[SessionHelper sharedInstance] checkSession]) {
        requestHeaders =@{@"auth-token":(SessionModel *)[[SessionHelper sharedInstance] getAppSession].token};
    }
    NSMutableDictionary * fileDic = [NSMutableDictionary dictionary];
    for (int i =0;i<[self.selectedAssets count] ;i++) {
        UIImage * image = self.selectedPhotos[i];
        
        
        NSString * fileName = @"";
        if (iOS8Later) {
            
            PHAsset * asset = self.selectedAssets[i];
            fileName= asset.localIdentifier;
            //            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
            //            fileName = ((PHAssetResource*)resources[0]).originalFilename;
        } else {
            ALAsset * asset = self.selectedAssets[i];
            fileName =  asset.defaultRepresentation.filename;
            
        }
        
        [fileDic setObject:image forKey: fileName];
    }
    
    if ([self.selectedAssets count] > 0) {
        
        [[NetRequestManager sharedInstance] sendUploadRequest:(NSURL *)url parameterDic:@{@"appType":@"Primary",@"busiType":@"avatar"} requestMethodType:RequestMethodType_UPLOADIMG requestTag:NetRequestType_TeacherUploadImage  delegate:self fileDic:fileDic];
    }
    
    
}


#pragma mark - TZImagePickerController


- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        //        [alert show];
        MMPopupItemHandler handler = ^(NSInteger index){
            // 去设置界面，开启相机访问权限
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                
                NSLog(@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢");
                
            }
            
        };
        NSArray * items = @[MMItemMake(@"取消", MMItemTypeNormal, nil),
                            MMItemMake(@"确定", MMItemTypeNormal, handler)];
        [self showNormalAlertTitle:@"无法使用相机" content:@"请在iPhone的""设置-隐私-相机""中允许访问相机" items:items block:nil];
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        
        
        MMPopupItemHandler handler = ^(NSInteger index){
            // 去设置界面
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                
                NSLog(@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢");
                
            }
            
        };
        NSArray * items = @[MMItemMake(@"取消", MMItemTypeNormal, nil),
                            MMItemMake(@"确定", MMItemTypeNormal, handler)];
        [self showNormalAlertTitle:@"无法访问相册" content:@"请在iPhone的""设置-隐私-相册""中允许访问相册" items:items block:nil];
        
        
    } else if ([TZImageManager authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
        
        
    } else {
         [self gotoImagePickerV];
    }
}

- (void)gotoImagePickerV{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
         [self.tnTabbarController presentViewController:self.imagePickerVc];
     
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                WEAKSELF
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [weakSelf refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    self.selectedPhotos = [NSMutableArray arrayWithObject:image];
    self.selectedAssets = [NSMutableArray arrayWithObject:asset];
    [self uploadImgV];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)pushImagePickerController {
    int  MAX_IMAGE_COUNT = 1;
    int  COLUMN_IMAGE_COUNT =  4;
    if ( MAX_IMAGE_COUNT  <= 0) {
        return;
    }
   
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT columnNumber:COLUMN_IMAGE_COUNT delegate:self pushPhotoPickerVc:YES];


#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;

    if (MAX_IMAGE_COUNT > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮

    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;

    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;

    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;

    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;

    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;

    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/

    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止

    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    [imagePickerVc setNaviBgColor:project_main_blue];
    [imagePickerVc setNaviTitleFont:fontSize_18];

    [imagePickerVc setDoneBtnTitleStr:@"确定"];

    [imagePickerVc setOKButtonTitleColorNormal:[UIColor whiteColor]];
    [imagePickerVc setOKButtonTitleColorDisabled:[UIColor lightGrayColor]];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}



#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self uploadImgV];
}

- (BOOL)isShowTabarController{
    return YES;
}


- (CGRect) headerImageFrame {
    UITableView *tableView = self.tableView;

    CGFloat imageHeight =  FITSCALE(80) +NavigationBar_Height;
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.tableView;
    HeaderElasticBgView *headerView = self.headerView;
 
    CGFloat imageHeight = FITSCALE(80) +NavigationBar_Height;
    CGRect headerFrame = headerView.frame;
 
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
 
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}



@end
