
//
//  AssistantsQuestionItemStudentNameCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AssistantsQuestionItemStudentNameCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"

@interface AssistantsQuestionItemStudentNameCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation AssistantsQuestionItemStudentNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.nameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.nameLabel.font = fontSize_14;
    
}
- (void)setupName:(NSString *)name withAlignment:(NSTextAlignment )alignment{
    
    self.nameLabel.text = name;
    self.nameLabel.textAlignment = alignment;
}
@end
