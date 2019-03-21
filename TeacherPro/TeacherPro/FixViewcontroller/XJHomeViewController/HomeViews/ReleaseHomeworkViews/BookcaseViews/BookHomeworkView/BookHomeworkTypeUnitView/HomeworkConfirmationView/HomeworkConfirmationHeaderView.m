
//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  HomeworkConfirmationHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkConfirmationHeaderView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HomeworkConfirmationHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *totailTimeImgV;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineV;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;

@end
@implementation HomeworkConfirmationHeaderView

- (void)awakeFromNib{

    [super awakeFromNib];
    self.totalTimeLabel.font = fontSize_14;
    self.detailLabel.font = fontSize_11;
    self.contentTitleLabel.font = fontSize_14;
    self.horizontalLineV.backgroundColor = project_line_gray;
    self.contentTitleLabel.textColor = UIColorFromRGB(0x434343);
    self.detailLabel.textColor = UIColorFromRGB(0x434343);
    self.totalTimeLabel.textColor = UIColorFromRGB(0x434343);
    
}
- (void)setupTotalTimer:(NSString *)timerDetail{
  
    NSString * totalTimeLabelStr = [@"预计时间:" stringByAppendingString:timerDetail];
    UIColor * color = project_main_blue;
    NSRange  range =  [totalTimeLabelStr rangeOfString:timerDetail];
    self.totalTimeLabel.attributedText = [ProUtils setAttributedText:totalTimeLabelStr withColor:color withRange:range withFont:fontSize_14];
}
@end
