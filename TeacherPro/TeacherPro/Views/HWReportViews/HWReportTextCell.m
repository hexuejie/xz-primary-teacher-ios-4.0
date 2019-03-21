
//
//  HWReportTextCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportTextCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HWReportTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentDesLabel;

@end
@implementation HWReportTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentDesLabel.font = fontSize_13;
    self.contentDesLabel.textColor = UIColorFromRGB(0x6b6b6b);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupText:(NSString *)text{
    
    self.contentDesLabel.text = text;
    [ProUtils changeLineSpaceForLabel:self.contentDesLabel WithSpace:UILABEL_LINE_SPACE];
}
@end
