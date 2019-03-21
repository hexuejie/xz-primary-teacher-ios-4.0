//
//  NewCheckHomeworkDetailVC.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "NewCheckHomeworkDetailVC.h"
#import "CheckHomeworkTypeVC.h"
#import "CheckHomeworkDetailHeaderView.h"///CheckHomeworkDetailHeaderView
#import "UIViewController+HBD.h"
#import "TeacherPro-Swift.h"
#import "RewardStudentViewController.h"

#import "NewCheeckPictureReportVC.h"
#import "HWCompleteStateHeaderV.h"
#import "HWUnfinishedCell.h"
#import "HWFinishedCell.h"
#import "HWKHLXFinishedCell.h"
#import "CheckDetialHeaderView.h"
#import "CheackDetialMedalView.h"
#import "CheckDetialCollectionCell.h"
#import "CheckDetialReusableView.h"
#import "HWReportViewController.h"

#import "StudentHomeworkDetailViewController.h"
#import "NewPersonReportListonPriceTableView.h"
#import "NewRewardStudentViewController.h"
#import "StudentFBViewController.h"
#import "CheckDetialTipsView.h"
#import "CheckDetialRangDetialView.h"
#import "UIView+add.h"
#import "NewRewardDetialTipView.h"

#define checkHeaderHeight 250
#define checkCollectionHeaderHeight 114+16*2 + 62

@interface NewCheckHomeworkDetailVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _gradientProgress;
}
@property(strong, nonatomic) LTLayout *layout;

@property(strong, nonatomic) NewRewardDetialTipView *tipView;
@property(strong, nonatomic) UIScrollView *bottomScrollView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) CheckDetialHeaderView *headerView;

@property(strong, nonatomic) CheackDetialMedalView *tableHeaderView;

@property(strong, nonatomic) CheckDetialTipsView *checkTipView;
@property(strong, nonatomic) CheckDetialRangDetialView *helpDetialView;

@property (copy, nonatomic) NSString * titleStr;
@property (copy, nonatomic) NSString * practiceType;

@property (strong, nonatomic) NSArray  * studentList;
@property (nonatomic, assign) BOOL isCheck;//是否检查状态
@end

@implementation NewCheckHomeworkDetailVC

- (instancetype)initHomeworkID:(NSString *)homeworkId  withType:(CheckHomeworkDetailVCType )type withOnlineHomework:(NSNumber *)onlineHomework{
    if (self == [super init]) {
        
        self.detailVCTyp = type;
        self.homeworkId = homeworkId;
        self.onlineHomework = onlineHomework;
        self.view.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@""];
    
    self.navigationController.navigationBar.translucent = YES;//设置导航栏为不是半透明状态
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0, *)) {
        self.bottomScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = HexRGB(0xFBFBFB);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self requestListHomeworkStudents];
    
    [self registerCell];
    [self layoutSubview];
    if (self.detailVCTyp == CheckHomeworkDetailVCType_look){
        self.bottomScrollView.frame = CGRectMake(0, checkHeaderHeight -62, kScreenWidth, kScreenHeight -checkHeaderHeight+65 );
    }else{
        [self setupBottomView];
    }
    [self customReload];
}

- (void)layoutSubview{
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.collectionView];
    [self.view addSubview:self.headerView];
    
    [self.bottomScrollView addSubview:self.tableHeaderView];
    
    self.tableHeaderView.frame = CGRectMake(0, 5-(checkCollectionHeaderHeight), kScreenWidth, checkCollectionHeaderHeight);
    self.collectionView.frame = CGRectMake(16, -10, kScreenWidth-32, 0 );
}


#pragma mark property
- (CheckDetialHeaderView *)headerView {//d顶部头
    if (!_headerView) {
        
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialHeaderView class]) owner:nil options:nil].firstObject;
        [_headerView.customBack addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.customPicButton addTarget:self action:@selector(feedbackClick:) forControlEvents:UIControlEventTouchUpInside];
     //学生反馈
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, checkHeaderHeight-64);
        
//        _headerView.userInteractionEnabled = NO;
    }
    return _headerView;
}

