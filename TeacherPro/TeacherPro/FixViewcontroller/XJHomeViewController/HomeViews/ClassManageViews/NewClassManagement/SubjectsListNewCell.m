//
//  SubjectsListNewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SubjectsListNewCell.h"
#import "PublicDocuments.h"

@interface SubjectsListNewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation SubjectsListNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.textColor = UIColorFromRGB(0x6b6b6b);
    self.title.font = fontSize_14;
    
    self.bottomLine.backgroundColor = project_line_gray;
}

- (void)setupTitle:(NSString *)title withState:(BOOL )state{

    self.title.text = title;
    if (state) {
         self.stateImgV.image = [UIImage imageNamed:@"subjects_new_selected"];
    }else{
    
        self.stateImgV.image = [UIImage imageNamed:@"subjects_new_unselected"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
