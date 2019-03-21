//
//  UnOnlineUnfinishedCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "UnOnlineUnfinishedCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface UnOnlineUnfinishedCell()
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWith;
@end
@implementation UnOnlineUnfinishedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubview];
}

-(void)setupSubview{
    
    self.bottomLineView.backgroundColor = project_line_gray;
    
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_14;
   
    self.nameWith.constant = FITSCALE(72);
}
- (void)setupStudentInfo:(NSDictionary *)info  {
    
    
    NSString * name  = info[@"studentName"];
    
    if (name && name.length >5) {
        name = [name substringToIndex:5];
    }
    self.studentName.text = name;
  
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
