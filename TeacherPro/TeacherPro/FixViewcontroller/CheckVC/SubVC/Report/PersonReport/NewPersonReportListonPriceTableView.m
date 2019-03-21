//
//  NewPersonReportListonPriceTableView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/18.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewPersonReportListonPriceTableView.h"
#import "NewReportListonTableViewCell.h"
#import "NewPersonReportHeader.h"
#import "UIImageView+WebCache.h"
#import "NewPersonReportItemCell.h"
#import "NewPersonReportItemHeader.h"
#import "NewPersonReportBottom.h"
#import "NewPersonProblemDetialVC.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NewPersonReportListonPriceTableView (){
    CGFloat _gradientProgress;
}


@property(nonatomic, strong) NewPersonReportHeader *headerHeader;

@property(nonatomic, copy) NSString * homeworkId;

@property(nonatomic, strong) NSDictionary *allDataDic;

@property(nonatomic, assign) BOOL unionUnit;//ture只有一个列表
@property(nonatomic, strong) NSArray *titleArray;//ture只有一个列表
@property(nonatomic, strong) UITableViewCell *bottomCell;

@property(nonatomic, strong) NSDictionary * parameterDic;

@property(nonatomic, strong)  AVPlayer * player;
@property(nonatomic, assign)  BOOL playerState;//是否点击播放
@property(nonatomic, assign)  BOOL playerFinished;//是否播放完成

@property(nonatomic, assign)  NSInteger playerTag;//是否播放完成
@end

@implementation NewPersonReportListonPriceTableView

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
    [self setNavigationItemTitle:@"听力练习"];
    
    [self registerCell];
    self.tableView.backgroundColor = HexRGB(0xffffff);
    self.tableView.allowsSelection = NO;
    
    [self getNetworkData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    self.playerTag = -1;
}
- (void)playbackFinished{
    
    self.playerFinished = YES;
    self.playerState = NO;
    
    self.playerTag = -1;
    [self.tableView reloadData];
}

#pragma mark - request请求
- (void)getNetworkData{
    //7cf0499d3f2e487f9950fed123ecda81   7cf0499d3f2e487f9950fed123ecda80
//    self.homeworkId
    _parameterDic = @{@"homeworkId":self.homeworkId,@"studentId":self.personDic[@"studentId"]};
    [self sendHeaderRequest:@"QueryStudentPhonicsHomeworkScore" parameterDic:_parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_PersonReport];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_PersonReport) {
            NSLog(@"%@=-==",successInfoObj);
            weakSelf.allDataDic = successInfoObj;
            weakSelf.unionUnit = [successInfoObj[@"unionUnit"] boolValue];
            if ([successInfoObj[@"words"] count]) {
                weakSelf.titleArray = [[successInfoObj[@"words"] firstObject] allKeys];
            }
            
            
            [strongSelf setupHeaderView];
            [strongSelf updateTableView];
        }
    }];
}

#pragma mark - layout
- (void)setupHeaderView{
    
    UIView *headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 108)];
    
    self.tableView.tableHeaderView = headerBackView;
    
    _headerHeader = [[[NSBundle mainBundle] loadNibNamed:@"NewPersonReportHeader" owner:nil options:nil] lastObject];
    _headerHeader.contentView.frame = CGRectMake(0, 0, kScreenWidth, 108);
    [headerBackView addSubview:_headerHeader];
    
    
    if (self.unionUnit) {//46 +108
        headerBackView.frame = CGRectMake(0, 0, kScreenWidth, 108 +46);
        NewReportListonTableViewCell *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewReportListonTableViewCell class]) owner:nil options:nil].firstObject;
        headerView.priceLabel1.textColor = HexRGB(0x8A8F99);
        headerView.priceLabel2.textColor = HexRGB(0x8A8F99);
        headerView.priceLabel3.textColor = HexRGB(0x8A8F99);
        headerView.priceLabel4.textColor = HexRGB(0x8A8F99);
        headerView.priceLabel1.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        headerView.priceLabel2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        headerView.priceLabel3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        headerView.priceLabel4.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        headerView.backgroundColor =HexRGB(0xF6F6F8);
        headerView.frame = CGRectMake(0, 108, self.view.frame.size.width,47);
        [headerBackView addSubview:headerView];
        
        if (self.titleArray.count == 3) {
            headerView.priceLabel3.text = @"";
            headerView.priceMidWidth.constant = 22;
            headerView.priceLabel2.text = @"Listen";
            headerView.priceLabel4.text = @"Write";
        }if (self.titleArray.count == 4) {
            headerView.priceLabel2.text = @"Read";
            headerView.priceLabel3.text = @"Listen";
            headerView.priceLabel4.text = @"Write";
        }
    }
}

