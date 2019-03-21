
//
//  JFTopicParseItemOriginalCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicParseItemOriginalCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface JFTopicParseItemOriginalCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end
@implementation JFTopicParseItemOriginalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    [self.selectedBtn setTitle:@"使用原书解析" forState:UIControlStateNormal];
    self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectedBtn setTitleColor:UIColorFromRGB(0xb6b6b6) forState:UIControlStateNormal];
    [self.selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.selectedBtn setImage: [UIImage imageNamed:@"unselected_parse_icon"] forState:UIControlStateNormal];
    [self.selectedBtn setImage: [UIImage imageNamed:@"selected_parse_icon"] forState:UIControlStateSelected];
    
    UIImage  * normal_bg = [ProUtils  createImageWithColor:UIColorFromRGB(0xE2E2E2) withFrame:CGRectMake(0, 0, 1, 1)];
    UIImage  * selected_bg = [ProUtils  createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, 1, 1)];
    [self.selectedBtn setBackgroundImage:normal_bg forState:UIControlStateNormal];
    [self.selectedBtn setBackgroundImage:selected_bg forState:UIControlStateSelected];
    self.selectedBtn.layer.masksToBounds = YES;
    self.selectedBtn.layer.cornerRadius = 5;
   [ProUtils setupButtonContent:self.selectedBtn withType:ButtonContentType_imageRight];
   [self.selectedBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setupTextCell:(NSString *)analysis{
    
    self.orangeLabel.attributedText = [ProUtils strToAttriWithStr: analysis];
}
- (void)setupSelectedState:(BOOL )state{
    
    self.selectedBtn.selected = state;
}
- (void)selectAction:(UIButton *)sender{
    if(!sender.selected){
        sender.selected = YES;
        if (self.selectedAnalysisBlock) {
            self.selectedAnalysisBlock(self.indexPath);
        }
    }
    
}
@end
