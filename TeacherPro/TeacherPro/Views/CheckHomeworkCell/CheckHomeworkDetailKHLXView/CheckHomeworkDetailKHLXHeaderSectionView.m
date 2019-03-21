//
//  CheckHomeworkDetailKHLXHeaderSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailKHLXHeaderSectionView.h"
#import "PublicDocuments.h"
@interface CheckHomeworkDetailKHLXHeaderSectionView()
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end
@implementation CheckHomeworkDetailKHLXHeaderSectionView

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
}
- (void)btnAction:(UIButton *)btn{
 
    if (self.btnBlock) {
        self.btnBlock(self.section);
    }
}
//秒转化为时间
- (NSString *)timeFormatted:(NSNumber *)time
{
    NSString * str = @"";
    //秒
    NSInteger totalSeconds  = [time integerValue];
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (minutes < 1) {
        str = @"预计1分钟完成";
    }else if (minutes > 60){
        str = @"预计1个小时以上完成";
    }else{
        str = [NSString stringWithFormat:@"预计%ld分钟完成",minutes];
    }
    
    return  str;
}
- (void)setupUnitName:(NSString *)unitName withTopicNumber:(NSInteger)number withExpectTime:(NSNumber *)expectTime{
    
    self.unitNameLabel.text = unitName;
    self.detailLabel.text = [NSString stringWithFormat:@"共 %ld 题 %@",number,[self timeFormatted:expectTime]];
    
}
- (void)setupCompleteNumber:(NSNumber *)number{
    NSString * btnTitle = @"";
    if (number &&[number integerValue] > 0) {
        btnTitle = [NSString stringWithFormat: @"   有%@人做完  ",number];
    }else{
        btnTitle = @"   暂无人做完   ";
    }
    
    [self.selectedBtn setTitle:btnTitle forState:UIControlStateNormal];
}
@end

