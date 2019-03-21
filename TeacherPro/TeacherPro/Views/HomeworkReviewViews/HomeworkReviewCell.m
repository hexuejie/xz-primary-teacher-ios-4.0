//
//  HomeworkReviewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkReviewCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "HomeworkReviewModel.h"
@interface HomeworkReviewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (strong, nonatomic) UIView *homeworkDetailBgV;
@end
@implementation HomeworkReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupSubView];
}

- (void)setupSubView{

    self.lineView.backgroundColor = UIColorFromRGB(0x797979);
    [self.bgImgV setImage:[ProUtils getResizableImage:[UIImage imageNamed:@"review_bubbles"] withEdgeInset:UIEdgeInsetsMake(30, 30, 6, 30)]];
    self.dayLabel.textColor = project_main_blue;
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = 5/2;
    [self addSubview:self.homeworkDetailBgV];
}

- (UIView *)homeworkDetailBgV{

    if (!_homeworkDetailBgV) {
        _homeworkDetailBgV = [[UIView alloc]init];
        _homeworkDetailBgV.backgroundColor = [UIColor clearColor];
    }
    return _homeworkDetailBgV;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupHomeworkReviewInfo:(HomeworkReviewModel *)model{

    if ([model.existsNotComment boolValue]){
    
        self.pointView.backgroundColor = UIColorFromRGB(0xFF5555);
    }else{
    
        self.pointView.backgroundColor = project_main_blue;
    }
    
    NSString * day = model.day;
    self.dayLabel.text = [day stringByAppendingString:@"日"];
 
    //移除重用的view
    for (UIView * subView in self.homeworkDetailBgV.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat   hegiht  = FITSCALE(50);
    CGFloat   width = IPHONE_WIDTH - FITSCALE(100);
    
     self.homeworkDetailBgV.frame = CGRectMake(FITSCALE(90), 0, width, hegiht * [model.homeworkDetials count]);
    
    for (int i = 0; i< [model.homeworkDetials count]; i++) {
        HomeworkDetialsModel * detailModel = model.homeworkDetials[i];
        UIView * singleView = [[UIView alloc]initWithFrame:CGRectMake(0, i*hegiht  , width, hegiht)];
        singleView.backgroundColor = [UIColor clearColor];
        NSString * subjetName = detailModel.subjectName;
        NSString * className = [detailModel.gradeName stringByAppendingString: detailModel.clazzName];
        BOOL  check =  [detailModel.remark boolValue];
        [self initHomewrokView:singleView withSubjectName:subjetName  withClass:className withCheck:check];
        [self.homeworkDetailBgV addSubview:singleView];
    }
   
}


- (void)initHomewrokView:(UIView *)view withSubjectName:(NSString * )subjectName withClass:(NSString *)className withCheck:(BOOL )check{
    UIImageView  * subjectNameimgV = [[UIImageView alloc]initWithFrame: CGRectMake(0, view.frame.size.height/2-  FITSCALE(23)/2, FITSCALE(38),  FITSCALE(23))];
    
    if ([subjectName isEqualToString:@"语文"]) {
       
        subjectNameimgV.image = [UIImage imageNamed:@"review_chinese_icon"];
    }else if ([subjectName isEqualToString:@"英语"]) {
  
        subjectNameimgV.image = [UIImage imageNamed:@"review_english_icon"];
    }else if ([subjectName isEqualToString:@"数学"]) {
   
        subjectNameimgV.image = [UIImage imageNamed:@"review_number_icon"];
    }
    else  {
        subjectNameimgV.image = [UIImage imageNamed:@"review_other_icon"];
        //        subjectNameLabel.text = @"其它";
 
    }
    [view addSubview:subjectNameimgV];
    
    
    UILabel * subjectNameLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, view.frame.size.height/2-  FITSCALE(23)/2, FITSCALE(38),  FITSCALE(23))];
    
    subjectNameLabel.textAlignment = NSTextAlignmentCenter;
    subjectNameLabel.textColor = [UIColor whiteColor];
    subjectNameLabel.font = fontSize_14;
    if (subjectName &&[subjectName length]>0 && ![subjectName isEqualToString:@"其它"]) {
         subjectNameLabel.text = subjectName;
    }else{
       subjectNameLabel.text = @"作业";
        
    }
   
    subjectNameLabel.backgroundColor = [UIColor clearColor];
//    subjectNameLabel.layer.masksToBounds = YES;
//    subjectNameLabel.layer.cornerRadius = 2;
   
    [view addSubview:subjectNameLabel];
    
    UILabel * checkLabel = [[UILabel alloc]initWithFrame: CGRectMake(view.frame.size.width - FITSCALE(60), 0, FITSCALE(60), view.frame.size.height)];
    
    checkLabel.font = fontSize_13;
    if (check) {
        checkLabel.textColor =  project_main_blue;
        checkLabel.text = @"已检查";
    }else{
        checkLabel.textColor =  UIColorFromRGB(0xFF5555);
        checkLabel.text = @"未检查";
    }
    [view addSubview:checkLabel];
    
    
    UILabel * classLabel = [[UILabel alloc]initWithFrame: CGRectMake(CGRectGetMaxX(  subjectNameLabel.frame)+5, 0,view.frame.size.width - checkLabel.frame.size.width - CGRectGetMaxX(subjectNameLabel.frame) -5, view.frame.size.height)];
    classLabel.textColor =  UIColorFromRGB(0x4d4d4d);
    classLabel.font = fontSize_14;
    classLabel.text = className;
    [view addSubview:classLabel];
    
    
   
}
@end
