//
//  NewReportSoundHomeworkDetailVC.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/15.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewReportSoundHomeworkDetailVC.h"
#import "NewDetialSoundCollectionViewCell.h"
#import "CheckDetialReusableView.h"
#import "NewReportListonTableViewCell.h"
#import "LXReportSoundBottom.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NewReportSoundHomeworkDetailVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSString  * homeworkId;
@property (copy, nonatomic) NSString  * objeId;
@property (strong, nonatomic) NSArray  * studentList;
@property (strong, nonatomic) NSIndexPath *playingDic;
@property (strong, nonatomic) NSDictionary * listDic;
@property (strong, nonatomic) NSString * listCount;

@property (strong, nonatomic) NewReportListonTableViewCell *headerView;
@property (strong, nonatomic) LXReportSoundBottom *bottomView;



@property(nonatomic, strong)  AVPlayer * player;
@property(nonatomic, assign)  BOOL playerState;//是否点击播放
@property(nonatomic, assign)  BOOL playerFinished;//是否播放完成
@end

@implementation NewReportSoundHomeworkDetailVC

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
    
    [self setNavigationItemTitle:@"掌握详情"];
    
    
    [self.view addSubview:self.collectionView];
    [self setupHeaderView];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewDetialSoundCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"NewDetialSoundCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckDetialReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CheckDetialReusableView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

}

- (void)playbackFinished{
    
    self.playerFinished = YES;
    self.playerState = NO;
    
    self.playingDic = nil;
    [self.collectionView reloadData];
}

#pragma mark --- 播放语音
- (void)playVoice{
    NSDictionary *sectionDic = self.studentList[self.playingDic.section];
    NSDictionary *tempDic = sectionDic[@"students"][self.playingDic.row];
    
    NSString * soundStr = tempDic[@"voice"];
    NSURL * url  = [NSURL URLWithString:soundStr];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    if (self.player) {
        if (self.playerFinished) {
            [self currentItemRemoveObserver];
            [self.player replaceCurrentItemWithPlayerItem:songItem];
            [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            self.playerFinished = NO;
        }else{
            [self.player play];
            self.playerState  = YES;
        }
        
    }else{
        self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}
- (void)pause{
    if (self.player) {
        [self.player pause];
        self.player = nil;
        self.playerState  = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:{
                NSLog(@"KVO：未知状态，此时不能播放");
                NSString * content = @"未知状态，此时不能播放";
                [self showAlert:TNOperationState_Fail content:content block:nil];
                
            }
                break;
            case AVPlayerStatusReadyToPlay:{
                [self hideHUD];
                NSLog(@"KVO：准备完毕，可以播放");
                [self.player play];
                self.playerState = YES;
            }
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
            {
                [self hideHUD];
                NSString * content = @"语音播放失败！请稍后再试";
                [self showAlert:TNOperationState_Fail content:content block:nil];
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)currentItemRemoveObserver
{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //    [self.player removeTimeObserver:_timer];
}


#pragma mark property
- (void)setupHeaderView{
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewReportListonTableViewCell class]) owner:nil options:nil].firstObject;
    _headerView.priceLabel1.textColor = HexRGB(0x8A8F99);
    _headerView.priceLabel1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _headerView.priceLabel2.textColor = [UIColor clearColor];
    _headerView.priceLabel3.textColor = [UIColor clearColor];
    _headerView.priceLabel4.textColor = [UIColor clearColor];
    _headerView.backgroundColor =HexRGB(0xF6F6F8);
    _headerView.frame = CGRectMake(0, 0, kScreenWidth,47);
    [self.view addSubview:_headerView];
    
    
    _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LXReportSoundBottom class]) owner:nil options:nil].firstObject;
//   LXReportSoundBottom
    [_bottomView.fontButton addTarget:self action:@selector(fontButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _bottomView.backgroundColor =HexRGB(0xffffff);
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height-46, kScreenWidth,46);
    [self.view addSubview:_bottomView];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadHeaderBottom];
        [self requestListHomeworkStudents];
    });
}

