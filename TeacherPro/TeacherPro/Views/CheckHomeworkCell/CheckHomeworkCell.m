//
//  CheckHomeworkCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//




#import "CheckHomeworkCell.h"
#import "CheckHomeworkListModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIView+add.h"

@interface CheckHomeworkCell()

@property (weak, nonatomic) IBOutlet UIView *bottonView;//设置阴影
@property (weak, nonatomic) IBOutlet UIView *layerView;


@property (weak, nonatomic) IBOutlet UIButton *homeworkDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkOrLookBtn;
@property (weak, nonatomic) IBOutlet UILabel  *homeworkSendDate;//发布时间
@property (weak, nonatomic) IBOutlet UILabel  *homeworkClass;

@property (weak, nonatomic) IBOutlet UILabel  *backfeedLabel;//反馈方式
@property (weak, nonatomic) IBOutlet UILabel  *booksNameLabel;//书名

@property (weak, nonatomic) IBOutlet UIImageView *subject;//科目
@property (weak, nonatomic) IBOutlet UILabel *homeworkFinshDate;//作业完成时间
@property (weak, nonatomic) IBOutlet UIButton *worthHomeworkBtn;//催缴作业  hasCallHomework


@property(assign, nonatomic) BOOL isRemarked;
@property(strong, nonatomic)  CheckHomeworkModel * model;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *topViewTopLine;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *progressView;

//@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;//全部完成
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkWidth2;

@end
@implementation CheckHomeworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.worthHomeworkBtn.highlighted = NO;
    [self setupSubview];
    
}

