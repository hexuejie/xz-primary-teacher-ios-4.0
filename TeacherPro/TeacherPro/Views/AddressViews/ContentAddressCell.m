//
//  ContentAddressCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ContentAddressCell.h"
#import "PublicDocuments.h"
@interface ContentAddressCell()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailLabel;

@end
@implementation ContentAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.locationLabel.font = fontSize_15;
    self.locationDetailLabel.font = fontSize_13;
    self.locationLabel.textColor = project_main_blue;
  
    self.locationDetailLabel.textColor = UIColorFromRGB(0x9f9f9f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTitle:(NSString *)locationTitle{

    self.locationLabel.text = locationTitle;
}

-(IBAction)loactionAction:(id)sender{

    if (self.block) {
        self.block();
    }
}
@end
