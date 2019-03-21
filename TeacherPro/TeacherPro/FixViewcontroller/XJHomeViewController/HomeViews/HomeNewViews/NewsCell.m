

//
//  NewsCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "NewsCell.h"
#import "PublicDocuments.h"
#import "HomeListModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"

@interface NewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *yueduLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.titleLabel.font = fontSize_12;
//    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
//    self.userName.font = fontSize_12;
    self.userName.hidden = YES;
//    self.userName.textColor = UIColorFromRGB(0x9b9b9b);
//    self.yueduLabel.font = fontSize_10;
//    self.yueduLabel.textColor = UIColorFromRGB(0x9b9b9b);
    self.iconImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImgV.backgroundColor = [UIColor clearColor];
    self.iconImgV.layer.masksToBounds = YES;
    self.iconImgV.layer.cornerRadius = 4.0;
    
    self.iconImgV.layer.borderWidth = 1.0;
    self.iconImgV.layer.borderColor = HexRGB(0xF5F5F5).CGColor;
    
    self.titleLabel.textColor = HexRGB(0x525b66);
}
- (void)setupNewsModel:(HomeNewsModel *)model{
    
    self.titleLabel.text = model.title;
    self.yueduLabel.text = [NSString stringWithFormat:@"阅读 %@",model.readCount];
    if(model.coverUrlArray.firstObject){
    
        [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.coverUrlArray.firstObject]];
    }
   [ProUtils changeLineSpaceForLabel:self.titleLabel WithSpace:UILABEL_LINE_SPACE];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
