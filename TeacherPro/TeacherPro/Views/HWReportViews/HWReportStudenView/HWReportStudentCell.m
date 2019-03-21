

//
//  HWReportStudentCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportStudentCell.h"
#import "PublicDocuments.h"
@interface HWReportStudentCell()
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
@implementation HWReportStudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.nameLabel.font = fontSize_13;
    self.nameLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.resultsLabel.font = fontSize_13;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupStudentName:(NSString *)name withResults:(NSString *)results withCompleteState:(BOOL)state{
    
   
    self.nameLabel.text = name;
    if (state) {
       self.resultsLabel.text = results;
       self.resultsLabel.textColor = project_main_blue;
    }
    self.resultsLabel.hidden = !state;
}
@end
