

//
//  RepositoryTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryTitleCell.h"
#import "PublicDocuments.h"

@interface RepositoryTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIView *bottomLinew;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end
@implementation RepositoryTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{

     self.titleName.text = @"全部资源";
    self.titleName.textColor = UIColorFromRGB(0x9f9f9f);
    self.titleName.font = fontSize_10;
    self.bottomLinew.backgroundColor = project_line_gray;
    self.topLine.backgroundColor = project_line_gray;
 
}
@end
