//
//  RepositoryEmptyCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryEmptyCell.h"
#import "PublicDocuments.h"

@interface RepositoryEmptyCell()
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end
@implementation RepositoryEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
//    self.titleNameLabel.textColor = project_main_blue;
//    self.titleNameLabel.font = fontSize_12;
    
}
@end
