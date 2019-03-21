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
//  RewardGroupSectionHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RewardGroupSectionHeaderView.h"
#import "PublicDocuments.h"

@interface RewardGroupSectionHeaderView()
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation RewardGroupSectionHeaderView

- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{

    self.titleLabel.textColor = project_main_blue;
     [self.arrowImgV setImage:[[UIImage imageNamed:@"arrow_bottom_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.arrowImgV.tintColor = project_main_blue;
     self.numberLabel.textColor = project_main_blue;
     self.bottomLineV.backgroundColor = project_line_gray;
      self.numberLabel.font = fontSize_14;
     self.titleLabel.font = fontSize_14;
}

- (void)setupTitle:(NSString *)title withNumber:(NSString *)number withOpenState:(BOOL) isYesOrNo{


    if (isYesOrNo) {
        [self.arrowImgV setImage:[[UIImage imageNamed:@"arrow_top_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

    }else{
        [self.arrowImgV setImage:[[UIImage imageNamed:@"arrow_bottom_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

    }
    self.numberLabel.text = [NSString stringWithFormat:@"%@人",number];
    self.titleLabel.text = title;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
