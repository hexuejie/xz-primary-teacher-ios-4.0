//
//  HomeworkUnitDetailChooseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkUnitDetailChooseCell.h"
#import "HomeworkUnitDetailsModel.h"
#import "PublicDocuments.h"
@interface HomeworkUnitDetailChooseCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *answerImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation HomeworkUnitDetailChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.bottomLineView.backgroundColor = project_background_gray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupDetailModel:(HomeworkUnitDetailModel *)model{

    self.titleLabel.text = model.en;
    
    NSString * imageName = @"";
    if ([model.score integerValue]>0) {
      imageName =@"homework_choose_right";
    }else{
      imageName =@"homework_choose_error";
    }
    
    self.answerImgV.image = [UIImage imageNamed:imageName];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    
    totalHeight += FITSCALE(20); // margins
    totalHeight += FITSCALE(20); // margins
    return CGSizeMake(size.width, totalHeight);
}

@end
