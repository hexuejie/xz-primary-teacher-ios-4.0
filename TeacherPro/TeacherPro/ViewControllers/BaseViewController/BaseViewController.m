//
//  BaseViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseViewController.h"
#import "HUDManager.h"
#import "LoginController.h"
#import "ProUtils.h"
#import "UIViewController+HBD.h"
#import "UIView+add.h"

@interface BaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseViewController
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = view_background_color;
    
    self.edgesForExtendedLayout = [self getViewRect];
    
    self.extendedLayoutIncludesOpaqueBars = [self getLayoutIncludesOpaqueBars];
    
}


- (void)configNavigationBar{
    
    UIColor * navbgColor = nil;
    UIColor * titleColor = nil;
    CGFloat alpha = 0.0f;
    if ([self getNavBarBgHidden]) {
        navbgColor = [UIColor whiteColor];
        titleColor = [UIColor clearColor];
        alpha = 0.0f;
    }else{
        navbgColor = [UIColor whiteColor];
        titleColor = [UIColor whiteColor];
        alpha = 1.0f;
    }
    self.hbd_barAlpha = alpha;
    self.hbd_tintColor = titleColor;
    self.hbd_barTintColor =  navbgColor;
    
    [self hbd_setNeedsUpdateNavigationBar];
    
    //navigationBar下面的黑线隐藏掉
    [self.navigationController.navigationBar setShadowImage:[UIImage  new]];
    
    [self addNavigationBarBg];
}


- (void)setupViewFrameHeight:(CGFloat )viewHeight{
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, viewHeight);
    
}
- (void)confighViewFrame{
    CGFloat  viewHeight = 0;
    CGFloat tempTabarSpacing = ([self isShowTabarController] ? tn_tabbat_height :0);
    
    if ([self getNavBarBgHidden]) {
        
        viewHeight = self.view.frame.size.height - tempTabarSpacing;
        
    }else{
        CGFloat viewH = self.view.frame.size.height;
        CGFloat navH = NavigationBar_Height;
        if ([self getViewRect] == UIRectEdgeNone) {
            
            viewHeight = viewH  - navH - tempTabarSpacing;
        }else if ([self getViewRect] == UIRectEdgeAll){
            viewHeight = viewH - tempTabarSpacing;
        }
    }
    [self setupViewFrameHeight:viewHeight];
}
//  如果导航条不是隐藏的 UIRectEdgeNone  为下移64高度
// 如果导航条隐藏的 UIRectEdgeAll  需要要设置  extendedLayoutIncludesOpaqueBars 属性 为YES View显示在导航栏下面挡住一部分
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeNone;
}

//    如果导航栏是不透明的, 默认 YES   UIViewController的View就会往下移, 在导航栏下显示,全屏View显示在导航栏挡住     NO 为下移64高度 View不会被导航栏挡住
- (BOOL )getLayoutIncludesOpaqueBars{
    
    return YES;
}

