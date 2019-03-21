
//
//  CheckHomeworkDetailTextCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailTextCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface CheckHomeworkDetailTextCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation CheckHomeworkDetailTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentLabel sizeToFit];
 
}
- (void)setupTextCell:(NSString *)text{

    self.contentLabel.text = text;
//    self.numberLabel.text = [NSString stringWithFormat:@"%zd/1000",text.length];
//    [ProUtils changeLineSpaceForLabel: self.contentLabel WithSpace:UILABEL_LINE_SPACE];
   
}

//- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat totalHeight = 0;
//    
//    totalHeight += [self.contentLabel sizeThatFits:size].height;
//    totalHeight += [self.numberLabel sizeThatFits:size].height;
//    
//    totalHeight +=   FITSCALE(30) ; // margins
//  
//    return CGSizeMake(size.width, totalHeight);
//}

@end