- (void)reloadHeaderBottom{
    if (self.subTitle.length>0) {
        
        
    }
    if (self.Items.count>self.currentSelected) {
        NSDictionary *tempDic = self.Items[self.currentSelected];
        [_headerView.priceLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth-80);
        }] ;
        _headerView.priceLabel1.text = tempDic[@"en"];
        
        _bottomView.pageBottomLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentSelected+1,self.Items.count];
        self.objeId = tempDic[@"id"];
    
        _bottomView.fontButton.selected = NO;
        _bottomView.nextButton.selected = NO;
        if (self.currentSelected == 0) {
            _bottomView.fontButton.selected = YES;
        }else if(self.currentSelected == self.Items.count-1){
            _bottomView.nextButton.selected = YES;
        }
    }
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
        _collectionView.frame = CGRectMake(0, 46, kScreenWidth, kScreenHeight-46-43 -64);
        
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
    NSDictionary * sectionDic  = self.studentList[section];
    rows = [sectionDic[@"students"] count];
    return rows;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewDetialSoundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewDetialSoundCollectionViewCell" forIndexPath:indexPath];
    cell.backGroundButton.hidden = YES;
    cell.soundCheckUpImage.hidden = YES;
    NSDictionary *sectionDic = self.studentList[indexPath.section];
    NSDictionary *tempDic = sectionDic[@"students"][indexPath.row];
    [cell.headerImage setImageWithURL:[NSURL URLWithString:tempDic[@"avatar"]]];
    cell.nameLabel.text = tempDic[@"name"];
    cell.headerImage.backgroundColor = [UIColor clearColor];
    
    if (self.isSound) {
        cell.soundCheckUpImage.hidden = NO;
        
        if (self.playingDic == indexPath) {
            cell.backGroundButton.hidden = NO;
            cell.soundCheckUpImage.image = [UIImage imageNamed:@"report_sound_playing"];
        }else{
            cell.backGroundButton.hidden = YES;
            cell.soundCheckUpImage.image = [UIImage imageNamed:@"report_sound_play"];
        }
    }
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {  //header
        CheckDetialReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CheckDetialReusableView" forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        header.isFirst = NO;
        header.lineNid.hidden = YES;
        header.finishTagTop.constant = 15;
        NSDictionary *sectionDic = self.studentList[indexPath.section];
        header.finishLabel.text = sectionDic[@"title"];
        header.countLabel.text = [NSString stringWithFormat:@"%ld",[sectionDic[@"students"] count]];
        header.allCountLabel.text = [NSString stringWithFormat:@"/%@",self.listCount] ;
        
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
//    if (0) {//最后一个
//        return;
//    }else{
    if (self.isSound) {
        [self pause];
        self.playingDic = indexPath;
        [self.collectionView reloadData];//声音播放
        [self playVoice];
    }
}

#pragma mark - click
- (void)fontButtonClick:(UIButton *)button{
    if (button.selected == YES) {
        return;
    }
    self.currentSelected = self.currentSelected-1;
    [self reloadHeaderBottom];
    [self requestListHomeworkStudents];
}
- (void)nextButtonClick:(UIButton *)button{
    if (button.selected == YES) {
        return;
    }
    self.currentSelected = self.currentSelected+1;
    [self reloadHeaderBottom];
    [self requestListHomeworkStudents];
}
#pragma mark - request

- (void)requestListHomeworkStudents{
    if (!self.objeId) {
        self.objeId = @"";
    }
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,@"typeId":@"hbpy",@"objectId":self.objeId};

    [self  sendHeaderRequest:@"QueryPhonicsChildHomeworkStudents" parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListHomeworkStudents];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListHomeworkStudents) {
            weakSelf.studentList = successInfoObj[@"list"];
            weakSelf.listCount = [NSString stringWithFormat:@"%@",successInfoObj[@"studentCount"]];
            [strongSelf.collectionView reloadData];
            [strongSelf reloadHeaderBottom];
        }
    }];
}

@end
