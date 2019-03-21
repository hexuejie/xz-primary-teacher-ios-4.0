
//
//  ChechHomeworkDetailBookUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailBookUnitCell.h"
#import "PublicDocuments.h"
@interface CheckHomeworkDetailBookUnitCell ()
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
@implementation CheckHomeworkDetailBookUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
-(void)setupSubview
{
    
    self.bottomLine.backgroundColor = project_line_gray;
    self.numberLabel.textColor = project_main_blue;
    self.numberLabel.font = fontSize_14;
    self.titleLabel.textColor = project_main_blue;
    self.titleLabel.font = fontSize_14;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.numberLabel.font = fontSize_14;
    self.detailLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.detailLabel.font = fontSize_14;
}
- (void)setupTitle:(NSString *)title withImageName:(NSString *)imageName withContent:(NSString *)content withDetail:(NSString *)detail withNumber:(NSString *)numberStr{

    self.titleLabel.text = title;
    self.iconImgV.image = [UIImage imageNamed:imageName];
    self.contentLabel.text = content;
    
     if (detail.length >0) {
         self.detailLabel.text = detail;
         self.detailLabel.hidden = NO;
     }else{
         self.detailLabel.hidden = YES;
     }
     self.numberLabel.text =  numberStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat totalHeight = 0;
//    
//    totalHeight += [self.contentLabel sizeThatFits:size].height;
//    
//    totalHeight += [self.detailLabel sizeThatFits:size].height;
//    totalHeight += FITSCALE(40); // margins
//    totalHeight += FITSCALE(20); // margins
//    return CGSizeMake(size.width, totalHeight);
//}
@end
