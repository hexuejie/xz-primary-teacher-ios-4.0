//
//  NewReportPictureProblemTableView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/16.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewReportPictureProblemTableView.h"
#import "NewDetialSoundCollectionViewCell.h"
#import "CheckDetialReusableView.h"
#import "NewReportPictureProblemHeader.h"
#import "NewProblemDetialView.h"

@interface NewReportPictureProblemTableView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NewProblemDetialView *headerDetialView;
@property (strong, nonatomic) NewReportPictureProblemHeader *headerView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSString  * homeworkId;

@property (strong, nonatomic) NSDictionary  *ItemDic;
@property (strong, nonatomic) NSArray  * studentList;

@property (strong, nonatomic) NSArray  *Items;
@property (strong, nonatomic) id playingDic;

@end

@implementation NewReportPictureProblemTableView


- (instancetype)initWithHomeworkId:(NSString *)homeworkId{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationItemTitle:@"发音详情"];
    
    
    [self.view addSubview:self.collectionView];
    [self setupHeaderView];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewDetialSoundCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"NewDetialSoundCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckDetialReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CheckDetialReusableView"];
    
//    Problem
    CGFloat header_y = 200;
    _collectionView.contentInset = UIEdgeInsetsMake(header_y, 0, 0, 0);
    _headerDetialView = [[NewProblemDetialView alloc]initWithFrame:CGRectMake(0, -header_y, kScreenWidth, header_y)];
    [_collectionView addSubview:_headerDetialView];
    [_collectionView setContentOffset:CGPointMake(0, -header_y)];
    UIView *lineVie = [UIView new];
    lineVie.backgroundColor = HexRGB(0xF5F5F5);
    [_headerDetialView addSubview:lineVie];
    [lineVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(_headerDetialView);
        make.height.mas_equalTo(1);
    }];
    
    [self getNetworkData];
}

#pragma mark property
- (void)setupHeaderView{
    _headerView = [[NewReportPictureProblemHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,100)];
    [_headerView configUI:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.chooseTag>=101) {
            _headerView.currnetSelected = self.chooseTag-101;
        }
    });

    UITapGestureRecognizer *circleViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circleViewtapClick:)];
    [_headerView.circleView addGestureRecognizer:circleViewtap];
    
    _headerView.backgroundColor =HexRGB(0xffffff);
    [self.view addSubview:_headerView];
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
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
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight-100 -64);
    }
    return _collectionView;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger section = [self.studentList count];
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger rows = 0;
    NSArray * sectionDic  = self.studentList[section];
    rows = [sectionDic count];
    return rows;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewDetialSoundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewDetialSoundCollectionViewCell" forIndexPath:indexPath];
    cell.backGroundButton.hidden = YES;
    cell.soundCheckUpImage.hidden = YES;
    NSArray * sectionDic  = self.studentList[indexPath.section];
    NSDictionary *tempDic = sectionDic[indexPath.row];
    [cell.headerImage setImageWithURL:[NSURL URLWithString:tempDic[@"avatar"]]];
    cell.nameLabel.text = tempDic[@"name"];
    cell.headerImage.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {  //header
        CheckDetialReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CheckDetialReusableView" forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        header.isFirst = NO;
        header.finishTagTop.constant = 15;
        
        NSArray * sectionDic  = self.studentList[indexPath.section];
        
        if (indexPath.section == 0) {
            header.finishLabel.text = @"答错的人";
        }if (indexPath.section == 1) {
            header.finishLabel.text = @"答对的人";
        }if (indexPath.section == 1) {
            header.finishLabel.text = @"未完成";
        }
        header.allCountLabel.text = [NSString stringWithFormat:@"%@",self.ItemDic[@"studentCount"]];
        header.countLabel.text = [NSString stringWithFormat:@"%ld",sectionDic.count];
        header.lineNid.hidden = YES;
        
        return header;
    }else {  //footer
        return [UICollectionReusableView new];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-50)/5, 90);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 36);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - click
- (void)circleViewtapClick:(UITapGestureRecognizer *)circleViewtap{
    CGPoint point = [circleViewtap locationInView:circleViewtap.view];
    NSInteger tagtag = 0;
    if (point.x<46) {
        tagtag = 0;
    }else if (point.x<46*2+38 && 46+38<point.x) {
        tagtag = 1;
    }else if (point.x<46*3+38*2 && 46*2+38*2<point.x) {
        tagtag = 2;
    }else{
        return;
    }
    _headerView.currnetSelected = tagtag;
    
    [self reloadHeaderBottom];
//    if (self.Items.count>tagtag) {
//        self.ItemDic = self.Items[tagtag];
//    }
}


#pragma mark - request请求
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,@"typeId":@"hbxt"};
    [self sendHeaderRequest:@"QueryPhonicsChildHomeworkReport" parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_PortDetialproblem];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_PortDetialproblem) {
            NSLog(@"%@=-==",successInfoObj);
            weakSelf.Items = successInfoObj[@"list"];
            
            [weakSelf reloadHeaderBottom];
        }
    }];
}

- (void)reloadHeaderBottom{
    
    if (self.Items.count>self.headerView.currnetSelected) {
        self.ItemDic = self.Items[self.headerView.currnetSelected];
        self.headerDetialView.dataDic = self.ItemDic;
        
        CGFloat header_y = [self.headerDetialView heightForHeader] ;
        
        if ([[self.headerDetialView.dataArray firstObject][@"answerType"] isEqualToString:@"font"]) {
            header_y = header_y+ self.headerDetialView.dataArray.count * 44;
        }else{
            header_y = header_y+ self.headerDetialView.dataArray.count * 138;//tupian   138
        }
        
        _collectionView.contentInset = UIEdgeInsetsMake(header_y, 0, 0, 0);
        _headerDetialView.frame = CGRectMake(0, -header_y, kScreenWidth, header_y);
        [_collectionView setContentOffset:CGPointMake(0, -header_y)];
        
        self.studentList = @[self.ItemDic[@"rightStudents"],self.ItemDic[@"errorStudents"],self.ItemDic[@"unfinishStudents"]];
        [self.collectionView reloadData];
    }
}
@end