- (CheackDetialMedalView *)tableHeaderView {//勋章列表
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheackDetialMedalView class]) owner:nil options:nil].firstObject;
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        [_tableHeaderView.rangHelpButton addTarget:self action:@selector(rangHelpClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tableHeaderView;
}

- (CheckDetialTipsView *)checkTipView {
    if (!_checkTipView) {
        
        _checkTipView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialTipsView class]) owner:nil options:nil].firstObject;
        _checkTipView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _checkTipView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _checkTipView;
}

- (CheckDetialRangDetialView *)helpDetialView {
    if (!_helpDetialView) {
        
        _helpDetialView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialRangDetialView class]) owner:nil options:nil].firstObject;
        _helpDetialView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _helpDetialView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _helpDetialView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
//        _collectionView.alwaysBounceVertical = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

- (UIScrollView *)bottomScrollView {
    if (!_bottomScrollView) {
        
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, checkHeaderHeight -62, kScreenWidth, kScreenHeight -checkHeaderHeight )];
        _bottomScrollView.scrollEnabled = YES;
        _bottomScrollView.bounces = YES;
        _bottomScrollView.alwaysBounceVertical = YES;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView .scrollIndicatorInsets = UIEdgeInsetsMake(checkCollectionHeaderHeight, 0, 0, 0);
        _bottomScrollView .contentInset = UIEdgeInsetsMake(checkCollectionHeaderHeight, 0, 0, 0);
    }
    return _bottomScrollView;
}


- (void)setupBottomView{
    CGFloat bottomHeight = 65;
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  kScreenHeight-bottomHeight, kScreenWidth, bottomHeight)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setAdjustsImageWhenHighlighted:NO];
    [sureBtn setTitle:@"" forState:UIControlStateNormal];
    if (self.detailVCTyp == CheckHomeworkDetailVCType_look){
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"check_bottom_button3"] forState:UIControlStateNormal];
    }else{
       [sureBtn setBackgroundImage:[UIImage imageNamed:@"check_bottom_button"] forState:UIControlStateNormal];
    }
    sureBtn.frame = CGRectMake(16, 4, bottomView.frame.size.width - 16*2, bottomHeight-4*2);
    if (kScreenWidth == 375&&kScreenHeight>667){
        bottomView.frame = CGRectMake(0,  kScreenHeight-bottomHeight-18, kScreenWidth, bottomHeight);
        _bottomScrollView.frame = CGRectMake(0, checkHeaderHeight -62, kScreenWidth, kScreenHeight -checkHeaderHeight-18);
    }
    
    [sureBtn addTarget:self action:@selector(gotoCheckHomework) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//        make.height.mas_equalTo(@(bottomHeight));
//    }];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger section = [self.studentList count];
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger rows = 0;
    NSDictionary * sectionDic  = self.studentList[section];
    rows = [sectionDic[@"students"] count];
    return rows;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckDetialCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CheckDetialCollectionCell" forIndexPath:indexPath];
        NSDictionary * sectionDic  = self.studentList[indexPath.section];
//        if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {

    cell.dataDic = sectionDic[@"students"][indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {  //header
        CheckDetialReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CheckDetialReusableView" forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
//            header.courseName.text = //写死
        NSDictionary *sectionDic = self.studentList[indexPath.section];
        if (indexPath.section == 0) {
            header.isFirst = YES;
        }else{
            header.isFirst = NO;
        }
        header.finishLabel.text = sectionDic[@"title"];
        header.countLabel.text = [NSString stringWithFormat:@"%ld",[sectionDic[@"students"] count]];
        header.allCountLabel.text = [NSString stringWithFormat:@"/%@",self.listModel.info.studentCount];

        return header;
    }else {  //footer
        return [UICollectionReusableView new];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-50)/4, 90);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 83);
    }
    return CGSizeMake(kScreenWidth, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.onlineHomework == 0) {
        [SVProgressHelper dismissWithMsg:@"此作业暂无个人报告"];//此作业暂无个人报告
        return;
    }
    
    NSDictionary *sectionDic = self.studentList[indexPath.section];
    if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
        [SVProgressHelper dismissWithMsg:@"未完成的学生无个人报告"];//此作业暂无个人报告
        return;
    }
    
    //g个人报告
//    NewPersonReportListonPriceTableView *personVC = [[NewPersonReportListonPriceTableView alloc]initWithHomeworkId:self.homeworkId];
//
//    personVC.personDic = sectionDic[@"students"][indexPath.row];
//
//    [self pushViewController:personVC];
    
    
    NSDictionary *student = sectionDic[@"students"][indexPath.row];
    
    StudentHomeworkDetailViewController * detail = [[StudentHomeworkDetailViewController alloc]initWithStudent:student[@"studentId"] withStudentName:student[@"studentName"] withHomeworkId:self.homeworkId withHomeworkState:YES];
                                                    
