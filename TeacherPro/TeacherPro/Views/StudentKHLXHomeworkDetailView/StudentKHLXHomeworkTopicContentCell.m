//
//  StudentKHLXHomeworkTopicContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentKHLXHomeworkTopicContentCell.h"
#import "StudentKHLXHomeworkDetailListModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface StudentKHLXHomeworkTopicContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicOptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;//题目对错
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIView *spacingView;

@end
@implementation StudentKHLXHomeworkTopicContentCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.bottomLineV.backgroundColor = project_line_gray;
    self.spacingView.backgroundColor = project_background_gray;
    self.bottomTitleLabel.textColor = UIColorFromRGB(0xC1C1C1);
    self.bottomTitleLabel.font = fontSize_12;
    
    
}
- (void)setupTopicModel:(StudentKHLXHomeworkDetailQuestionModel *) model{
    
    if (model.options) {
        NSArray * allkeys = model.options.allKeys;
        NSArray *sortedArray = [allkeys sortedArrayUsingFunction:studentKHLXnickNameSort context:NULL];
        __block NSString * options =@"";
        NSMutableAttributedString *attributedText=  [[NSMutableAttributedString alloc]init];
        [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * tempStr = [NSString stringWithFormat:@"<br><br>%@.%@ ",obj,model.options[obj]];
            options = [options stringByAppendingString:tempStr];
            
        }];
        
        
        [attributedText appendAttributedString:[ProUtils strToAttriWithStr: options]];
        
        [attributedText addAttribute:NSFontAttributeName value:fontSize_14 range:NSMakeRange(0, attributedText.length)];
        self.topicOptionLabel.attributedText = attributedText;
        
    }else{
        
        self.topicOptionLabel.text = @"";
    }
    
    if (model.questionStem) {
        NSMutableAttributedString *attributedText=  [[NSMutableAttributedString alloc]initWithAttributedString:[ProUtils strToAttriWithStr: model.questionStem]];
        [attributedText addAttribute:NSFontAttributeName value:fontSize_14 range:NSMakeRange(0, attributedText.length)];
        
        self.topicTitle.attributedText = attributedText ;
        
        
    }else{
        
        self.topicTitle.text = @"";
    }
    NSString * questionTypeName = @"";
    if (model.questionTypeName) {
        questionTypeName = model.questionTypeName;
    }
    NSString * difficultyName = @"";
    if (model.difficultyName) {
        difficultyName =   model.difficultyName;
    }
    NSNumber * userNumber = @(0);
    if (model.useCount) {
        userNumber = model.useCount;
    }
    
    NSNumber * errorStudentCount = @(0);
    if (model.errorStudentCount) {
        errorStudentCount = model.errorStudentCount;
    }
    NSNumber * rightStudentCount = @(0);
    if ([model.finishStudentCount integerValue] - [model.errorStudentCount integerValue]) {
        NSInteger rightNumber = [model.finishStudentCount integerValue] - [model.errorStudentCount integerValue];
        rightStudentCount = @(rightNumber);
    }
    
    NSString * rightAndWrong = [NSString stringWithFormat:@"%@人答对 %@人答错",rightStudentCount,errorStudentCount];
    
    NSString * bottomText = [questionTypeName stringByAppendingString:[NSString stringWithFormat:@"  %@ 被使用%@次 %@",difficultyName,userNumber,rightAndWrong]];
    
    NSAttributedString * attributed = [ProUtils setAttributedText:bottomText withColor:UIColorFromRGB(0x85272C) withRange:[bottomText rangeOfString:rightAndWrong] withFont:fontSize_12];
    self.bottomTitleLabel.attributedText = attributed;
//    self.bottomTitleLabel.text = bottomText;

    NSString * imgName = @"";
    //做错
    if ([model.studentStatus integerValue] == 1) {
        imgName = @"student_wrong_topic";
    }
    //做对
    else if ([model.studentStatus integerValue] ==2){
        imgName = @"student_right_topic";
    }else{
      //未做
        imgName = @"";
    }
      self.stateImgV.image = [UIImage imageNamed:imgName];
}

NSInteger studentKHLXnickNameSort(id user1, id user2, void *context)
{
    
    return  [user1 localizedCompare:user2];
}


- (void)setupTopicDic:(NSDictionary *) itemDic{
    
    if (itemDic[@"options"]) {
        
        self.topicOptionLabel.attributedText = itemDic[@"options"];
        
    }else{
        self.topicOptionLabel.text = @"";
    }
    if (itemDic[@"questionStem"] ) {
        
        
        self.topicTitle.attributedText = itemDic[@"questionStem"] ;
    }else{
        self.topicTitle.text =@"";
    }
    NSString * questionTypeName = @"";
    if (itemDic[@"questionTypeName"] ) {
        questionTypeName = itemDic[@"questionTypeName"];
    }
    NSString * difficultyName = @"";
    if (itemDic[@"difficultyName"] ) {
        difficultyName =  itemDic[@"difficultyName"] ;
    }
    NSNumber * userNumber = @(0);
    if (itemDic[@"useCount"] ) {
        userNumber =  itemDic[@"useCount"] ;
    }
    
    
    
    NSNumber * errorStudentCount = @(0);
    if (itemDic[@"errorStudentCount"]) {
        errorStudentCount = itemDic[@"errorStudentCount"];
    }
    NSNumber * rightStudentCount = @(0);
    if ([itemDic[@"finishStudentCount"] integerValue] - [itemDic[@"errorStudentCount"] integerValue]) {
        NSInteger rightNumber = [itemDic[@"finishStudentCount"] integerValue] - [itemDic[@"errorStudentCount"] integerValue];
        rightStudentCount = @(rightNumber);
    }
    
    NSString * rightAndWrong = [NSString stringWithFormat:@"%@人答对 %@人答错",rightStudentCount,errorStudentCount];
    
    NSString * bottomText = [questionTypeName stringByAppendingString:[NSString stringWithFormat:@"  %@ 被使用%@次 %@",difficultyName,userNumber,rightAndWrong]];
    
    NSAttributedString * attributed = [ProUtils setAttributedText:bottomText withColor:UIColorFromRGB(0x85272C) withRange:[bottomText rangeOfString:rightAndWrong] withFont:fontSize_12];
    
//    NSString * bottomText = [questionTypeName stringByAppendingString:[NSString stringWithFormat:@"  %@ 被使用%@次",difficultyName,userNumber]];
    
//    self.bottomTitleLabel.text = bottomText;
    self.bottomTitleLabel.attributedText = attributed;
    
    NSString * imgName = @"";
    //做错
    if ([itemDic[@"studentStatus"] integerValue] == 1) {
        imgName = @"student_wrong_topic";
    }
    //做对
    else if ([itemDic[@"studentStatus"] integerValue] ==2){
        imgName = @"student_right_topic";
    }else{
        //未做
        imgName = @"";
    }
    self.stateImgV.image = [UIImage imageNamed:imgName];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
