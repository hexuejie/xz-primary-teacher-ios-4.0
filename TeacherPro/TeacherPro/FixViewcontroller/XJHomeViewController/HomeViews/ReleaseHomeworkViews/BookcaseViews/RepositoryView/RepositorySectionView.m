//
//  RepositorySectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositorySectionView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface RepositorySectionView()
@property (weak, nonatomic) IBOutlet UIButton *gradBtn;
@property (weak, nonatomic) IBOutlet UIButton *subjctBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *versionBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation RepositorySectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.bottomLine.backgroundColor = project_line_gray;
    self.gradBtn.titleLabel.font = fontSize_10;
    self.subjctBtn.titleLabel.font = fontSize_10;
    self.typeBtn.titleLabel.font = fontSize_10;
    self.versionBtn.titleLabel.font = fontSize_10;
   
    UIColor * selectedColor = project_main_blue;
     UIColor * normalColor = UIColorFromRGB(0x9f9f9f);
    [self.gradBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.subjctBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.typeBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.versionBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    
    [self.gradBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.subjctBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.typeBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.versionBtn setTitleColor:normalColor forState:UIControlStateNormal];
    
    [self resetButton:self.gradBtn];
    [self resetButton:self.subjctBtn];
    [self resetButton:self.typeBtn];
    [self resetButton:self.versionBtn];
}

- (void)setupButtonTitle:(NSString *)name withType:(NSInteger )type{
    switch (type) {
        case 0:
            [self.gradBtn setTitle:name forState:UIControlStateNormal];
            self.gradBtn.selected = NO;
            [self resetButton:self.gradBtn];
            break;
        case 1:
            [self.subjctBtn setTitle:name forState:UIControlStateNormal];
            self.subjctBtn.selected = NO;
              [self resetButton:self.subjctBtn];
            break;
        case 2:
            [self.typeBtn setTitle:name forState:UIControlStateNormal];
            self.typeBtn.selected = NO;
             [self resetButton:self.typeBtn];
            break;
        case 3:
            [self.versionBtn setTitle:name forState:UIControlStateNormal];
            self.versionBtn.selected = NO;
             [self resetButton:self.versionBtn];
            break;
    
        default:
            break;
    }
    
}

- (void)resetButton:(UIButton *)button{
    [ProUtils setupButtonContent:button withType:ButtonContentType_imageRight];
}
- (IBAction)gradAction:(id)sender {
   
    UIButton * btn = sender;
    btn.selected = !btn.selected;
 
    self.subjctBtn.selected = NO;
    self.typeBtn.selected = NO;
    self.versionBtn.selected = NO;
    BOOL isOpen = btn.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepostoryChooseType_gard,isOpen);
    }
}
- (IBAction)subjectAction:(id)sender {
   
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    
    self.gradBtn.selected = NO;
    self.typeBtn.selected = NO;
    self.versionBtn.selected = NO;
    BOOL isOpen = btn.selected;
    
    if (self.chooseBlock) {
        self.chooseBlock(RepostoryChooseType_subjects,isOpen);
    }
}
- (IBAction)typeAction:(id)sender {
  
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    
    self.subjctBtn.selected = NO;
    self.gradBtn.selected = NO;
    self.versionBtn.selected = NO;
    
     BOOL isOpen = btn.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepostoryChooseType_type,isOpen);
    }
}
- (IBAction)versionAction:(id)sender {
   
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    
    self.subjctBtn.selected = NO;
    self.typeBtn.selected = NO;
    self.gradBtn.selected = NO;
    BOOL isOpen = btn.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepostoryChooseType_version,isOpen);
    }
}

@end
