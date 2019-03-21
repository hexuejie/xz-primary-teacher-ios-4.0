
//
//  BookHomeworkUnitSectionHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkUnitSectionHeaderView.h"
#import "PublicDocuments.h"

@interface BookHomeworkUnitSectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;

@end
@implementation BookHomeworkUnitSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{

    self.unitNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.unitNameLabel.font = fontSize_14;
}
- (void)setupUnitName:(NSString *)unitName{

    self.unitNameLabel.text = unitName;
}
@end
