
//
//  BookcaseHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BookcaseHeaderView.h"
#import "PublicDocuments.h"
@interface BookcaseHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *labelFront;
@property (weak, nonatomic) IBOutlet UILabel *labelNext;


@end

@implementation BookcaseHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.infoLabel.font = systemFontSize(14);
    self.infoLabel.textColor = HexRGB(0x8A8F99);
//    self.numberLabel.font = fontSize_13;
//    self.numberLabel.textColor = UIColorFromRGB(0x68A8F99);//33AAFF
//    self.lineV.backgroundColor = project_line_gray;
    
}
- (void)setupNumber:(NSInteger )number withEditState:(BOOL)editState{
    NSString * info = @"";
    NSString * numberText = @"";
    if (editState) {
        info = @"请选择您要从书架移除的书籍";
        self.labelFront.hidden = YES;
        self.labelNext.hidden = YES;
    }else{
        
        self.labelFront.hidden = NO;
        self.labelNext.hidden = NO;
        info = @"请选择书籍布置作业";
        numberText = [NSString stringWithFormat:@"%zd",number];
    }
    self.infoLabel.text = info;
    self.numberLabel.text = numberText;
}

@end