- (void)navUIBarBackground:(CGFloat)pacity{
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    if (pacity == 0) {
        self.pacity = -1;
    }
    
    uiBarBackground.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.05].CGColor;//0.05
    uiBarBackground.layer.shadowOpacity = pacity;
    uiBarBackground.layer.shadowOffset = CGSizeMake(0, 1);
    uiBarBackground.layer.shouldRasterize = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条代理
    //    self.navigationController.delegate = self;
    
    // Do any additional setup after loading the view.
    
    if ([self getShowBackItem]) {
        _backItem = [[UIBarButtonItem alloc]initWithImage:[self getButtonItem] style:UIBarButtonItemStylePlain target:self action:@selector(backViewController)];
        self.navigationItem.leftBarButtonItem = _backItem;
    }
    
    
    [self configNavigationBar];
    [self confighViewFrame];
    
}
- (UIImage *)getButtonItem{
    return  [[UIImage imageNamed:@"testreturn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
 

- (void)addNavigationBarBg{
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground addSubview:[self getNavigationBackgroundView]];
}
-  (UIView *)getNavigationBackgroundView{
    UIColor * imageColor = nil;
    
    if ([self getNavBarBgHidden]) {
        imageColor = [UIColor clearColor];
    }else{
        imageColor = [UIColor whiteColor];
        
    }
    
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    if (self.pacity == -1) {
        [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
    }else{

        uiBarBackground.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.05].CGColor;//0.05
        uiBarBackground.layer.shadowOpacity = 8;
        uiBarBackground.layer.shadowOffset = CGSizeMake(0, 1);
        uiBarBackground.layer.shouldRasterize = NO;
    }
    
    UIView *navigationBackgroundView = nil;
    if (![uiBarBackground viewWithTag:686868]) {
        //添加一个背景颜色view
        navigationBackgroundView = [[UIView alloc] init];
    }else{
        navigationBackgroundView = [uiBarBackground viewWithTag:686868];
    }
    navigationBackgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width,64);
   
    
    if (kScreenWidth == 375&&kScreenHeight>667){
        navigationBackgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width,88);
    }
    
    
    navigationBackgroundView.backgroundColor = imageColor;
    navigationBackgroundView.tag = 686868;
    navigationBackgroundView.alpha = 1.0;
    
    return navigationBackgroundView;
}
- (BOOL )getShowBackItem{
    
    return YES;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-  (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//        if ([self getNavBarBgHidden ]) {
            [self configNavigationBar];
//        }
//    白底黑字
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (BOOL)getNavBarBgHidden{
    
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    if ([self isViewWillDisappearHideHUD]) {
        [self hideHUD];
    }
    [super viewWillDisappear:animated];
}
- (BOOL)isViewWillDisappearHideHUD{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当界面被刷新后，调用ViewController的“viewDidLayoutSubviews”
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
#pragma mark - 工具类方法    ////////////////////////////////////////////////////////////////////////////
- (void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)pushViewController:(UIViewController *)viewController
{
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)viewController modalTransitionStyle:(UIModalTransitionStyle)style completion:(void (^)(void))completion
{
    if (viewController)
    {
        viewController.modalTransitionStyle = style;
        
        [self presentViewController:viewController animated:YES completion:completion];
    }
}

- (NSString *)getLoadingHUDStr{
    
    return Loading;
}

- (void)showHUDInfoByType:(HUDInfoType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type)
        {
            case HUDInfoType_Success:
            {
                
                [HUDManager showHUDWithToShowStr:LoadingFinish HUDMode:MBProgressHUDModeText autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:0.0f];
            }
                break;
            case HUDInfoType_Failed:
            {
                
                
            }
                break;
            case HUDInfoType_Loading:
            {
                UIView * view = [UIApplication sharedApplication].keyWindow;
                //            UIView * view = self.view;
                [HUDManager showHUDWithToShowStr:[self getLoadingHUDStr] HUDMode:MBProgressHUDModeCustomView autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:view addProgress:0.0f];
            }
                break;
            case HUDInfoType_NoConnectionNetwork:
            {
                
                [HUDManager showHUDWithToShowStr:NoConnectionNetwork HUDMode:MBProgressHUDModeText autoHide:YES afterDelay:3.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:0.0f];
                
            }
                break;
                
            case HUDInfoType_Uploading:
            {
                [HUDManager showHUDWithToShowStr:@"正在上传" HUDMode:MBProgressHUDModeDeterminate autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:0.0f];
            }
                
                break;
            case HUDInfoType_NormalShadeNo:
            {
                
                [HUDManager  showHUDWithToShowStr:LoadingFinish HUDMode:MBProgressHUDModeCustomView autoHide:NO afterDelay:0.0 userInteractionEnabled:YES showType:HUDOthers HUDAddedToView:self.view addProgress:0.0f hasShade:NO];
            }
                
                break;
            default:
                break;
        }
    });
    
}

- (void)showUploadHUDProgress:(CGFloat )progress{
    [HUDManager showHUDWithToShowStr:@"正在上传" HUDMode:MBProgressHUDModeDeterminate autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:progress];
    
}

