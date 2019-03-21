//
//  ClassManageSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassManageSectionView.h"
#import "PublicDocuments.h"
#import "Masonry.h"

@interface ClassManageSectionView()
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;
@property (weak, nonatomic) IBOutlet UIButton *classTransfer;
//解散班级  退出班级
@property (weak, nonatomic) IBOutlet UIButton *classDissolution;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation ClassManageSectionView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.classTransfer.titleLabel.font = fontSize_13;
    self.classDissolution.titleLabel.font = fontSize_13;
    
    CGFloat height = 26;
    self.classTransfer.layer.cornerRadius = height/2;
    self.classDissolution.layer.cornerRadius = height/2;
    
    [self.classTransfer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(height));
    }];
    [self.classDissolution mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(height));
    }];
    
    
    self.lineView.backgroundColor = UIColorFromRGB(0xe0e0e0);
    self.sectionTitle.textColor = UIColorFromRGB(0x8A8B90);
    
}
- (void)setupSectionType:(ClassManageSectionViewType )type withSectionIsEditState:(BOOL)YesOrNo withBtn:(BOOL)hidden withTitle:(NSString *)title{

    self.classTransfer.hidden = hidden;
    self.classDissolution.hidden = hidden;
    
    NSString * sectionStr ;
    BOOL classTransferHident;
    NSString *classDissolutionTitle;
    SEL selected;
    switch (type) {
        case ClassManageSectionViewType_MyManager:
        {
            sectionStr = @"我管理的班级";
            classTransferHident = NO;
            classDissolutionTitle = @"解散班级";
            selected = @selector(dissolutionAction);
        }
            break;
        case ClassManageSectionViewType_MyJoin:
        {
            sectionStr = @"我加入的班级";
            classTransferHident = YES;
            classDissolutionTitle = @"退出班级";
            selected = @selector(exitAction);
        }
            break;
        default :{
            sectionStr = @"";
            classTransferHident = NO;
            classDissolutionTitle = @"";
             selected = nil;
        }
            break;
    }
  
    if (type == ClassManageSectionViewType_normal) {
        
        self.sectionTitle.text = title;
        self.sectionTitle.textColor = UIColorFromRGB(0x6b6b6b);
        self.sectionTitle.font = fontSize_15;
      
    }else{
       self.sectionTitle.text = sectionStr;
    }
   
    self.classTransfer.hidden = hidden?hidden:classTransferHident;
    
    //解散班级  退出班级
   [self.classDissolution setTitle:classDissolutionTitle forState:UIControlStateNormal] ;
    [self.classDissolution addTarget:self action:selected forControlEvents:UIControlEventTouchUpInside] ;
    [self.classTransfer addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    
  
    self.classDissolution.enabled = YesOrNo;
    self.classTransfer.enabled = YesOrNo;
    if (YesOrNo) {
        [self.classTransfer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [self.classDissolution setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.classTransfer setBackgroundColor:project_main_blue];
         [self.classDissolution setBackgroundColor:UIColorFromRGB(0xF04765)];
    }else{
    
        [self.classTransfer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.classDissolution setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.classDissolution setBackgroundColor:UIColorFromRGB(0xD4D4D4)];
        [self.classTransfer setBackgroundColor:UIColorFromRGB(0xD4D4D4)];
    }
}

- (void)exitAction{

    if (self.btnBlock) {
        self.btnBlock(3);
    }
}

- (void)dissolutionAction{

    if (self.btnBlock) {
        self.btnBlock(2);
    }
}

- (void)transferAction{
    if (self.btnBlock) {
        self.btnBlock(1);
    }
}
@end
