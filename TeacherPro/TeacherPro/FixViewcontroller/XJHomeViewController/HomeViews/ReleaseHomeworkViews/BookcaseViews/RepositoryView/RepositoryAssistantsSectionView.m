

//
//  RepositoryAssistantsSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryAssistantsSectionView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface RepositoryAssistantsSectionView()
@property (weak, nonatomic) IBOutlet UIButton *gradBtn;
@property (weak, nonatomic) IBOutlet UIButton *subjctBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@end
@implementation RepositoryAssistantsSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.bottomLine.backgroundColor = project_line_gray;
    self.gradBtn.titleLabel.font = fontSize_10;
    self.subjctBtn.titleLabel.font = fontSize_10;
   
    
    UIColor * selectedColor = project_main_blue;
    UIColor * normalColor = UIColorFromRGB(0x9f9f9f);
    [self.gradBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.subjctBtn setTitleColor:normalColor forState:UIControlStateNormal];
  
    
    [self.gradBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.subjctBtn setTitleColor:selectedColor forState:UIControlStateSelected];
 
    
    [self setupButton:self.gradBtn];
    [self setupButton:self.subjctBtn];
    
}

- (void)setupButton:(UIButton *)button{
    
    [ProUtils setupButtonContent:button withType:ButtonContentType_imageRight];
}
- (IBAction)gradAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.subjctBtn.selected = NO;
    
    BOOL isOpen = sender.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepositoryAssistantsType_gard,isOpen);
    }
}
- (IBAction)subjectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.gradBtn.selected = NO;
    
    BOOL isOpen = sender.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepositoryAssistantsType_subjects,isOpen);
    }
}


- (void)setupButtonTitle:(NSString *)name withType:(NSInteger )type{
    switch (type) {
        case 0:
            [self.gradBtn setTitle:name forState:UIControlStateNormal];
            self.gradBtn.selected = NO;
            [self setupButton:self.gradBtn];
            break;
        case 1:
            [self.subjctBtn setTitle:name forState:UIControlStateNormal];
            self.subjctBtn.selected = NO;
            [self setupButton:self.subjctBtn];
            break;
     
            
        default:
            break;
    }
    
}

@end
