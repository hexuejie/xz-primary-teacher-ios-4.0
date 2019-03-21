//
//  BookHomeworkAssistantsChildrenTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkAssistantsChildrenTitleCell.h"
#import "PublicDocuments.h"

@interface BookHomeworkAssistantsChildrenTitleCell (  )
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@property (weak, nonatomic) IBOutlet UILabel *childrenTilteLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation BookHomeworkAssistantsChildrenTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.backgroundColor = UIColorFromRGB(0xffffff);

}
- (void)setupChildrenTitle:(NSString *)title{
    
    self.childrenTilteLabel.text = title;
//    self.childrenTilteLabel.textColor = UIColorFromRGB(0x6b6b6b);
//    self.childrenTilteLabel.font = fontSize_14;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
