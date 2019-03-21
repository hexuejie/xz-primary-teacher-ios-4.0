//
//  NewRewardStudentViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewRewardStudentViewController.h"
#import "CheckDetialRangDetialView.h"

#import "NewRewardDetialCell.h"
#import "NewRewardFooterReusableView.h"
#import "NewRewardHeaderReusableView.h"
#import "NewRewardDetialTipView.h"

@interface NewRewardStudentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) NSDictionary * allRewardData;
@property (nonatomic, strong) NewRewardDetialTipView *tipView;

@property (nonatomic, strong) NewRewardFooterReusableView *indexPath0Footer;
@property (nonatomic, strong) NewRewardFooterReusableView *indexPath1Footer;
@property (nonatomic, strong) NewRewardFooterReusableView *indexPath2Footer;
@property (nonatomic, strong) NewRewardFooterReusableView *indexPath3Footer;
@end

@implementation NewRewardStudentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发放奖惩";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setupBottomView];
    
    UIButton *barQustionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [barQustionButton setImage:[UIImage imageNamed:@"Rectangle 4 CopyQustion"] forState:UIControlStateNormal];
    [barQustionButton addTarget:self action:@selector(showHelpDetialView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barQustionButton];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewRewardDetialCell class]) bundle:nil] forCellWithReuseIdentifier:@"NewRewardDetialCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewRewardHeaderReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewRewardHeaderReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewRewardFooterReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView1"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewRewardFooterReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView2"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewRewardFooterReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView3"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewRewardFooterReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView4"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self navUIBarBackground:8];
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
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-63 -64);
    }
    return _collectionView;
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *tempArray;
    if (section == 0) {//top3Students
        tempArray = self.allRewardData[@"top3Students"];
    }else if (section == 1) {//speedStudents
        tempArray = self.allRewardData[@"speedStudents"];
    }else if (section == 2) {//progressStudents
        tempArray = self.allRewardData[@"progressStudents"];;
    }else if (section == 3) {//unfinishedStudents
        tempArray = self.allRewardData[@"unfinishedStudents"];;;
    }
    return tempArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewRewardDetialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewRewardDetialCell" forIndexPath:indexPath];
    NSArray *tempArray;
    if (indexPath.section == 0) {//top3Students
        tempArray = self.allRewardData[@"top3Students"];
    }else if (indexPath.section == 1) {//speedStudents
        tempArray = self.allRewardData[@"speedStudents"];
    }else if (indexPath.section == 2) {//progressStudents
        tempArray = self.allRewardData[@"progressStudents"];;
    }else if (indexPath.section == 3) {//unfinishedStudents
        tempArray = self.allRewardData[@"unfinishedStudents"];;;
    }
    cell.dataDic = tempArray[indexPath.row];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {  //header
        NewRewardHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewRewardHeaderReusableView" forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.section == 0) {//top3Students
            header.headerLabel.text = @"优秀之星";
        }else if (indexPath.section == 1) {//speedStudents
             header.headerLabel.text = @"速度之星";
        }else if (indexPath.section == 2) {//progressStudents
             header.headerLabel.text = @"进步之星";
        }else if (indexPath.section == 3) {//unfinishedStudents
             header.headerLabel.text = @"未完成";
        }
        return header;
    }else {
        NewRewardFooterReusableView *footer;
        
        
        if (indexPath.section == 0) {
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView1" forIndexPath:indexPath];
            _indexPath0Footer = footer;
            footer.isreward = YES;
        }else if (indexPath.section == 1) {
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView2" forIndexPath:indexPath];
             _indexPath1Footer = footer;
            footer.isreward = YES;
        }else if (indexPath.section == 2) {
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView3" forIndexPath:indexPath];
             _indexPath2Footer = footer;
            footer.isreward = YES;
        }
        if (indexPath.section == 3) {
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewRewardFooterReusableView4" forIndexPath:indexPath];
             _indexPath3Footer = footer;
            footer.isreward = NO;
        }
        
        
        
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-16)/5, 75);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSArray *tempArray;
    if (section == 0) {//top3Students
        tempArray = self.allRewardData[@"top3Students"];
    }else if (section == 1) {//speedStudents
        tempArray = self.allRewardData[@"speedStudents"];
    }else if (section == 2) {//progressStudents
        tempArray = self.allRewardData[@"progressStudents"];;
    }else if (section == 3) {//unfinishedStudents
        tempArray = self.allRewardData[@"unfinishedStudents"];;;
    }if (tempArray.count == 0) {
        return CGSizeMake(kScreenWidth, 0.01);
    }
    return CGSizeMake(kScreenWidth, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    NSArray *tempArray;
    if (section == 0) {//top3Students
        tempArray = self.allRewardData[@"top3Students"];
    }else if (section == 1) {//speedStudents
        tempArray = self.allRewardData[@"speedStudents"];
    }else if (section == 2) {//progressStudents
        tempArray = self.allRewardData[@"progressStudents"];;
    }else if (section == 3) {//unfinishedStudents
        tempArray = self.allRewardData[@"unfinishedStudents"];;;
    }if (tempArray.count == 0) {
        return CGSizeMake(kScreenWidth, 0.01);
    }
    return CGSizeMake(kScreenWidth, 70);
}


