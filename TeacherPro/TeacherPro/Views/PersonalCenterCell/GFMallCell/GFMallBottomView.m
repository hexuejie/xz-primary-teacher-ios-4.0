//
//  GFMallBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallBottomView.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface GFMallBottomView()
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation GFMallBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{
    self.lineView.backgroundColor = project_line_gray;
    self.desLabel.textColor = project_main_blue;
    self.desLabel.font = fontSize_13;
    NSString *desStr = [NSString stringWithFormat:@"*%@",[self getTitle] ];
    
    NSRange  range = [desStr rangeOfString:[self getTitle]];
    UIColor * color = UIColorFromRGB(0x333333);
    self.desLabel.attributedText = [ProUtils setAttributedText:desStr withColor:color withRange:range withFont:fontSize_14];
    
    NSRange  xrange = [desStr rangeOfString:@"*"];
    UIColor * xcolor = UIColorFromRGB(0xfe0200);
    self.desLabel.attributedText = [ProUtils setAttributedText:desStr withColor:xcolor withRange:xrange withFont:fontSize_14];
}
- (NSString *)getTitle{
     NSString * titleStr = @"兑换须知:";
    return titleStr;
}

@end
