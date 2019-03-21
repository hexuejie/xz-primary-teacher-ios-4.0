//
//  PreviewPictureBookAudioViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PreviewPictureBookAudioViewController.h"
#import "SDCycleScrollView.h"
#import "ZFPlayer.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
#import "UIView+add.h"
#import "PrePictureChineseView.h"

@interface PreviewPictureBookAudioViewController ()<ZFPlayerDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) UIView  * bottomView;
@property (nonatomic, strong) NSArray * playArray;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, assign) NSInteger  playPageNo;//页
@property (nonatomic, assign) NSInteger  playItem;//句
@property (nonatomic, strong) SDCycleScrollView *cycleImgV;
@property (nonatomic, strong) UIButton * playBtn;
@property (nonatomic, assign) BOOL isShowTranslation;//是否显示翻译
@property (nonatomic, assign) BOOL isContinuousPlay;//是否连续播放
@property (nonatomic, strong) UILabel *translationLabel;//翻译视图
@property (nonatomic, strong) UILabel *pageNumberLabel;//页数

@property (nonatomic, strong) PrePictureChineseView *ChineseView;
@end

@implementation PreviewPictureBookAudioViewController
- (instancetype)initWithName:(NSString *)pictureTitle withData:(NSArray *)playArray{
    self = [super init];
    if (self) {
        self.titleStr = pictureTitle;
        self.playArray = playArray;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:self.titleStr];
    [self setupImgVScroll];
    [self setupPlayView];
    [self setupTranslationView];
    [self setupPageNumberView];
    self.playPageNo =  1;
    self.playItem =  1;
    self.isContinuousPlay = NO;
    
    _ChineseView = [[[NSBundle mainBundle] loadNibNamed:@"PrePictureChineseView" owner:nil options:nil] lastObject];
    
    if (kScreenWidth == 375&&kScreenHeight>667){
        self.pageNumberLabel.frame = CGRectMake(ScreenWidth-46-16 ,16+18, 46,20);
        
        _bottomView.frame = CGRectMake(0, self.view.frame.size.height- 120-20, self.view.frame.size.width, 120);
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"index ===%zd",index);
       [self stopPlayer];
    if (index != 0) {
     
        self.playPageNo = index+1;
        self.playItem = 1;
        self.playBtn.selected = YES;
        NSURL * playurl = [NSURL URLWithString:[self getUrl]];
        [self playerAudio:playurl];
        
        if (playurl == nil) {
//            [SVProgressHelper dismissWithMsg:@"暂无音频资源"];
            self.playBtn.selected = NO;
        }
    }else{
        self.playPageNo =  1;
        self.playItem =  1;
        self.playBtn.selected = NO;
    }
    [self updateShowTranslation];
    [self updatePageNumber];
    
    NSDictionary *pageDic =  self.playArray[self.playPageNo-1];
    if ([pageDic[@"sentences"] count]>self.playItem -1) {
        NSDictionary * itemDic = pageDic[@"sentences"][self.playItem -1];
        _ChineseView.contentLabel.text = itemDic[@"cn"];
        
//        NSString *strstr;
//        for (NSDictionary *tempDic in sentencesArray) {
//            if (strstr) {
//                strstr = [NSString stringWithFormat:@"%@\n%@",strstr,tempDic[@"en"]];
//            }else{
//                strstr = tempDic[@"en"];
//            }
//        }
//        _contentLabel.text = strstr;
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
 
    [self.playerView resetPlayer];
}
//显示页
- (void)setupPageNumberView{
    self.pageNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-46-16 ,16, 46,20)];
    self.pageNumberLabel.backgroundColor = HexRGB(0xEBEBEB);
    self.pageNumberLabel.textColor = UIColorFromRGB(0x8A8F99);
    self.pageNumberLabel.font = systemFontSize(14);
    self.pageNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.pageNumberLabel.numberOfLines = 1;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%zd/%zd",1,[self.playArray count]];
    [self.view addSubview:self.pageNumberLabel];
    
    
}


//翻译
- (void)setupTranslationView{
   
    self.translationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.bottomView.frame), self.view.frame.size.width-20,0)];
    self.translationLabel.backgroundColor = [UIColor clearColor];
    self.translationLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.translationLabel.font = fontSize_14;
    self.translationLabel.textAlignment = NSTextAlignmentCenter;
    self.translationLabel.numberOfLines = 0;
    [self.view addSubview:self.translationLabel];
    
}
//滚动视图
- (void)setupImgVScroll{
    CGFloat bottomViewHeight = 120;
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.playArray) {
        NSString *imageUrl = dic[@"image"];
        [imagesURLStrings addObject:imageUrl];
    }

    if (kScreenWidth == 375&&kScreenHeight>667){
        self.cycleImgV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 48+18, [UIScreen mainScreen].bounds.size.width, 374+116) delegate:nil placeholderImage:nil];
    }else{
        self.cycleImgV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 48, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - bottomViewHeight - 40  +40) delegate:nil placeholderImage:nil];
    }
   
    
    self.cycleImgV.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleImgV.imageURLStringsGroup = imagesURLStrings;
    self.cycleImgV.autoScroll = NO;
    self.cycleImgV.showPageControl = NO;
    self.cycleImgV.titlesGroup = nil;///  歌词
    self.cycleImgV.isChinese = YES;
    self.cycleImgV.delegate = self;
    self.cycleImgV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.cycleImgV];
    self.view.backgroundColor = project_background_gray;
    
    self.cycleImgV.dataArray = self.playArray;
    self.cycleImgV.totalItemsCount = self.playArray.count;
    self.cycleImgV.tag = 998;
    [self.cycleImgV.mainView reloadData];
    
    if (self.playArray.count>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.cycleImgV.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        });
    }
    