- (void)showHelpDetialView{
    UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    CheckDetialRangDetialView *helpDetialView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialRangDetialView class]) owner:nil options:nil].firstObject;
    helpDetialView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    helpDetialView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [firstWindow addSubview: helpDetialView];
}

- (void)getNetworkData{
    [self requestHomeworkStudentScore];
}


- (void)finishAction{
    
    NSMutableArray *studentList = [[NSMutableArray alloc]init];
    NewRewardFooterReusableView *footer =  _indexPath0Footer;
    
    for (int i = 0; i < [self.allRewardData[@"top3Students"] count] ; i++  ) {

        NSDictionary * studentiItem = self.allRewardData[@"top3Students"][i];
        NSString  * remarkStr =  [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"studentId",studentiItem[@"studentId"],@"coin",footer.countStr];
        [studentList addObject:remarkStr];
    }
    
    footer = _indexPath1Footer;
    for (int i = 0; i < [self.allRewardData[@"speedStudents"] count] ; i++  ) {
        
        NSDictionary * studentiItem = self.allRewardData[@"speedStudents"][i];
        NSString  * remarkStr =  [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"studentId",studentiItem[@"studentId"],@"coin",footer.countStr];
        [studentList addObject:remarkStr];
    }
    
    footer = _indexPath2Footer;
    for (int i = 0; i < [self.allRewardData[@"progressStudents"] count] ; i++  ) {
        
        NSDictionary * studentiItem = self.allRewardData[@"progressStudents"][i];
        NSString  * remarkStr =  [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"studentId",studentiItem[@"studentId"],@"coin",footer.countStr];
        [studentList addObject:remarkStr];
    }
    
    footer = _indexPath3Footer;
    for (int i = 0; i < [self.allRewardData[@"unfinishedStudents"] count] ; i++  ) {
        
        NSDictionary * studentiItem = self.allRewardData[@"unfinishedStudents"][i];
        NSString  * remarkStr =  [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"studentId",studentiItem[@"studentId"],@"coin",footer.countStr];
        [studentList addObject:remarkStr];
    }
    
    
    
    NSString * remarkList = [NSString stringWithFormat:@"[%@]",[studentList componentsJoinedByString:@","] ];
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,
                                    @"remarkList":remarkList};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRemarkHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRemarkHomework];
}

- (void)setupBottomView{
    CGFloat bottomHeight = 65;
    
   _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0,  kScreenHeight-bottomHeight, kScreenWidth, bottomHeight)];
    _bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setAdjustsImageWhenHighlighted:NO];
    [sureBtn setTitle:@"" forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"new_bottom_button_background11"] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(16, 4, _bottomView.frame.size.width - 16*2, bottomHeight-4*2);
    
    [sureBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:sureBtn];
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
    
    if (kScreenWidth == 375&&kScreenHeight>667){
        _collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-63 -64 -34-8);
    }
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(@(bottomHeight));
    }];
}



#pragma mark ---
- (void)requestHomeworkStudentScore{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListHomeworkStudentScore] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListHomeworkStudentScore];
    
}
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error{
    
    [super netRequest:request failedWithError:error];
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        if (request.tag == NetRequestType_ListHomeworkStudentScore) {
//            strongSelf.allRewardData = successInfoObj[@"data"];
            weakSelf.allRewardData = successInfoObj;
            [weakSelf.collectionView reloadData];

        }else if (request.tag == NetRequestType_TeacherRemarkHomework) {
            if ([successInfoObj[@"coin"] integerValue]>0) {
                UIWindow *window =  [[UIApplication sharedApplication].windows objectAtIndex:0];
                 weakSelf.tipView = [[[NSBundle mainBundle] loadNibNamed:@"NewRewardDetialTipView" owner:nil options:nil] lastObject];
                weakSelf.tipView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
                weakSelf.tipView.frame = window.bounds;
                [weakSelf.tipView.finishButton addTarget:weakSelf action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [window addSubview:weakSelf.tipView];
                
            
                weakSelf.tipView.countLabel.text = [NSString stringWithFormat:@"%@",successInfoObj[@"coin"]];
            }else{
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"UPDATA_HOMEWORK_LIST_DATA" object:nil];
                [weakSelf rangHelpNotice];
            }
        }
    }];
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
        [self backTwoViewController];
    });
}


- (void)finishButtonClick:(UIButton *)button{
    [self.tipView removeFromSuperview];
    [self backTwoViewController];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"ClassChoose" object:nil userInfo:@{@"classId":@"",@"className":@""}];
}

- (void)backTwoViewController{
    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
    if (index > 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];//
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}


@end