//                                                    WithStudent:studentId withStudentName:studentName   withHomeworkId:self.homeworkId withHomeworkState:self.isCheck withStudentList:studentList withCurrenntIndex:0];
//    initWithStudent:(NSString *)studentId withStudentName:(NSString *)studentName withHomeworkId:(NSString *)homeworkId withHomeworkState:(BOOL)isCheck
    [self pushViewController:detail];
}


#pragma mark - request
- (void)feedbackClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    StudentFBViewController * feedbackVC = [[StudentFBViewController alloc]initWithHomeworkId:self.homeworkId];
    [self pushViewController:feedbackVC];
}

- (void)requestHomework:(NSString *)homeworkId  withPracticeType:(NSString *)practiceType{
    NSDictionary * parameterDic = @{@"homeworkId":homeworkId,@"practiceType":practiceType};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkTypeStudents] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkTypeStudents];
}

- (void)requestListHomeworkStudents{
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};

    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListHomeworkStudents] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListHomeworkStudents];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListHomeworkStudents) {
            NSMutableDictionary *infoDic  = [NSMutableDictionary dictionaryWithDictionary:successInfoObj];
            NSMutableArray * tempArray = [NSMutableArray array];
            if ([successInfoObj[@"homeworkItems"] count] == 1) {
                [tempArray addObjectsFromArray:successInfoObj[@"homeworkItems"]];
            }else{
                for (int i = 0; i< [successInfoObj[@"homeworkItems"] count]; i++) {
                    NSDictionary * dic = successInfoObj[@"homeworkItems"][i];
                    if ([dic objectForKey:@"practiceType"]){
                        [tempArray addObject:dic];
                    }
                };
            }
            
            infoDic[@"homeworkItems"] = tempArray;
            strongSelf.listModel = [[CHWListModel alloc]initWithDictionary:@{@"info":successInfoObj} error:nil];
            strongSelf.studentList = successInfoObj[@"homeworkStudents"];
            strongSelf.headerView.listModel = strongSelf.listModel;
            
            [strongSelf customReload];

        }else   if (request.tag == NetRequestType_TeacherRemarkHomework) {
            [strongSelf.checkTipView removeFromSuperview];
            
            if ([successInfoObj[@"coin"] integerValue]>0) {
                // 弹窗
                UIWindow *window =  [[UIApplication sharedApplication].windows objectAtIndex:0];
                weakSelf.tipView = [[[NSBundle mainBundle] loadNibNamed:@"NewRewardDetialTipView" owner:nil options:nil] lastObject];
                weakSelf.tipView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
                weakSelf.tipView.frame = window.bounds;
                [weakSelf.tipView.finishButton addTarget:weakSelf action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [window addSubview:weakSelf.tipView];
                weakSelf.tipView.tipsLabel.text = @"检查作业成功\n恭喜您获得     枚感恩币";
                weakSelf.tipView.countLabel.text = [NSString stringWithFormat:@"%@",successInfoObj[@"coin"]];
            }else{
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"UPDATA_HOMEWORK_LIST_DATA" object:nil];
                [strongSelf rangHelpNotice];
            }
            
        }if (request.tag == NetRequestType_QueryHomeworkTypeStudents) {
            
        }
        
    }];
}

- (void)finishButtonClick:(UIButton *)button{
    [self.tipView removeFromSuperview];
    [self backViewController];
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"ClassChoose" object:nil userInfo:@{@"classId":@"",@"className":@""}];
}

- (void)customReload{
    [self.collectionView reloadData];
    CGFloat contentHeight =  self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    if (![self.onlineHomework boolValue]) {
        self.tableHeaderView.frame = CGRectMake(0, 0, 0, 0);
        self.tableHeaderView.hidden = YES;
        self.bottomScrollView .contentInset = UIEdgeInsetsMake(62, 0, 0, 0);
        self.bottomScrollView.bounces = YES;
    }
    
    self.collectionView.frame = CGRectMake(16, 0, kScreenWidth-32, contentHeight );
    [self.bottomScrollView setContentSize:CGSizeMake(kScreenWidth, contentHeight +16)];
    
    [self.collectionView setCornerRadius:6 withShadow:YES withOpacity:10];
    [self.tableHeaderView.rangBottom setCornerRadius:6 withShadow:YES withOpacity:10];
    [self.headerView.headerView setCornerRadius:54 withShadow:YES withOpacity:10 withAlpha:0.05];
    [self.headerView.headerBottom setCornerRadius:6 withShadow:YES withOpacity:10];
}