//    [self.cycleImgV setCornerRadius:4 withShadow:YES withOpacity:10];
}

//播放视图
- (void)setupPlayView{

    [self.view addSubview:self.bottomView];
    
    CGFloat btnW = self.bottomView.frame.size.height;
    CGFloat btnH = self.bottomView.frame.size.height;
    
    self.playBtn = [UIButton buttonWithType: UIButtonTypeCustom];
  
    [self.playBtn setImage:[UIImage imageNamed:@"播放1.png"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [self.playBtn setFrame:CGRectMake(self.bottomView.center.x- btnW/2 , 0, btnW, btnH+5)];
    [ self.playBtn  setTitleColor:project_main_blue forState:UIControlStateNormal];
    [ self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview: self.playBtn];
    
    
    UIButton * preBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [preBtn setFrame:CGRectMake(20, 0, btnW,btnH)];
    [preBtn  setTitleColor:project_main_blue forState:UIControlStateNormal];
    [preBtn setImage:[UIImage imageNamed:@"翻译"] forState:UIControlStateNormal];
    [preBtn setImage:[UIImage imageNamed:@"翻译 选中"] forState:UIControlStateSelected];
   [preBtn addTarget:self action:@selector(preAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:preBtn];
//    self.cycleImgV.isChinese = YES;
    
    
    UIButton * nextBtn = [UIButton buttonWithType: UIButtonTypeCustom];
 
    [nextBtn setImage:[UIImage imageNamed:@"自动播放"] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"自动播放 选中"] forState:UIControlStateSelected];
    [nextBtn  setTitleColor:project_main_blue forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(self.bottomView.frame.size.width - 20 - btnW, 0, btnW,btnH)];
    [nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:nextBtn];
  
  
//    PrePictureChineseView
}

- (UIView *)bottomView{
    if (!_bottomView) {
        CGFloat bottomViewHeight = 120;
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- bottomViewHeight, self.view.frame.size.width, bottomViewHeight)];
//        _bottomView.backgroundColor = [UIColor redColor];
    }
    return _bottomView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


//更新页
- (void)updatePageNumber{
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.playPageNo,[self.playArray count]];
}
//更新显示最新翻译
- (void)updateShowTranslation{
    NSArray * sectionArray = self.playArray[self.playPageNo -1][@"section"];
    NSDictionary * itemDic = sectionArray[self.playItem -1];
    NSString * cn = itemDic[@"cn"];
    self.translationLabel.text = cn;
    CGFloat translationH = 0;
    if (self.isShowTranslation) {
        translationH  = [ProUtils heightForString:self.translationLabel.text andWidth:self.translationLabel.frame.size.width ];
    }
    self.translationLabel.frame = CGRectMake(self.translationLabel.frame.origin.x, CGRectGetMinY(self.bottomView.frame)- translationH,self.translationLabel.frame.size.width , translationH);
}

#pragma mark ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)translationAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    self.isShowTranslation = sender.selected;

    [self updateShowTranslation];
 
}

- (void)continuousAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    self.isContinuousPlay = sender.selected;
    //如果连续播放打开就开始播放
    if (self.isContinuousPlay) {
       NSURL * playurl = [NSURL URLWithString:[self getUrl]];
        [self playerAudio:playurl];
        self.playBtn.selected = YES;
    }
    
}

//下一页
- (void)nextAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    self.isContinuousPlay = sender.selected;
    if (self.isContinuousPlay) {
        [SVProgressHelper dismissWithMsg:@"自动播放"];
    }else{
        [SVProgressHelper dismissWithMsg:@"取消自动播放"];
    }
    
    
//    //如果连续播放打开就开始播放
//    if (self.isContinuousPlay) {
//        NSURL * playurl = [NSURL URLWithString:[self getUrl]];
//        [self playerAudio:playurl];
//        self.playBtn.selected = YES;
//    }
    
//    [self stopPlayer];
//    self.playItem = 1;
//    self.playPageNo ++;
//    if (self.playPageNo > [self.playArray count]) {
//        self.playPageNo =  1;
//        [self.cycleImgV touchScrollToIndex:0];
//        self.playBtn.selected = NO;
//    }else{
//
//       [self.cycleImgV touchScrollToIndex: (int)self.playPageNo-1];
//
//        self.playBtn.selected = YES;
//        NSURL * playurl = [NSURL URLWithString:[self getUrl]];
//        [self playerAudio:playurl];
//    }
//
//    [self updateShowTranslation];
//    [self updatePageNumber];
//
}