- (void)showHUDInfoByString:(NSString *)str
{
      if (![self viewIsExistWarning]){
          [[[AlertView alloc]initWithOperationState:TNOperationState_Fail detail:str items:nil] show];
          
      }
    
}

- (void)hideHUD
{
    [HUDManager hideHUD];
}
- (void)setNavigationItemTitle:(NSString *)titleStr
{
    [self setNavigationItemTitle:titleStr titleFont:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium] titleColor:HexRGB(0x4D4D4D)];
}

- (void)setNavigationItemTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color
{

    self.navigationItem.title = title;
    
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : color, NSFontAttributeName : font};
}

- (void)backViewController
{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (void)showAlert:(TNOperationState )operation content:(NSString *)content{
    
    [self showAlert:operation content:content block:nil];
}
- (void)showAlert:(TNOperationState )operation content:(NSString *)content block:(MMPopupItemHandler) itemHandler{
    NSArray * items = nil;
    if (itemHandler) {
        items =
        @[MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];
        
    }
     if (![self viewIsExistWarning]){
         [[[AlertView  alloc]initWithOperationState:operation detail:content items:items
           ] show];
         
     }
}

- (void)showNormalAlertTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items block:(MMPopupItemHandler) itemHandler{
    
    if (!items) {
        items =
        @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
          MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];
    }
     if (![self viewIsExistWarning]){
         AlertView * alert = [[AlertView  alloc]initWithTitle:title detail:content items:items ];
         [alert show];
         
     }
    
    
}

- (void)showAlertNormalInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler {
     if (![self viewIsExistWarning]){
         AlertView * alert = [[AlertView alloc]initWithNormalInputTitle:title detail:content items:items placeholder:placeholder handler:inputHandler ];
    
         [alert show];
         
     }
    
    
}

- (void)showAlertInputPhoneTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler {
     if (![self viewIsExistWarning]){
         AlertView * alert = [[AlertView alloc]initWithInputPhoneTitle:title detail:content items:items placeholder:placeholder handler:inputHandler ];
    
         [alert show];
         
     }
    
    
}

- (void)showAlertCreateInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler{
     if (![self viewIsExistWarning]){
         AlertView * alert = [[AlertView alloc]initWithCreateInputTitle:title detail:content items:items placeholder:placeholder handler:inputHandler ];
    
         [alert show];
         
     }
    
    
}
- (void)showAlertValidationInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder  handler:(MMPopupHandler)inputHandler  textFeildRightItem:(MMPopupItem *)rightItem{
        if (![self viewIsExistWarning]){
    
            AlertView * alert = [[AlertView alloc]initWithValidationInputTitle:title detail:content items: items placeholder:placeholder handler:inputHandler  textFeildRightItem:rightItem ];
            [alert show];
            
        }
    
}


- (BOOL)viewIsExistWarning{
    BOOL isEixt = NO;
    for (UIView  * view in [MMPopupWindow sharedWindow].attachView.mm_dimBackgroundView.subviews) {
        if ([view isKindOfClass:[MMPopupView class]]) {
            isEixt = YES;
        }
    }
    return isEixt;
}
- (BOOL)isShowTabarController{
    return NO;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
/// 自定义导航条
- (void)customizeNavigationInterface {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor_gray,NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]}];
    
    //    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    //        [[UINavigationBar appearance] setTranslucent:NO];
    //    }
    //    [[UINavigationBar appearance]setBarTintColor:project_main_blue];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance]setShadowImage:[self createImageWithColor:tn_border_color withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1f)]];
    [[UIApplication sharedApplication]  setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //按钮文字
    //    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    
    
    
    UIImage *barBackBtnImg = [[UIImage imageNamed:@"testreturn"] imageWithRenderingMode:UIImageRenderingModeAutomatic]   ;
    
    [[UINavigationBar appearance] setBackIndicatorImage:barBackBtnImg];
    
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:barBackBtnImg];
    //    [UIBarButtonItem appearance].imageInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
    //                                                      forState:UIControlStateNormal
    //                                                    barMetrics:UIBarMetricsDefault];
    
}

- (UIImage*) createImageWithColor: (UIColor*) color withFrame:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end

