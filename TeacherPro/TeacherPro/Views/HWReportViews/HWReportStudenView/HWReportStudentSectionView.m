

//
//  HWReportStudentSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportStudentSectionView.h"
#import "PublicDocuments.h"

@interface HWReportStudentSectionView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HWReportStudentSectionView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubView];
}
- (void)setupSubView{
    self.titleLabel.font = fontSize_13;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
   
}
- (void)setupSection:(NSString *)titleStr{
    
    self.titleLabel.text = titleStr;
}

@end
