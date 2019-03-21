//
//  HWCompleteStateHeaderV.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/12.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWCompleteStateHeaderV.h"
#import "PublicDocuments.h"

@interface HWCompleteStateHeaderV()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
@implementation HWCompleteStateHeaderV
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubView];
}
- (void)setupSubView{
    self.titleLabel.textColor = UIColorFromRGB(0x9b9b9b);
    self.titleLabel.font = fontSize_13;
    self.numberLabel.textColor = UIColorFromRGB(0x9b9b9b);
    self.numberLabel.font = fontSize_13;
}
- (void)setupTitleStr:(NSString *)titleStr  withNumber:(NSInteger)number{
    
    self.titleLabel.text = titleStr;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",number];
    
}
@end