-(void)setupHomeworkInfo:(CheckHomeworkModel *)model isRemarked:(BOOL )remarked{
    self.isRemarked = remarked;
    self.model = model;
    self.subject.image = [UIImage imageNamed:@"otherSubject_homework_icon"];
    if (self.model.subjectId) {
        if ([self.model.subjectId isEqualToString:@"003"]) {
            self.subject.image = [UIImage imageNamed:@"englishSubject_homework_icon"];
        }//
    }
    self.checkWidth.constant = (kScreenWidth-32)/2;
    self.stateImageView.hidden = YES;
    NSString * homeworkStateStr =@"";
    UIColor * stateTextColor = nil;
    UIColor * stateTextBgColor = nil;
    NSString * ctimeStr = @"";
    NSComparisonResult result;
    
    if (model.ctime &&model.ctime.length >11) {
        ctimeStr = [model.ctime substringFromIndex:11];
    }
    
    
    
    if (remarked ) {    //没选书就没有作业报告
        
        [self.checkOrLookBtn setTitle :@"完成详情" forState:UIControlStateNormal];
        homeworkStateStr = @"已检查";
        self.worthHomeworkBtn.hidden = YES;

        if ([model.hasReport boolValue]) {
            [self.homeworkDetailBtn setTitle :@"作业报告" forState:UIControlStateNormal];
            self.homeworkDetailBtn.hidden = NO;
            self.checkWidth.constant = (kScreenWidth-32)/2;
        }else{
            self.homeworkDetailBtn.hidden = YES;
            self.checkWidth.constant = (kScreenWidth-32)/1;
        }
        self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@ 截止", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
    }else{
        
        [self.checkOrLookBtn setTitle :@"检查作业" forState:UIControlStateNormal];
 
        result = [[self timeWithTimeIntervalString:model.endTime] compare:[self getNowDate]];
//        ctime
        
        if (result == NSOrderedDescending) {
            homeworkStateStr = @"未检查";
            stateTextColor = [UIColor whiteColor];
            stateTextBgColor = UIColorFromRGB(0xF45860);
            self.worthHomeworkBtn.hidden = YES;
            
            self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@ 截止(进行中)", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
            
            
            if ([model.studentCount isEqualToNumber: model.finishedCount]) {
                
                self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@截止（已完成）", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
                if ( [model.finishedCount integerValue] == 0) {
                    self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@截止（进行中）", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
                }
                
            }
            
        }else{
            if (0<= [model.finishedCount integerValue] && [model.finishedCount integerValue]< [model.studentCount integerValue]) {
                self.worthHomeworkBtn.hidden = NO;
                if ([model.hasCallHomework isEqualToString:@"1"]) {
                    self.worthHomeworkBtn.selected = YES;
                }else{
                    self.worthHomeworkBtn.selected = NO;
                }
            }else{
                self.worthHomeworkBtn.hidden = YES;
            }
            
            homeworkStateStr = @"已超时";
            stateTextColor = [UIColor whiteColor];
            stateTextBgColor = UIColorFromRGB(0xBEC6D1);
            
            
            if ([model.studentCount isEqualToNumber: model.finishedCount]) {
               
                self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@截止（已完成）", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
                if ( [model.finishedCount integerValue] == 0) {
                    self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@截止（已超时）", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
                }
            }else{
                self.homeworkFinshDate.text = [NSString stringWithFormat:@"%@ 布置 | %@截止（已超时）", [ctimeStr substringToIndex:5], [model.endTime substringWithRange:NSMakeRange(5, 11)]];
      
            }
            
        }
    }

    self.homeworkClass.text = [NSString stringWithFormat:@"%@%@",model.gradeName,model.clazzName];
    NSString * progressTextDes = @"";
    NSAttributedString * progressTextAtrDes = nil;
    UIColor * pathFillColor = HexRGB(0x2D8AFF);
    if ([model.finishedCount integerValue] == 0) {
    
        NSString * stateStr = @"完成人数";
        NSArray * colors = nil;
        NSRange range1 ;
        NSRange range2 ;
        NSArray * ranges = nil;
        NSArray * fonts = nil;//圆圈内的东西
        if ([model.studentCount integerValue] == 0) {
            progressTextDes = [NSString stringWithFormat:@"班级\n无学生"];
            colors = @[UIColorFromRGB(0x8A8F99)];
            range1 = [progressTextDes rangeOfString:progressTextDes];
            ranges = @[NSStringFromRange(range1) ];
            fonts = @[[UIFont systemFontOfSize:12]];
            [self.checkOrLookBtn setTitle:@"邀请学生" forState:UIControlStateNormal];
            
        }else{
            progressTextDes = [NSString stringWithFormat:@"0/%ld \n %@",[model.studentCount integerValue],stateStr];
            colors = @[UIColorFromRGB(0x33AAFF),UIColorFromRGB(0x8A8F99)];
            range1 = [progressTextDes rangeOfString:@"0"];
            range2 = [progressTextDes rangeOfString:[NSString stringWithFormat:@"/%ld \n %@",[model.studentCount integerValue],stateStr]];
            ranges = @[NSStringFromRange(range1),NSStringFromRange(range2) ];
            fonts = @[[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],[UIFont systemFontOfSize:12]];
            
            
        }
        progressTextAtrDes = [ProUtils confightAttributedText:progressTextDes withColors:colors withRanges:ranges withFonts:fonts];
        pathFillColor = UIColorFromRGB(0xDCE5EA);
        
    }else if(0<= [model.finishedCount integerValue] && [model.finishedCount integerValue]< [model.studentCount integerValue]){

        NSString * stateStr = @"完成人数";
        progressTextDes = [NSString stringWithFormat:@"%ld/%ld \n %@",[model.finishedCount integerValue],[model.studentCount integerValue],stateStr];

        NSArray * colors = @[UIColorFromRGB(0x33AAFF),UIColorFromRGB(0x8A8F99)];
        NSRange range1 = [progressTextDes rangeOfString:[NSString stringWithFormat:@"%ld",[model.finishedCount integerValue]]];
        NSRange range2 = [progressTextDes rangeOfString:stateStr];
        NSArray * ranges = @[NSStringFromRange(range1),NSStringFromRange(range2) ];
        NSArray * fonts = @[[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],[UIFont systemFontOfSize:12]];
        
        progressTextAtrDes = [ProUtils confightAttributedText:progressTextDes withColors:colors withRanges:ranges withFonts:fonts];
        pathFillColor = project_main_blue;
    }else if([model.finishedCount integerValue]==[model.studentCount integerValue] && [model.studentCount integerValue]>0){
   
        NSString * stateStr = @"完成人数";
        NSArray * colors = @[UIColorFromRGB(0x33AAFF),UIColorFromRGB(0x8A8F99)];
        if ([model.finishedCount integerValue] == [model.studentCount integerValue]) {
            self.stateImageView.hidden = NO;
            stateStr = @"全部完成";
            colors = @[UIColorFromRGB(0x33AAFF),UIColorFromRGB(0x33AAFF)];
        }
        progressTextDes = [NSString stringWithFormat:@"%ld/%ld \n %@",[model.finishedCount integerValue],[model.studentCount integerValue],stateStr];
        
        NSRange range1 = [progressTextDes rangeOfString:[NSString stringWithFormat:@"%ld",[model.finishedCount integerValue]]];
        NSRange range2 = [progressTextDes rangeOfString:[NSString stringWithFormat:@"/%ld \n %@",[model.studentCount integerValue],stateStr]];
        NSArray * ranges = @[NSStringFromRange(range1),NSStringFromRange(range2) ];
        NSArray * fonts = @[[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],[UIFont systemFontOfSize:12]];
        
        progressTextAtrDes = [ProUtils confightAttributedText:progressTextDes withColors:colors withRanges:ranges withFonts:fonts];
        
        pathFillColor = UIColorFromRGB(0x2D8AFF);
    }
    CGFloat progress = 0;
    if ([model.studentCount floatValue] == 0) {
        progress = 0;
    }else{
        progress = [model.finishedCount floatValue]/[model.studentCount floatValue];
    }
//    F5F5F5
    [self cofightProprogressViewText:progressTextAtrDes withPathFillColor:pathFillColor withProgress:progress];
    
    self.backfeedLabel.text = [NSString stringWithFormat:@"%@",model.feedbackName];
//    self.homeworkSendDate.text = [NSString stringWithFormat:@"%@ 布置",  ctime];

    
    NSString * booksName = @"无书本作业";
    if ([model.books count] >0) {
        booksName = [NSString stringWithFormat:@"%@",[model.books componentsJoinedByString:@"\n"]];
    }
    [self setLabelSpace:self.booksNameLabel withValue:booksName withFont:self.booksNameLabel.font];
    self.homeworkDetailBtn.clipsToBounds = NO;
    self.checkOrLookBtn.clipsToBounds = NO;
}

