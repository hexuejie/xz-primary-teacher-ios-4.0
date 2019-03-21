//
//  HWHearReportCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWZXLXHearReportCell.h"
#import "LJRingChartView.h"
#import "PublicDocuments.h"
@interface HWZXLXHearReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *AIconV;
@property (weak, nonatomic) IBOutlet UIImageView *BIconV;
@property (weak, nonatomic) IBOutlet UIImageView *CIconV;
@property (weak, nonatomic) IBOutlet UILabel *ACompletionLabel;
@property (weak, nonatomic) IBOutlet UILabel *BCompletionLabel;
@property (weak, nonatomic) IBOutlet UILabel *CCompletionLabel;
@property (weak, nonatomic) IBOutlet LJRingChartView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *ADesLabel;
@property (weak, nonatomic) IBOutlet UILabel *BDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *CDesLabel;

@end
@implementation HWZXLXHearReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
  
  
}
- (void)setupSubViews{
    
    self.titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.titleLabel.font = fontSize_13;
    
    self.ADesLabel.font = fontSize_13;
    self.ADesLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    self.BDesLabel.font = fontSize_13;
    self.BDesLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    self.CDesLabel.font = fontSize_13;
    self.CDesLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    [self setupViewLayer:self.AIconV];
    [self  setupViewLayer:self.BIconV];
    [self setupViewLayer:self.CIconV];
    
}
- (void)setupViewLayer:(UIView *)view{
    view.layer.cornerRadius = 6/2;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth =  1;
    view.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    //        "levels": //各成绩分组完成集合   键值队{precent 完成比例 ，studentCount 学生数 }
    //
    //        "finishStudentCount" //完成学生数
    NSString * typeCn = dic[@"typeCn"];
    NSDictionary * levels = dic[@"levels"];
    
    self.titleLabel.text = typeCn;
    NSString *precentA = levels[@"A"][@"precent"];
    NSString *precentB = levels[@"B"][@"precent"];
    NSString *precentC = levels[@"C"][@"precent"];
    
    self.ACompletionLabel.text = precentA;
    self.BCompletionLabel.text = precentB;
    self.CCompletionLabel.text = precentB;
    
    NSMutableArray *chartItems = [NSMutableArray array];
    
    NSArray *colors = nil;
    NSInteger precentARatio = [[precentA stringByReplacingOccurrencesOfString:@"%" withString:@""] integerValue];
     NSInteger precentBRatio =[[precentB stringByReplacingOccurrencesOfString:@"%" withString:@""] integerValue];
     NSInteger precentCRatio = [[precentC stringByReplacingOccurrencesOfString:@"%" withString:@""] integerValue];
    
    if (precentARatio == 0 && precentBRatio == 0  && precentCRatio == 0) {
         colors =  @[UIColorFromRGB(0x9b9b9b)];
        precentARatio = 100;
    }else {
        colors =  @[UIColorFromRGB(0xF49D40), UIColorFromRGB(0xAACF2B), UIColorFromRGB(0x57BEFF)];
        
    };
    self.chartView.contentLabel.text = @"";
    for (NSInteger i = 0; i < colors.count; i++) {
        LJChartItem *item = [[LJChartItem alloc] init];
        if (i == 0) {
            if([precentA containsString:@"%"]){
                item.value =  @(precentARatio);
            }
           
        }else if (i == 1){
            if([precentB containsString:@"%"]){
                item.value = @(precentBRatio);
                
            }
        }else{
            if([precentC containsString:@"%"]){
                item.value =  @(precentCRatio);
                
            }
        }
        
        item.color = colors[i];
        [chartItems addObject:item];
    }
    
    self.chartView.chartItems = chartItems;
    self.chartView.outerRingWidth = 0;
    self.chartView.innerRingWidth = 4;
    self.chartView.hideDot = YES;
    self.chartView.hidden= YES;
}
@end
