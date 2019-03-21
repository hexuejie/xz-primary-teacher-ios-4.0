
//
//  HomewrokProblemsDetailHeaderSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsDetailHeaderSectionView.h"
#import "PublicDocuments.h"
#import "HomeworkProblemsDetailListModel.h"

@interface HomeworkProblemsDetailHeaderSectionView()
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *chooseItemNumberLabel;

@end
@implementation HomeworkProblemsDetailHeaderSectionView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupSubview];
}
- (void)setupSubview{
    self.bottomLineV.backgroundColor = project_line_gray;
    self.unitNameLabel.textColor = UIColorFromRGB(0x8B8B8B);
    self.unitNameLabel.font = fontSize_13;
    self.detailLabel.textColor = UIColorFromRGB(0x8B8B8B);
    self.detailLabel.font = fontSize_13;
    self.topLine.backgroundColor = project_line_gray;
    [self.selectedBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseItemNumberLabel.textColor = UIColorFromRGB(0x8B8B8B);
     self.chooseItemNumberLabel.font = fontSize_12;
}
- (void)btnAction:(UIButton *)btn{
    [self setupSelectedTotailBtnState:!btn.selected];
    if (self.btnBlock) {
        self.btnBlock(btn.selected,self.section);
    }
}
- (void)setupSelectedTotailBtnState:(BOOL)state{
    
    self.selectedBtn.selected = state;
    if (state) {
        self.selectedBtn.backgroundColor = UIColorFromRGB(0xF99F1C);
    }else{
        self.selectedBtn.backgroundColor = project_main_blue;
    }
 
}
- (void)setupUnitModel:(HomeworkProblemsDetailModel *) model{
    
    self.unitNameLabel.text = model.unitName;
    NSString * detail = @"";
    NSInteger questions = 0;
    if (model.questions) {
        questions = [model.questions count];
    }
    if ((model.questions && [model.questions count] == 0)||!model.questions) {
        self.selectedBtn.hidden = YES;
    }else{
        self.selectedBtn.hidden = NO;
    }
    NSString * timer  = @"";
    if (model.expectTime) {
       timer = [self timeFormatted:model.expectTime];
    }
    detail = [NSString stringWithFormat:@"共 %ld 题  %@",questions,timer];
    self.detailLabel.text = detail;
}

- (NSString *)timeFormatted:(NSNumber *)time
{
    NSString * str = @"";
    //秒
    NSInteger totalSeconds  = [time integerValue];
    
    
    NSInteger minutes = (totalSeconds / 60) % 60;
    if(minutes == 0){
         str = @"";
    }else if (0 < minutes < 1) {
        str = @"预计完成时间1分钟";
    }else if (minutes>60){
        str = @"预计完成时间1个小时以上";
    }else{
        str =[NSString stringWithFormat:@"预计完成时间%ld分钟",minutes];
    }
    
    return  str;
}
- (void)setupUnitDic:(NSDictionary *) item{
    
    
    self.unitNameLabel.text = item[@"unitName"];
    NSString * detail = @"";
    NSInteger questions = 0;
    NSString * questionsStr = @"";
    if (item[@"totalQuestionsItem"] && [item[@"totalQuestionsItem"] integerValue] > 0) {
        questions = [ item[@"totalQuestionsItem"] integerValue];
        questionsStr = [NSString  stringWithFormat:@"共 %ld 题",questions];
    }
    if (( item[@"totalQuestionsItem"] && [ item[@"totalQuestionsItem"] integerValue] == 0)||! item[@"totalQuestionsItem"]) {
        self.selectedBtn.hidden = YES;
    }else{
        self.selectedBtn.hidden = NO;
    }

//    if ( item[@"questions"]) {
//        questions = [ item[@"questions"] count];
//    }
//    if (( item[@"questions"] && [ item[@"questions"] count] == 0)||! item[@"questions"]) {
//        self.selectedBtn.hidden = YES;
//    }else{
//        self.selectedBtn.hidden = NO;
//    }
    NSString * timer  = @"";
    if ( item[@"expectTime"]) {
        timer = [self timeFormatted:item[@"expectTime"]];
    }
    detail = [NSString stringWithFormat:@"%@  %@",questionsStr,timer];
    self.detailLabel.text = detail;
     if ( item[@"chooseNumber"] && [item[@"chooseNumber"] integerValue] > 0) {
         self.chooseItemNumberLabel.text = [NSString stringWithFormat:@"已选择%@题",item[@"chooseNumber"]];
         
     }else{
         self.chooseItemNumberLabel.text = @"";
     }
}

- (void)addSubView{
    
}
@end
