//
//  BookHomeworkItemCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkItemCell.h"
#import "HeardAndWordTypeModel.h"
#import "PublicDocuments.h"

@interface BookHomeworkItemCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *centerLine;

@end
@implementation BookHomeworkItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{

    self.nameLabel.textColor = project_main_blue;
    self.nameLabel.font = fontSize_14;
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_12;
    self.bottomLine.backgroundColor = project_line_gray;
    self.centerLine.backgroundColor = project_line_gray;
}
- (void)setupItem:(AppTypesModel *)model withIconImgName:(NSString *)imgName withType:(BookHomeworkItemType )type{

    self.nameLabel.text = model.typeCn;
    [self.iconImgV setImage:[UIImage imageNamed: imgName]];
    
     NSString * detail = @"";
    if (BookHomeworkItemType_word == type) {
        NSInteger   totalDuration = 1 ;
        NSInteger  tempDurationTime = [model.durationTime integerValue] * [model.count integerValue];
        
        if ( tempDurationTime/60 <1) {
            totalDuration = 1;
        }else{
            totalDuration = (int)(tempDurationTime/60);
        }
        detail = [NSString stringWithFormat:@"共%@词 约%ld分钟",model.count,totalDuration];
    }else if (BookHomeworkItemType_heard == type){
        NSInteger   totalDuration = 1 ;
        NSInteger  tempDurationTime = [model.durationTime integerValue] * [model.count integerValue];
        if ( tempDurationTime/60 < 1) {
            totalDuration = 1;
        }else{
           totalDuration = (int)(tempDurationTime/60);
            
        }
        detail = [NSString stringWithFormat:@"共%@句 约%ld分钟",model.count,totalDuration];
        
    }
    self.detailLabel.text = detail;
}

- (void)setupChooseState:(BOOL )selected{

    NSString * chooseImgName = @"";
    
    if (selected) {
        chooseImgName = @"homework_item_selected.png";
    }
     self.chooseImgV.image = [UIImage imageNamed:chooseImgName];
}
@end
