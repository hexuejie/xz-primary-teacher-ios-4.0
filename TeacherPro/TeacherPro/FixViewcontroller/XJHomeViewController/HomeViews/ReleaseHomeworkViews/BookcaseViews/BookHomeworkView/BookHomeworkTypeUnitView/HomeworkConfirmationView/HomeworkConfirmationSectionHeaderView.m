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
//  HomeworkConfirmationSectionHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkConfirmationSectionHeaderView.h"
#import "PublicDocuments.h"
@interface HomeworkConfirmationSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@end
@implementation HomeworkConfirmationSectionHeaderView
- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupSubview];
}
- (void)setupSubview{
    self.sectionTitleLabel.font = fontSize_14;
    self.sectionTitleLabel.textColor = UIColorFromRGB(0x434343);
    self.leftView.backgroundColor = project_main_blue;
    self.bgView.backgroundColor = UIColorFromRGB(0xdaeafe);
    
}
- (void)setupSectionTitle:(NSAttributedString *)attributedString{

    self.sectionTitleLabel.attributedText = attributedString;
    
}
@end
