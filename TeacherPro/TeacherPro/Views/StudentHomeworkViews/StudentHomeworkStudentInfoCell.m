//
//  StudentHomeworkStudentInfoCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkStudentInfoCell.h"
#import "PublicDocuments.h"
#import "StudentHomeworkDetailModel.h"
#import "UIImageView+WebCache.h"

@interface StudentHomeworkStudentInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImgV;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImgV;
@property (weak, nonatomic) IBOutlet UILabel *scoreDesLabel;

@end
@implementation StudentHomeworkStudentInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
 
}

- (void)setupSubview{
    self.coinLabel.font = fontSize_14;
    self.nameLabel.font = fontSize_14;
    self.bottomLineView.backgroundColor = project_line_gray;
    self.scoreDesLabel.font = fontSize_14;
    self.scoreLabel.text = @"";
    self.scoreDesLabel.text = @"";
    self.nameLabel.text = @"";
    self.coinLabel.text= @"";
    self.leftBtn.titleLabel.font = fontSize_14;
    self.rightBtn.titleLabel.font = fontSize_14;
}
- (void)setupLine{

 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupStuentName:(NSString *)name withCoin:(NSString *)coin withResults:(StudentHomeworkDetailModel *)results withStudentList:(NSArray *)studentList withCurrenntIndex:(NSInteger )currenntIndex {
    
     NSString * key = @"";
    //先检查是否反馈
    if ([results.homeworkFeedback  isEqualToString:@"none"]) {
        //完成
        if (results.finishTime ) {
            
            //完成了且有分数
            if ([ results.scoreLevel   isKindOfClass:[NSString class]] && [results.scoreLevel length] >0 ) {
                key = results.scoreLevel;
            }else{
                //完成了没分数
                key = @"finish";
            }
            
        }else{
            //未完成
            key = @"D";
        }
        
        
        
    }else{
        //需要反馈
        
        if (results.finishTime ) {
            //完成了且有分数
            if ([ results.scoreLevel   isKindOfClass:[NSString class]] && [results.scoreLevel length] >0 ) {
                key = results.scoreLevel ;
            }else{
                //完成了没分数
                key = @"finish";
            }
            
            
        }else{
            key = @"D";
          
        }
        
    }

    self.coinLabel.text = [NSString stringWithFormat:@"%@",coin];
    self.nameLabel.text = name;
 
    if ([key isEqualToString:@"finish"]) {
        self.scoreLabel.text = @"已完成";
        self.scoreLabel.font = [UIFont boldSystemFontOfSize:20];
        self.scoreDesLabel.hidden = YES;
    }else{
        self.scoreLabel.text =  key;
        self.scoreLabel.font = [UIFont boldSystemFontOfSize:35];
        self.scoreDesLabel.hidden = NO;
        self.scoreDesLabel.text = @"综合评分";

    }
    
    NSString * userImgNameUrl = studentList[currenntIndex][@"avatar"];
    NSString * placeholderImgName = @"";
    NSDictionary *studentDic =  studentList[currenntIndex];
    if ([studentDic[@"sex"] isEqualToString:@"female"]) {
        placeholderImgName =  @"student_wuman";
    }else if ([studentDic[@"sex"] isEqualToString:@"male"]){
        placeholderImgName =  @"student_man";
    }else{
        placeholderImgName =  @"student_wuman";
    }
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:userImgNameUrl] placeholderImage:[UIImage imageNamed:placeholderImgName]];
    
    if (!studentList) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.leftArrowImgV.hidden = YES;
        self.rightArrowImgV.hidden = YES;
        return;
    }
    NSString * leftTitle = @"";
    NSString * rightTitle = @"";
    if ([studentList count] == 1) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.leftArrowImgV.hidden = YES;
        self.rightArrowImgV.hidden = YES;
    }else{
        
        if (currenntIndex == 0) {
            self.leftBtn.hidden = YES;
            self.leftArrowImgV.hidden = YES;
            self.rightArrowImgV.hidden = NO;
            self.rightBtn.hidden = NO;
            rightTitle =  studentList[currenntIndex +1][@"studentName"];
        }else if (currenntIndex == [studentList count] -1) {
            self.rightBtn.hidden = YES;
            self.rightArrowImgV.hidden = YES;
            self.leftBtn.hidden = NO;
             self.leftArrowImgV.hidden = NO;
            leftTitle =  studentList[currenntIndex -1][@"studentName"];
        }else{
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.leftArrowImgV.hidden = NO;
            self.rightArrowImgV.hidden = NO;
            leftTitle =  studentList[currenntIndex -1][@"studentName"];
            rightTitle =  studentList[currenntIndex +1][@"studentName"];
        }
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
   
    
    
    
}

- (IBAction)leftAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftButtonAction:)]) {
       [self.delegate leftButtonAction: self.currentPage];
    }
}

- (IBAction)rightAction:(id)sender {
  
    if ([self.delegate respondsToSelector:@selector(rightButtonAction:)]) {
        [self.delegate rightButtonAction: self.currentPage];
    }
}

@end
