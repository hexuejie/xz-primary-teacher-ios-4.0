//
//  NewProblemDetialView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/24.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewProblemDetialView.h"
#import "NewProblemPictureItem.h"
#import "NewProblemTextItem.h"
#import "UIImageView+WebCache.h"
#import "NewPersonPromBottom.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NewProblemDetialView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger rightInt;

@property(nonatomic, strong)  AVPlayer * player;
@property(nonatomic, assign)  BOOL playerState;//是否点击播放
@property(nonatomic, assign)  BOOL playerFinished;//是否播放完成
@end

@implementation NewProblemDetialView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.bounces = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        self.tableView.separatorColor = [UIColor clearColor];
        
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewProblemTextItem class]) bundle:nil] forCellReuseIdentifier:@"NewProblemTextItem"];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewProblemPictureItem class]) bundle:nil] forCellReuseIdentifier:@"NewProblemPictureItem"];
//        [self setupSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.dataArray firstObject][@"answerType"] isEqualToString:@"font"]) {
        return 44;
    }
    return 138;//tupian   138
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDic = self.dataArray[indexPath.row];
    if ([tempDic[@"answerType"] isEqualToString:@"font"]) {
        NewProblemTextItem *cell = [ tableView dequeueReusableCellWithIdentifier:@"NewProblemTextItem"];
        cell.titleButton.selected = YES;
        if ([tempDic[@"answer"] boolValue]) {
            cell.titleButton.selected = NO;
            self.rightInt = indexPath.row;
        }
        NSString *strABC;
        if (indexPath.row == 0) {
            strABC = @"A";
        }if (indexPath.row == 1) {
            strABC = @"B";
        }if (indexPath.row == 2) {
            strABC = @"C";
        }if (indexPath.row == 3) {
            strABC = @"D";
        }
        [cell.titleButton setTitle:strABC forState:UIControlStateNormal];
        cell.contentLabel.text = tempDic[@"text"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NewProblemPictureItem *cell = [ tableView dequeueReusableCellWithIdentifier:@"NewProblemPictureItem"];
    cell.titleButtom.selected = YES;
    if ([tempDic[@"answer"] boolValue]) {
        cell.titleButtom.selected = NO;
    }
    NSString *strABC;
    if (indexPath.row == 0) {
        strABC = @"A";
    }if (indexPath.row == 1) {
        strABC = @"B";
    }if (indexPath.row == 2) {
        strABC = @"C";
    }if (indexPath.row == 3) {
        strABC = @"D";
    }
    [cell.titleButtom setTitle:strABC forState:UIControlStateNormal];
    [cell.pictureRight sd_setImageWithURL:[NSURL URLWithString:tempDic[@"image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - layout
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    UIView *backGround = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [self heightForHeader])];
    self.tableView.tableHeaderView = backGround;
    
    
    UIView *anchView;
    anchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [backGround addSubview:anchView];
    
    CGFloat mangar = 16;
    if (_dataDic[@"image"]) {
        self.headerImage = [UIImageView new];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = 4.0;
        [backGround addSubview:self.headerImage];
        [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backGround).offset(mangar);
            make.leading.equalTo(backGround).offset(mangar);
            make.trailing.equalTo(backGround).offset(-mangar);
            make.height.mas_equalTo(124*kCustomFit);
        }];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"image"]]];
        self.headerImage.backgroundColor = [UIColor purpleColor];
        anchView = self.headerImage;
    }
    
    if (_dataDic[@"text"]) {//player
        self.headerTitleLabel = [UILabel new];
        [backGround addSubview:self.headerTitleLabel];
        self.headerTitleLabel.numberOfLines = 0;
        self.headerTitleLabel.font = [UIFont systemFontOfSize:16];
        self.headerTitleLabel.textColor = HexRGB(0x999999);
        [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(anchView.mas_bottom).offset(mangar);
            make.leading.equalTo(backGround).offset(mangar);
            make.trailing.equalTo(backGround).offset(-mangar);
            make.height.mas_equalTo(20);
        }];
//        self.headerTitleLabel.text = [NSString stringWithFormat:@"%@.%@",_dataDic[@"questNo"],_dataDic[@"text"]];
        self.headerTitleLabel.text = [NSString stringWithFormat:@"%@",_dataDic[@"text"]];
        
        anchView = self.headerTitleLabel;
    }
    
    if (_dataDic[@"voice"] ) {//player
        [self.headerTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(52);
        }];
        
        self.headerPlayerButton = [UIButton new];
        [backGround addSubview:self.headerPlayerButton];
        self.headerPlayerButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [self.headerPlayerButton setImage:[UIImage imageNamed:@"audio_play_pause"] forState:UIControlStateSelected];
        [self.headerPlayerButton setImage:[UIImage imageNamed:@"audio_play_play"] forState:UIControlStateNormal];
        [self.headerPlayerButton addTarget:self action:@selector(headerPlayerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerPlayerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerTitleLabel).offset(-2.5);
            make.leading.equalTo(backGround).offset(mangar);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(24);
        }];
    }
    backGround.frame = CGRectMake(0, 0, kScreenWidth, [self heightForHeader]);
    self.dataArray = _dataDic[@"options"];
    [self.tableView reloadData];
    [self layoutFooterView];
}

- (void)layoutFooterView{
    NewPersonPromBottom *ptomBottom = [[[NSBundle mainBundle] loadNibNamed:@"NewPersonPromBottom" owner:nil options:nil] lastObject];;
    ptomBottom.frame = CGRectMake(0, 0, kScreenWidth, 40);//right
    self.tableView.tableFooterView = ptomBottom;
    if (![_dataDic[@"right"] boolValue]) {
        ptomBottom.isTureLabel.text = @"错误";
        ptomBottom.isTureLabel.textColor = HexRGB(0xFF5D46);
    }
    
    NSString *strABC;
    if (self.rightInt == 0) {
        strABC = @"A";
    }if (self.rightInt == 1) {
        strABC = @"B";
    }if (self.rightInt == 2) {
        strABC = @"C";
    }if (self.rightInt == 3) {
        strABC = @"D";
    }
    ptomBottom.chooseLabel.text = strABC;
}

- (CGFloat)heightForHeader{
    CGFloat height = 12;
    CGFloat mangar = 16;
    
    if (_dataDic[@"image"]) {
        height = height+124*kCustomFit +mangar;
    }
    
    if (_dataDic[@"text"]) {//wenz
        CGRect rect = [self.headerTitleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
        if (_dataDic[@"voice"]) {//player
            rect = [self.headerTitleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-16-52, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        }
        height = height+rect.size.height +mangar;
    }
    return height;
}

- (void)headerPlayerButtonClick:(UIButton *)button{
    [self pause];
    self.headerPlayerButton.selected = YES;
    [self playVoice];
}

- (void)playbackFinished{
    
    self.playerFinished = YES;
    self.playerState = NO;
    self.headerPlayerButton.selected = NO;

}
#pragma mark --- 播放语音
- (void)playVoice{
    if (_dataDic[@"voice"] == nil) {
        return;
    }
    
    NSString * soundStr = _dataDic[@"voice"];
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
//                [self.viewController showAlert:TNOperationState_Fail content:content block:nil];
                
            }
                break;
            case AVPlayerStatusReadyToPlay:{
//                [self.viewController hideHUD];
                NSLog(@"KVO：准备完毕，可以播放");
                [self.player play];
                self.playerState = YES;
            }
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
            {
//                [self.viewController hideHUD];
//                NSString * content = @"语音播放失败！请稍后再试";
//                [self.viewController showAlert:TNOperationState_Fail content:content block:nil];
                
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