- (void)setAllDataDic:(NSDictionary *)allDataDic{
    _allDataDic = allDataDic;
    if (!_headerHeader) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_allDataDic) {
            _headerHeader.subTitleLabel.text = _allDataDic[@"bookName"];
            _headerHeader.unitLabel.text = _allDataDic[@"unitName"];
        }
        
        if (_personDic) {
            NSString * avatar = _personDic[@"avatar"];
            NSString * placeholderImgName = @"";
            if ([_personDic[@"sex"] isEqualToString:@"female"]) {
                placeholderImgName =  @"student_wuman";
            }else if ([_personDic[@"sex"] isEqualToString:@"male"]){
                placeholderImgName =  @"student_man";
            }else{
                placeholderImgName =  @"student_wuman";
            }
            [_headerHeader.headerLogo sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:  [UIImage imageNamed:placeholderImgName]];
            _headerHeader.nameLabel.text = _personDic[@"studentName"];
        }
    });
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewReportListonTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"NewReportListonTableViewCell"];//NewPersonReportItemCell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewPersonReportItemCell class]) bundle:nil] forCellReuseIdentifier:@"NewPersonReportItemCell"];//NewPersonReportBottom
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewPersonReportBottom class]) bundle:nil] forCellReuseIdentifier:@"NewPersonReportBottom"];//
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewPersonReportItemHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"NewPersonReportItemHeader"];//
}


