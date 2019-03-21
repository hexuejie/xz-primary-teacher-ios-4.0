//
//  NewClassDetailStudentOneRowCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailStudentOneRowCell.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "ClassDetailStudentModel.h"

@interface NewClassDetailStudentOneRowCell()
@property (weak, nonatomic) IBOutlet UIImageView *isOpenImgV;
@property (weak, nonatomic) IBOutlet UIButton *isOpenOrCloseBtn;

@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;

@end
@implementation NewClassDetailStudentOneRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.userName.textColor = project_main_blue;
    self.userName.font = fontSize_14;
    self.bottomLine.backgroundColor = project_line_gray;
    self.stateImgV.hidden = YES;
}

- (void)setupCellInfo:(ClassDetailStudentModel *)model{

    UIImage * placeholderImg = nil;
    if ([model.sex isEqualToString:@"male"]) {
        placeholderImg = [UIImage imageNamed:@"student_man"];
    }else if([model.sex isEqualToString:@"female"]){
        placeholderImg = [UIImage imageNamed:@"student_wuman"];
        
    }else  {
        placeholderImg = [UIImage imageNamed:@"student_img"];
    }
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:placeholderImg];
    self.userName.text = model.name;
}

- (void)setupCellOpenState:(BOOL )isOpen{
    
    if (isOpen) {
        self.isOpenImgV.image = [UIImage imageNamed:@"class_close"];
//        self.isOpenLabel.text = @"收起";
    }else{
        self.isOpenImgV.image = [UIImage imageNamed:@"class_open"];
//        self.isOpenLabel.text = @"展开";
        
    }
    self.isOpenOrCloseBtn.selected = isOpen;
}


- (IBAction)openOrCloseAction:(id)sender {
    self.isOpenOrCloseBtn.selected = !self.isOpenOrCloseBtn.selected;
    if (self.btnBlock) {
        self.btnBlock(self.indexPath,self.isOpenOrCloseBtn.selected);
    }
}

- (void)showCellSelectedState{

    self.stateImgV.hidden = NO;
    self.isOpenImgV.hidden = YES;
}

- (void)selectedState:(BOOL )state{

    NSString * imgName = @"";
    if (state) {
      imgName = @"message_selected";
        
    }else{
       imgName = @"message_selected_normal";
    }
       self.stateImgV.image = [UIImage imageNamed:imgName];
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
