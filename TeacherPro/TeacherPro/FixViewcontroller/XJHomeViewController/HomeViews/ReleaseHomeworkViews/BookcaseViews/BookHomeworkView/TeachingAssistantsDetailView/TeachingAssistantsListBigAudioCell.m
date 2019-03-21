//
//  TeachingAssistantsListBigAudioCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListBigAudioCell.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
#import "ZFPlayer.h"

@interface  TeachingAssistantsListBigAudioCell()

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) NSMutableArray * urlAudioArray;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property(weak, nonatomic) IBOutlet UIView * lineView;
@end
@implementation TeachingAssistantsListBigAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.timerLabel.textColor = UIColorFromRGB(0x747474);
    self.lineView.backgroundColor = project_line_gray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSMutableArray *)urlAudioArray{
    if (!_urlAudioArray) {
        _urlAudioArray = [NSMutableArray array];
    }
    return _urlAudioArray;
}
- (void)setupModel:(QuestionModel *)model{
    NSInteger timer = 0;
    
    if (model.continuousAudios) {
        for (QuestionAnalysisAudioModel * audioModel in model.continuousAudios) {
            [self.urlAudioArray addObject: audioModel.voice];
            timer = timer  + [audioModel.playTime integerValue];
        }
    }else{
        if (model.singleAudios) {
            for (QuestionAnalysisAudioModel * audioModel in model.singleAudios) {
                [self.urlAudioArray addObject: audioModel.voice];
                timer = timer  + [audioModel.playTime integerValue];
            }
        }
    }
    
    NSInteger second = timer/1000;
    NSString * timerStr = [self getMMSSFromSS:second];
   
    self.timerLabel.text = timerStr;
}

-(NSString *)getMMSSFromSS:(NSInteger )totalTime{
    
    NSInteger seconds = totalTime  ;
    
    //format of hour
//    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}



- (IBAction)playAction:(id)sender {
    if (self.playBlock) {
        self.playBlock(self.urlAudioArray);
    }
}
- (void)setupPlayState:(BOOL)state{
    
    NSString * imageName = @"";
    if (state) {
        imageName = @"play_left_icon_1.png";
    }else{
        imageName = @"play_left_icon.png";
    }
    self.playBtn.selected = state ;
    
}

@end
