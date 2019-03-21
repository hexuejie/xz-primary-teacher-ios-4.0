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
//  BookHomeworkSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkSectionView.h"
#import "PublicDocuments.h"

@interface BookHomeworkSectionView()

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *bookLabel;//书本
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@end
@implementation BookHomeworkSectionView

- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{

//    self.titleLabel.textColor = project_main_blue;
//    self.titleLabel.font = fontSize_14;
//    self.bookLabel.textColor = project_main_blue;
//    self.bookLabel.font = fontSize_14;
//    [self.rightBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
//    self.rightBtn.titleLabel.font = fontSize_14;
//    self.bottomLineV.backgroundColor = project_line_gray;
    
}

- (IBAction)rightButtonAction:(id)sender {
    
    if (self.clearBlock) {
        self.clearBlock();
    }
}
- (void)setupEditState:(BOOL )isEdit{

    self.rightBtn.hidden = !isEdit;
    self.bookLabel.hidden = YES;
    
}

- (void)setupBookTitle:(NSAttributedString *)attributedStr withEditState:(BOOL )isEdit{
    self.bookLabel.attributedText = attributedStr;
    self.titleLabel.hidden = YES;
    self.iconImgV.hidden = YES;
    self.rightBtn.hidden = !isEdit;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
