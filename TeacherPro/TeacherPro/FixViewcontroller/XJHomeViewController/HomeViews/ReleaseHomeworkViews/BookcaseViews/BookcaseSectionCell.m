//
//  BookcaseSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookcaseSectionCell.h"
#import "PublicDocuments.h"

@interface BookcaseSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
@implementation BookcaseSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.infoLabel.font = fontSize_13;
    self.infoLabel.textColor = project_main_blue;
    self.numberLabel.font = fontSize_13;
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
}
- (void)setupNumber:(NSInteger )number withEditState:(BOOL)editState{
    NSString * info = @"";
    NSString * numberText = @"";
    if (editState) {
        info = @"请选择您要从书架移除的书籍";
        
    }else{
        
        info = @"请选择书籍布置作业";
        numberText = [NSString stringWithFormat:@"共有%zd本书",number];
    }
    self.infoLabel.text = info;
    self.numberLabel.text = numberText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