#pragma mark - degete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.unionUnit) {
        return 1;
    }else if ([self.allDataDic[@"bookHhomeworkTypes"] isKindOfClass:[NSArray class]]){
        return [self.allDataDic[@"bookHhomeworkTypes"] count] +[self.allDataDic[@"cartoonHomeworkTypes"] count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.unionUnit) {
        return  [self.allDataDic[@"words"] count];
    }else{
        NSInteger firstCount = [self.allDataDic[@"bookHhomeworkTypes"] count];
        NSInteger secondCount = [self.allDataDic[@"cartoonHomeworkTypes"] count];
        if (section<firstCount) {
             return [self.allDataDic[@"bookHhomeworkTypes"][section][@"words"] count];
        }else if (section< firstCount+secondCount) {
            NSDictionary *sectionDic = self.allDataDic[@"cartoonHomeworkTypes"][section-firstCount];
            if ([sectionDic[@"title"] isEqualToString:@"绘本练习"]) {
                return 1;
            }
            return [sectionDic[@"sentences"] count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.unionUnit) {
        return 47;
    }else{
        NSInteger firstCount = [self.allDataDic[@"bookHhomeworkTypes"] count];
        NSInteger secondCount = [self.allDataDic[@"cartoonHomeworkTypes"] count];
        if (indexPath.section<firstCount) {
            return 18+16;
        }else if (indexPath.section< firstCount+secondCount) {
            NSDictionary *sectionDic = self.allDataDic[@"cartoonHomeworkTypes"][indexPath.section-firstCount];
            if ([sectionDic[@"title"] isEqualToString:@"绘本练习"]) {
                return 80;
            }
            return 18+16;
        }
    }

    return 18+16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.unionUnit) {//46 +108
        NewReportListonTableViewCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"NewReportListonTableViewCell" forIndexPath:indexPath];
        cell.priceLabel1.textColor = HexRGB(0x808080);
        cell.priceLabel1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        
        
        NSDictionary *tempDic = self.allDataDic[@"words"][indexPath.row];
        
        cell.priceLabel1.text = tempDic[@"en"];
        if (self.titleArray.count == 3) {
            cell.priceLabel3.text = @"";
            cell.priceMidWidth.constant = 22;

            [self setPriceLabelContent:cell.priceLabel2 text:tempDic[@"Listen"]];
            [self setPriceLabelContent:cell.priceLabel4 text:tempDic[@"Write"]];
            
        }if (self.titleArray.count == 4) {

            [self setPriceLabelContent:cell.priceLabel2 text:tempDic[@"Read"]];
            [self setPriceLabelContent:cell.priceLabel3 text:tempDic[@"Listen"]];
            [self setPriceLabelContent:cell.priceLabel4 text:tempDic[@"Write"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        NewPersonReportItemCell  *cell;
        
        NSInteger firstCount = [self.allDataDic[@"bookHhomeworkTypes"] count];
        NSInteger secondCount = [self.allDataDic[@"cartoonHomeworkTypes"] count];
        NSDictionary *sectionDic;
        NSDictionary *tempDic;
        
        if (indexPath.section<firstCount) {
            cell =  [tableView dequeueReusableCellWithIdentifier:@"NewPersonReportItemCell" forIndexPath:indexPath];
            sectionDic = self.allDataDic[@"bookHhomeworkTypes"][indexPath.section];
            tempDic = sectionDic[@"words"][indexPath.row];
            cell.chooseBackView.hidden = NO;
            
        }else if (indexPath.section< firstCount+secondCount) {
            sectionDic = self.allDataDic[@"cartoonHomeworkTypes"][indexPath.section-firstCount];
            
            if ([sectionDic[@"title"] isEqualToString:@"绘本练习"]) {///最后i一个
                NewPersonReportBottom  *bottomCell =  [tableView dequeueReusableCellWithIdentifier:@"NewPersonReportBottom" forIndexPath:indexPath];
                NSArray *cartoonPractices = sectionDic[@"cartoonPractices"];
                
                bottomCell.bottomButton3.hidden = YES;
                bottomCell.bottomButton2.hidden = YES;
                bottomCell.bottomButton1.hidden = YES;
                bottomCell.layerView1.hidden = YES;
                bottomCell.layerView2.hidden = YES;
                bottomCell.layerView3.hidden = YES;
                bottomCell.bottomButton3.selected = NO;
                bottomCell.bottomButton2.selected = NO;
                bottomCell.bottomButton1.selected = NO;
                if (cartoonPractices.count > 0) {
                    bottomCell.layerView1.hidden = NO;
                    bottomCell.bottomButton1.hidden = NO;
                    [bottomCell.bottomButton1 setTitle:cartoonPractices[0][@"questNo"] forState:UIControlStateNormal];
                    bottomCell.bottomButton1.selected = [cartoonPractices[0][@"right"] boolValue];
                    
                    if (cartoonPractices.count > 1) {
                        bottomCell.layerView2.hidden = NO;
                        bottomCell.bottomButton2.hidden = NO;
                        [bottomCell.bottomButton2 setTitle:cartoonPractices[1][@"questNo"] forState:UIControlStateNormal];
                        bottomCell.bottomButton2.selected = [cartoonPractices[1][@"right"] boolValue];
                        
                        if (cartoonPractices.count > 2) {
                            bottomCell.layerView3.hidden = NO;
                            bottomCell.bottomButton3.hidden = NO;
                            [bottomCell.bottomButton3 setTitle:cartoonPractices[2][@"questNo"] forState:UIControlStateNormal];
                            bottomCell.bottomButton3.selected = [cartoonPractices[2][@"right"] boolValue];
                        }
                    }
                }
             
                
                [bottomCell.bottomButton1 addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [bottomCell.bottomButton2 addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [bottomCell.bottomButton3 addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                return bottomCell;
            }
            cell =  [tableView dequeueReusableCellWithIdentifier:@"NewPersonReportItemCell" forIndexPath:indexPath];
            cell.chooseBackView.hidden = YES;
            tempDic = sectionDic[@"sentences"][indexPath.row];
        }
        
        cell.titleLabel.text = tempDic[@"en"];
        if ([tempDic[@"voice"] length]>0) {
            cell.leftPlayerButton.hidden = NO;
            cell.leftPlayerButton.tag = indexPath.row;
            cell.leftPlayerButton.selected = NO;
            if (indexPath.row == self.playerTag) {
                cell.leftPlayerButton.selected = YES;
            }
            [cell.leftPlayerButton addTarget:self action:@selector(voicePlayerClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.leftPlayerButton.hidden = YES;
        }
        cell.chooseButton1.selected = NO;
        cell.chooseButton2.selected = NO;
        cell.chooseButton3.selected = NO;
        if ([tempDic[@"masteLevel"] isEqualToString:@"Perfect"]) {
            cell.chooseButton1.selected = YES;
        }else if ([tempDic[@"masteLevel"] isEqualToString:@"Good"]) {
            cell.chooseButton2.selected = YES;
        }else if ([tempDic[@"masteLevel"] isEqualToString:@"Fail"]) {
            cell.chooseButton3.selected = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    return [UITableViewCell new];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.unionUnit) {
        return nil;
    }else{
        NSInteger firstCount = [self.allDataDic[@"bookHhomeworkTypes"] count];
        NSInteger secondCount = [self.allDataDic[@"cartoonHomeworkTypes"] count];
        
        NewPersonReportItemHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NewPersonReportItemHeader"];
        header.frame = CGRectMake(0, 0, kScreenWidth, 8+44+9);
        header.gradeTipLabel.hidden = NO;
        header.gradeLabel.hidden = NO;
        header.titleStarBottom.hidden = NO;
        header.levelbackground.hidden = NO;
       
        if (section<firstCount) {//听和读
            NSDictionary *sectionDic = self.allDataDic[@"bookHhomeworkTypes"][section];
            header.titleLabel.text = sectionDic[@"title"];
            header.gradeLabel.text = [NSString stringWithFormat:@""];
            
            header.starButton1.selected = NO;
            header.starButton2.selected = NO;
            header.starButton3.selected = NO;
            header.starButton4.selected = NO;
            header.starButton5.selected = NO;
            NSInteger scoreInt = [sectionDic[@"score"] integerValue];
            if (scoreInt>=20) {
                header.starButton1.selected = YES;
                if (scoreInt>=40) {
                    header.starButton2.selected = YES;
                    if (scoreInt>=60) {
                        header.starButton3.selected = YES;
                        if (scoreInt>=80) {
                            header.starButton4.selected = YES;
                            if (scoreInt>=100) {
                                header.starButton5.selected = YES;
                                
                            }
                        }
                    }
                }
            }
            
        }else if (section< firstCount+secondCount) {
            NSDictionary *sectionDic = self.allDataDic[@"cartoonHomeworkTypes"][section-firstCount];
            header.titleLabel.text = sectionDic[@"title"];
            header.titleStarBottom.hidden = YES;
            header.levelbackground.hidden = YES;
            header.gradeLabel.text = [NSString stringWithFormat:@"%@",sectionDic[@"scoreLevel"]];
            
            if ([sectionDic[@"title"] isEqualToString:@"绘本练习"]) {//最后一个
                header.gradeTipLabel.hidden = YES;
                header.gradeLabel.hidden = YES;
                header.titleStarBottom.hidden = YES;
                header.levelbackground.hidden = YES;
            }
        }
        header.contentView.backgroundColor = [UIColor whiteColor];
        return header;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.unionUnit) {
        return 0.001;
    }
    return 8+44+9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (void)setPriceLabelContent:(UILabel *)label text:(NSString *)string{
    BOOL isMaster = [string boolValue];
    if (isMaster) {
        label.text = @"已掌握";
        label.textColor = HexRGB(0x525B66);
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }else{
        label.text = @"未掌握";
        label.textColor = HexRGB(0xA1A7B3);
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    }
}

- (void)bottomButtonClick:(UIButton *)button{
    //    绘本练习跳转
    //    1000
    NewPersonProblemDetialVC *problemDetialVC = [NewPersonProblemDetialVC new];
    problemDetialVC.parameterDic = self.parameterDic;
    problemDetialVC.currentSelected = button.tag - 1000;
    [self pushViewController:problemDetialVC];
}
- (void)voicePlayerClick:(UIButton *)button{//播放
    [self pause];
    self.playerTag = button.tag;
    [self.tableView reloadData];
    [self playVoice];
}

#pragma mark --- 播放语音
- (void)playVoice{

    NSDictionary *sectionDic;
    NSDictionary *tempDic;
    
   if ([self.allDataDic[@"cartoonHomeworkTypes"] count]>0) {
       sectionDic = self.allDataDic[@"cartoonHomeworkTypes"][0];
       if ([sectionDic[@"sentences"] count]>self.playerTag) {
           tempDic = sectionDic[@"sentences"][self.playerTag];
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
@end
