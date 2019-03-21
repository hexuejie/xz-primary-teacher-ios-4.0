//
//  AddReleaseEditMattersCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AddReleaseEditMattersCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"

@interface AddReleaseEditMattersCell()


@end
@implementation AddReleaseEditMattersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//     self.detailLabel.font = fontSize_14;
//     self.detailLabel.textColor = UIColorFromRGB(0xc3c3c3);
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:_countLabel.text];
    NSRange redRange = NSMakeRange([_countLabel.text rangeOfString:@"/1000"].location,[_countLabel.text rangeOfString:@"/1000"].length);
    //修改特定字符的颜色
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:HexRGB(0xB3B3B3) range:redRange];
    _countLabel.attributedText = attrDescribeStr;
}



@end
