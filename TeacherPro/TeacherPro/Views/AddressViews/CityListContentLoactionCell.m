//
//  CityListContentLoactionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CityListContentLoactionCell.h"
#import "PublicDocuments.h"
@interface CityListContentLoactionCell()
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end


@implementation CityListContentLoactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cityName.font = fontSize_15;
    self.cityName.textColor = project_main_blue;
    self. detailLabel.font = fontSize_13;
    self.detailLabel.textColor = UIColorFromRGB(0x9f9f9f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)seutpCityName:(NSString *)name isShowImg:(BOOL )yesOrNo{
    
    self.cityName.text =  name;
    self.imgView.hidden = !yesOrNo;
    
}
@end