- (void)rangHelpNotice{
    UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    UIImageView *noticeView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-148)/2, (kScreenHeight-113)/2, 148, 113)];
    noticeView.image = [UIImage imageNamed:@"6DE32DA4-BCC4-475A-9B9D-9F3D30E63D8A"];
    noticeView.layer.cornerRadius = 6.0;
    noticeView.layer.masksToBounds = YES;
    noticeView.contentMode = UIViewContentModeScaleAspectFill;
    [firstWindow addSubview:noticeView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [noticeView removeFromSuperview];
        
       
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backViewController];
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"ClassChoose" object:nil userInfo:@{@"classId":@"",@"className":@""}];
    });
}

- (void)rangHelpClick:(UIButton *)button{
    UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    [firstWindow addSubview: self.helpDetialView];
}

- (void)gotoCheckHomework{
////////////test
    if (self.detailVCTyp == CheckHomeworkDetailVCType_look){
        
        if (self.isphonicsHomework) {//
            NewCheeckPictureReportVC *detailVC = [[NewCheeckPictureReportVC alloc]initWithHomeworkId:self.homeworkId];
            [self pushViewController:detailVC];
        }else{
            //原来的报告
            HWReportViewController * detailVC = [[HWReportViewController alloc]initWithHomeworkId:self.homeworkId];
            [self pushViewController:detailVC];
        }
        
        
    }else{
        if ([self.listModel.info.sendCoin boolValue]) {//奖惩   [self.listModel.info.sendCoin boolValue]
            NSString * title = [NSString stringWithFormat:@"%@ %@",self.listModel.info.gradeName,self.listModel.info.clazzName];
            NewRewardStudentViewController * rewardVC = [NewRewardStudentViewController new];
        rewardVC.homeworkId = self.homeworkId;
            [self pushViewController:rewardVC];
        }else{
            NSString *tipStr = @"班级学生未全部完成是否确认检查？";
            if ([self.listModel.info.finishedCount integerValue] == [self.listModel.info.studentCount integerValue]) {
                tipStr = @"是否确认检查？";
            }
            UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
            [firstWindow addSubview: self.checkTipView];
            [self.checkTipView.querenButton addTarget:self action:@selector(requestTeacherRemarkHomework) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)requestTeacherRemarkHomework{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRemarkHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRemarkHomework];
}

- (BOOL )getShowBackItem{
    
    return YES;
}
- (BOOL)getNavBarBgHidden{
    
    return YES;
}

- (UIRectEdge)getViewRect{
    return UIRectEdgeNone;
}

- (void)backViewController{
    self.navigationItem.hidesBackButton = NO;
    [super backViewController];
}


-(void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckDetialCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"CheckDetialCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckDetialReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CheckDetialReusableView"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)setupViewControllers{
//
//    [self.listModel.info.homeworkItems enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
//        NSDictionary * tempDic = self.listModel.info.homeworkItems[index];
//
//        NSString * practiceType = @"";
//        NSArray * studentList = nil;
//        if ([tempDic objectForKey:@"practiceType"]) {
//            //布置没有书本的作业
//            if ([[tempDic objectForKey:@"practiceType"] length] == 1) {
//                studentList =  tempDic[@"students"];
//            }else{
//                practiceType = [tempDic objectForKey:@"practiceType"];
//            }
//
//        }else{
//            //
//            studentList =  tempDic[@"students"];
//        }
//
//        [self requestHomework:self.homeworkId withPracticeType:practiceType];
//
//    }];
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSInteger section = [self.studentList count];
//    return section;
//}
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger rows = 0;
//    NSDictionary * sectionDic  = self.studentList[section];
//    rows = [sectionDic[@"students"] count];
//    return rows;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = nil;
//    NSDictionary * sectionDic  = self.studentList[indexPath.section];
//    if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
//        HWUnfinishedCell * tempCell = [tableView dequeueReusableCellWithIdentifier:@"HWUnfinishedCell"];
//        [tempCell setupStudentDic:sectionDic[@"students"][indexPath.row]];
//        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell = tempCell;
//    }else{
//        if ([self.practiceType isEqualToString:@"khlx"]) {
//            //@"课后练习"
//            HWKHLXFinishedCell * tempCell = [tableView dequeueReusableCellWithIdentifier:@"HWKHLXFinishedCell"];
//            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [tempCell setupStudentDic:sectionDic[@"students"][indexPath.row]];
//            cell = tempCell;
//        }else{
//
//            //作业总览  - 教辅   语文点读 在线练习 绘本
//            HWFinishedCell * tempCell = [tableView dequeueReusableCellWithIdentifier:@"HWFinishedCell"];
//            BOOL isJF = NO;
//            if ([self.practiceType isEqualToString:@"jfHomework"]){
//                //教辅
//                isJF = YES;
//            }
//            [tempCell setupStudentDic:sectionDic[@"students"][indexPath.row] withJF:isJF];
//            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            if (self.practiceType && ([self.practiceType isEqualToString:@"ywdd"])) {
//                tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                [tempCell hiddenArrow:YES];
//            }else{
//                tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                [tempCell hiddenArrow:NO];
//            }
//
//            if ([self.practiceType isEqualToString:@"dctx"]||[self.practiceType isEqualToString:@"ldkw"]||[self.practiceType isEqualToString:@"tkwly"]){
//                [tempCell hiddenArrow:YES];
//            }
//
//            cell = tempCell;
//
//        }
//    }
//
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat height = 60;
//    return height;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    CGFloat height =  0;
//    NSDictionary * sectionDic  = self.studentList[section];
//    if ([sectionDic[@"students"] count] > 0) {
//        height = FITSCALE(24);
//    }
//    return  height;
//}
//
//- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * headerView = nil;
//    NSDictionary * sectionDic  = self.studentList[section];
//    if ( !sectionDic[@"students"] || [sectionDic[@"students"] count] == 0) {
//        headerView = [UIView new];
//    }else{
//        HWCompleteStateHeaderV * tempView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HWCompleteStateHeaderV"];
//        NSString * sectionStr = @"";
//        NSInteger number = 0;
//        sectionStr = sectionDic[@"title"] ;
//        number =[sectionDic[@"students"] count];
//        [tempView setupTitleStr:sectionStr withNumber:number];
//        tempView.frame = CGRectMake(0, 0, IPHONE_WIDTH,  FITSCALE(30));
//        headerView = tempView;
//    }
//
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return FITSCALE(0.000001);
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UIView * footerView = [UIView new];
//    return footerView;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
////    if (self.practiceType && self.practiceType.length >0  ) {
////        NSDictionary * sectionDic  = self.studentList[indexPath.section];
////        NSDictionary * studentInfo = sectionDic[@"students"][indexPath.row];
////        if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
////            return;
////        }
////
////        //作业详情
////        if ([self.practiceType isEqualToString:@"zxlx"]){
////            //教辅 课后练习 在线练习
////            NSAssert(studentInfo[@"studentId"], @"学生id 为空");
////            [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
////            //                if ([self.practiceType isEqualToString:@"dctx"]||[self.practiceType isEqualToString:@"ldkw"]||[self.practiceType isEqualToString:@"tkwly"]){
////            //
////            //                }
////        }else if ([self.practiceType isEqualToString:@"jfHomework"] && studentInfo[@"unknowQuestions"] ){
////
////            [self gotoUnOnlineAssistantsQuestionVC:studentInfo[@"studentId"]];
////        }
////
////        else if ([self.practiceType isEqualToString:@"khlx"]){
////
////            [self gotoStudentKHLXHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
////        }else if ([self.practiceType isEqualToString:@"cartoonHomework"]){
////            NSAssert(studentInfo[@"studentId"], @"学生id 为空");
////            [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
////        }else{
////            //        NSDictionary * sectionDic  = self.studentList[indexPath.section];
////            //        NSDictionary * studentInfo = sectionDic[@"students"][indexPath.row];
////            //        if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
////            //            return;
////            //        }
////            //         NSAssert(studentInfo[@"studentId"], @"学生id 为空");
////            //        [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
////        }
////
////    }
//
//
//}
@end