//上一页
- (void)preAction:(UIButton *)sender{
     UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    
    NSDictionary *pageDic =  self.playArray[self.playPageNo-1];
    if ([pageDic[@"sentences"] count]>self.playItem -1) {
        NSDictionary * itemDic = pageDic[@"sentences"][self.playItem -1];
        _ChineseView.contentLabel.text = itemDic[@"cn"];
    }
    if (_ChineseView.contentLabel.text.length == 0) {
        [SVProgressHelper dismissWithMsg:@"暂无翻译"];
        return;
    }
    _ChineseView.bgButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [firstWindow addSubview:_ChineseView];
    _ChineseView.frame = firstWindow.bounds;
    
   
    
    
//    [self stopPlayer];
//
//    self.playPageNo --;
//    self.playItem = 1;
//    if (self.playPageNo == 0||self.playPageNo == 1) {
//        self.playPageNo = 1;
//        self.playBtn.selected = NO;
//        [self.cycleImgV touchScrollToIndex: 0];
//    }else{
//
//        [self.cycleImgV touchScrollToIndex:  (int)self.playPageNo -1];
//        self.playBtn.selected = YES;
//        NSURL * playurl = [NSURL URLWithString:[self getUrl]];
//        [self playerAudio:playurl];
//
//    }
//    [self updateShowTranslation];
//    [self updatePageNumber];
    
}
- (void)playAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.playerView.isPauseByUser) {
            [self restorePlayer];
        }else{
            //本地音频url
            NSURL * playurl = [NSURL URLWithString:[self getUrl]];
            if (playurl == nil) {
                [SVProgressHelper dismissWithMsg:@"暂无音频资源"];
                sender.selected = NO;
            }
            [self playerAudio:playurl];
        }
       
    }else{
        
        [self suspendedPlayer];
        
    }
    
}


- (NSString *)getUrl{
    
    NSDictionary *pageDic =  self.playArray[self.playPageNo-1];
    if ([pageDic[@"sentences"] count]>self.playItem -1) {
        NSDictionary * itemDic = pageDic[@"sentences"][self.playItem -1];
        NSString * url  = itemDic[@"voice"];
        return url;
    }else{
        //暂无音频
        return nil;
    }
}
- (void)playerAudio:(NSURL *)url{
    
    //   URL
    NSURL *videoURL = url;
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.videoURL         = videoURL;
    
    [self.playerView playerControlView:[UIView new] playerModel:playerModel playerView:[UIView new] ];
    // 下载功能
    self.playerView.hasDownload = NO;
    
    [self.playerView hiddenContentView];
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
}

//停止播放
- (void)stopPlayer{
    [self.playerView resetPlayer];
}
//暂停播放
- (void)suspendedPlayer{
    
    NSLog(@"----暂停");
    [self.playerView pause];
}

//恢复播放
-(void)restorePlayer{
    NSLog(@"----恢复");
    [self.playerView play];
}
#pragma mark ----

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        ZFPlayerShared.isLockScreen = YES;
    }
    return _playerView;
}

/**播放完成 调用js方法*/
- (void)zf_playerItemPlayerComplete{
   
     [self stopPlayer];
    
    //播放最后一页的最后一个音频  停止播放
    if (self.playPageNo == [self.playArray count] ) {
         self.playItem++;
        if (self.playItem > [self.playArray[self.playPageNo-1][@"section"] count]) {
            self.playPageNo = 1;
            self.playItem = 1;
            //        [self.cycleImgV scrollToIndex:(int)self.playPageNo-1];
            [self.cycleImgV automaticScroll];
            
            self.playBtn.selected = NO;
        }else{
            //播放当前页面的语句
            NSURL * playurl = [NSURL URLWithString:[self getUrl]];
            [self playerAudio:playurl];
        }
         
       
    }else{
        self.playItem++;
        //播放下一页的第一个音频
        if (self.playItem > [self.playArray[self.playPageNo-1][@"section"] count]) {
            self.playItem = 1;
            //连续播放
            if (self.isContinuousPlay) {
                self.playPageNo++;
//                [self.cycleImgV scrollToIndex:(int)self.playPageNo-1];
                [self.cycleImgV automaticScroll];
//                NSURL * playurl = [NSURL fileURLWithPath: [self getUrl]];
//                [self playerAudio:playurl];
                
            }else{
               //不连续播放
                 self.playBtn.selected = NO;
            }
            
        }else{
            //播放当前页面的语句
            NSURL * playurl = [NSURL URLWithString:[self getUrl]];
            [self playerAudio:playurl];
            
        }
        
    }
     [self updateShowTranslation];
     [self updatePageNumber];
}
- (void)zf_playerItemStatusFailed:(NSError *)error{
        NSString * content = @"语音播放失败！请稍后再试";
    NSLog(@"%@===content",content);
}
@end
