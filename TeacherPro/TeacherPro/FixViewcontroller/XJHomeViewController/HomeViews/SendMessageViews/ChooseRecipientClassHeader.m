//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  ChooseRecipientClassHeader.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseRecipientClassHeader.h"
#import "PublicDocuments.h"
#import "ReceuvedMessageModel.h"
@interface ChooseRecipientClassHeader()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@property (weak, nonatomic) IBOutlet UILabel *gradName;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation ChooseRecipientClassHeader
- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupSubView];
}

- (void)setupSubView{
 
    self.bgView.backgroundColor = UIColorFromRGB(0xe6f1ff);
    self.gradName.font = fontSize_11;
    self.gradName.textColor = UIColorFromRGB(0x6b6b6b);
    self.className.font = fontSize_15;
    self.className.textColor = project_main_blue;
    self.topLineView.backgroundColor = project_line_gray;
     self.bottomLineView.backgroundColor = project_line_gray;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    [self.selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupHeaderViewinfo:(ReceuvedStudentContacts *)model{

    self.gradName.text = model.gradeName;
    self.className.text = model.clazzName;
}
- (void)setupOpenImgState:(BOOL)YesOrNo{
    if (YesOrNo) {
        self.arrowImgV.image = [UIImage imageNamed:@"recipient_open"];
    }else{
        self.arrowImgV.image = [UIImage imageNamed:@"recipient_close"];
    }
    
}

- (void)setupSelectedImgState:(BOOL)YesOrNo{
    
    self.selectedBtn.selected = YesOrNo;
}

- (void)tapAction:(id)sender{
    
    if (self.classHeaderBlock) {
        self.classHeaderBlock(self.indexPathSection);
    }
}

- (void)selectedAction:(UIButton *)sender{

    sender.selected =!sender.selected;
    BOOL yesOrNo = sender.selected;
    if (self.allChooseBlock) {
        self.allChooseBlock(self.indexPathSection,yesOrNo);
    }
    
}
@end

