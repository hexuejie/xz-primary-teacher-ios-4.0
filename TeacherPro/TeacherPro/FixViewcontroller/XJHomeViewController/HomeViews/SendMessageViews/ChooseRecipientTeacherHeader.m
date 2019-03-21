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
//  ChooseRecipientTeacherHeader.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseRecipientTeacherHeader.h"
#import "PublicDocuments.h"
@interface ChooseRecipientTeacherHeader()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *ToplineView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@end
@implementation ChooseRecipientTeacherHeader

- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupSubView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    [self.selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupSubView{

    self.titleName.textColor = project_main_blue;
    self.bgView.backgroundColor = UIColorFromRGB(0xe6f1ff);
    self.titleName.font = fontSize_15;
  
    self.bottomLineView.backgroundColor = project_line_gray;
    self.ToplineView.backgroundColor = project_line_gray;
}

- (void)setupSelectedImgState:(BOOL)YesOrNo{

    self.selectedBtn.selected = YesOrNo;
    
}


- (void)setupOpenImgState:(BOOL)YesOrNo{
    if (YesOrNo) {
        self.arrowImgV.image = [UIImage imageNamed:@"recipient_open"];
    }else{
        self.arrowImgV.image = [UIImage imageNamed:@"recipient_close"];
    }
    
}
- (void)tapAction:(id)sender{

    if (self.teacherHeaderBlock) {
        self.teacherHeaderBlock(self.indexPathSection);
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