- (void)cofightProprogressViewText:(NSAttributedString *)progressTextAtrDes withPathFillColor:(UIColor *)pathFillColor withProgress:(CGFloat)progress{
    self.progressView.progressTextAtr = progressTextAtrDes;
    self.progressView.showProgressText = YES;
    self.progressView.duration = 1;
    self.progressView.showPoint = NO;
    self.progressView.increaseFromLast = YES;
    self.progressView.strokeWidth = 4;
    self.progressView.progressLabel.font = systemFontSize(12);
    self.progressView.progressLabel.textColor = UIColorFromRGB(0x8A8F99);
    self.progressView.pathBackColor = UIColorFromRGB(0xF5F5F5);
    
    if (progress==0.0) {
        self.progressView.pathFillColor = [UIColor clearColor];
    }else{
        self.progressView.pathFillColor = pathFillColor;
    }
    
    self.progressView.progress = progress;
}

//催缴作业
- (IBAction)worthhomeworkAction:(UIButton *)sender {
    
     if (!sender.selected) {
            self.checkeBlock(self.model, CheckHomeworkCellButtonType_worth);
     }
  
    sender.selected = YES;
}
- (IBAction)checkeOrLookAction:(id)sender {
    if (self.isRemarked) {
        if ([self.model.studentCount integerValue] == 0)  {
            //邀请学生
            self.checkeBlock(self.model, CheckHomeworkCellButtonType_InviteStudents);
        }else{
            
            //查看作业
            if (self.checkeBlock) {
                self.checkeBlock(self.model, CheckHomeworkCellButtonType_look);
            }
            
        }
    }else{
        if ([self.model.studentCount integerValue] == 0)  {
            //邀请学生
              self.checkeBlock(self.model, CheckHomeworkCellButtonType_InviteStudents);
        }else{
            
            //检查作业
            self.checkeBlock(self.model, CheckHomeworkCellButtonType_check);
            
        }
    }
}

- (IBAction)homeworkDetailAction:(id)sender {
    
    if (self.isRemarked) {
        //作业报告
        if (self.checkeBlock) {
            self.checkeBlock(self.model, CheckHomeworkCellButtonType_reprot);
        }
        
    }else{
        if (self.checkeBlock) {
            self.checkeBlock(self.model, CheckHomeworkCellButtonType_detail);
        }
        
    }
    
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4.5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
- (void)setupSubview{
    
    //    self.imgW.constant = FITSCALE(69);
    self.booksNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.worthHomeworkBtn.layer.cornerRadius = 12.5;
    self.worthHomeworkBtn.layer.masksToBounds = YES;
    
    self.layerView.backgroundColor = [UIColor whiteColor];
    self.layerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.layerView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;// 阴影的颜色
    self.layerView.layer.shadowRadius = 10;// 阴影扩散的范围控制
    self.layerView.layer.shadowOffset  = CGSizeMake(0, 1);// 阴影的范围
    self.layerView.layer.masksToBounds = NO;
    
    self.bottonView.layer.cornerRadius = 6;
    self.bottonView.layer.masksToBounds = YES;
}

- (NSDate * )timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSString * -> NSDate *
    
    NSDate *newDate = [formatter dateFromString:timeString];
    return newDate;
}

- (NSDate * )getNowDate
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSString * -> NSDate *
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSDate * newDate = [formatter  dateFromString:dateStr];
    
    return newDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

