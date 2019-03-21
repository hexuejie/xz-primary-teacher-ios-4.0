//
//  StudentHomeworkPictureBooksCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkPictureBooksCell.h"
#import "PublicDocuments.h"
@interface StudentHomeworkPictureBooksCell()
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineImgV;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation StudentHomeworkPictureBooksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.bottomLineImgV.backgroundColor = project_line_gray;
    self.scoreLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.titleLabel.textColor = project_main_blue;
    self.scoreLabel.font = fontSize_14;
    self.titleLabel.font = fontSize_14;
    
}
- (void)setupShowScore:(NSNumber *)score withTitle:(NSString *)title withImgName:(NSString *)imageName{
    
    if (score &&[score integerValue]>=0) {
        
         self.scoreLabel.text = [NSString stringWithFormat:@"%@分",score];
         self.scoreLabel.textColor =  UIColorFromRGB(0x2E8AFF);
    }else{
        
        self.scoreLabel.text = @"未完成";
        self.scoreLabel.textColor = UIColorFromRGB(0xff2e2e);
    }
    
    self.titleLabel.text = title;
    self.iconImgV.image = [UIImage imageNamed:imageName];
    
    
    
}

- (void)setupScore:(NSNumber *)score withTitle:(NSString *)title withImgName:(NSString *)imageName{

    if (score &&[score integerValue]>=0) {
        
         self.scoreLabel.text = @"已完成";
         self.scoreLabel.textColor =  UIColorFromRGB(0x2E8AFF);
    }else{
    
        self.scoreLabel.text = @"未完成";
         self.scoreLabel.textColor = UIColorFromRGB(0xff2e2e);
    }
    
    self.titleLabel.text = title;
    self.iconImgV.image = [UIImage imageNamed:imageName];
    
  

}

- (void)setupArrowImgV:(BOOL)isShow{
    
      self.arrowImgV.hidden = !isShow;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
