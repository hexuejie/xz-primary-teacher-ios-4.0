//
//  RepositoryBookSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryBookSectionView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface RepositoryBookSectionView()
@property (weak, nonatomic) IBOutlet UIButton *gradBtn;
@property (weak, nonatomic) IBOutlet UIButton *subjctBtn;
@property (weak, nonatomic) IBOutlet UIButton *versionBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@end
@implementation RepositoryBookSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.bottomLine.backgroundColor = project_line_gray;
    self.gradBtn.titleLabel.font = fontSize_10;
    self.subjctBtn.titleLabel.font = fontSize_10;
    self.versionBtn.titleLabel.font = fontSize_10;
    
      UIColor * selectedColor = project_main_blue;
      UIColor * normalColor = UIColorFromRGB(0x9f9f9f);
    [self.gradBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.subjctBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.versionBtn setTitleColor:normalColor forState:UIControlStateNormal];
    
    [self.gradBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.subjctBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.versionBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    [self setupButton:self.gradBtn];
    [self setupButton:self.subjctBtn];
    [self setupButton:self.versionBtn];
}

- (void)setupButton:(UIButton *)button{

    [ProUtils setupButtonContent:button withType:ButtonContentType_imageRight];
}
- (IBAction)gradAction:(UIButton *)sender {
   
    sender.selected = !sender.selected;
    self.subjctBtn.selected = NO;
    self.versionBtn.selected = NO;
    BOOL isOpen = sender.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepositoryBookType_gard,isOpen);
    }
}
- (IBAction)subjectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.gradBtn.selected = NO;
    self.versionBtn.selected = NO;
    BOOL isOpen = sender.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepositoryBookType_subjects,isOpen);
    }
}

- (IBAction)versionAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.gradBtn.selected = NO;
    self.subjctBtn.selected = NO;
    BOOL isOpen = sender.selected;
    if (self.chooseBlock) {
        self.chooseBlock(RepositoryBookType_version,isOpen);
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
      
        case 3:
            [self.versionBtn setTitle:name forState:UIControlStateNormal];
            self.versionBtn.selected = NO;
            [self setupButton:self.versionBtn];
            break;
            
        default:
            break;
    }
    
}


@end
