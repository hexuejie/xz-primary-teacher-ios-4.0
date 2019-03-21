//
//  CityListProvinceCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CityListProvinceCell.h"
#import "PublicDocuments.h"
@interface CityListProvinceCell()
@property (weak, nonatomic) IBOutlet UILabel *provinceName;
@end
@implementation CityListProvinceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.provinceName.font = fontSize_15;
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupProvince:(NSString *)name{

    self.provinceName.text = name;
    
}
@end
