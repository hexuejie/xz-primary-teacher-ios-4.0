

//
//  HWGameTypeUnitTypeCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXSubUnitTypeCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"


@interface HWReportZXLXSubUnitTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *unityTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *unitTypeBgImgV;

@end
@implementation HWReportZXLXSubUnitTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}
- (void)setupSubViews{
    self.unityTypeLabel.font = fontSize_13;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    
    if (dic[@"title"]) {
        NSString * titleStr = dic[@"title"];
        self.unityTypeLabel.text = titleStr;
        NSString * bgImgName = @"";
        if ([titleStr isEqualToString:@"识意"]) {
            bgImgName = @"hw_game_type_unit_type_green_icon";
        }else if ([titleStr isEqualToString:@"拼写"]){
            bgImgName =  @"hw_game_type_unit_type_orange_icon";
            
        }else if ([titleStr isEqualToString:@"听说"]){
            bgImgName =  @"hw_game_type_unit_type_red_icon";
            
        }
        
//            self.unitTypeBgImgV.image = [UIImage imageNamed:bgImgName];
        UIImage  * bgImg = [ProUtils getResizableImage:[UIImage imageNamed:bgImgName]   withEdgeInset:UIEdgeInsetsMake(10, 10, 10, 10)];
 
         self.unitTypeBgImgV.image = bgImg;
    }
    
}
@end
