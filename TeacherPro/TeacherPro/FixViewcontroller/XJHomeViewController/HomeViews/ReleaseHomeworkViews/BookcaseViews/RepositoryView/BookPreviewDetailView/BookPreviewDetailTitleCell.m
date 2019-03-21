//
//  BookPreviewDetailTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookPreviewDetailTitleCell.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "BookPreviewModel.h"
#import "UIView+add.h"

@interface BookPreviewDetailTitleCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookType;
 
@property (weak, nonatomic) IBOutlet UIImageView *bookUnitIconImgV;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;


@end
@implementation BookPreviewDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    [self.bookImgV setCornerRadius:2.0 withShadow:YES withOpacity:10 withAlpha:0.08];
    
    self.gameLabel.layer.cornerRadius = 2.0;
    self.gameLabel.layer.masksToBounds = YES;
    self.gameLabel.layer.borderColor = [self.gameLabel.textColor CGColor];
    self.gameLabel.layer.borderWidth = 1.0;
}

-(void)setupPreviewDetailInfo:(BookPreviewDetailModel *)detailModel{

    UIImage * placeholderImg = [UIImage imageNamed:BooksPlaceholderImgName];
    
    self.bookName.text = detailModel.name;
    self.bookType.text = [NSString stringWithFormat:@"%@/%@",detailModel.subjectName,detailModel.bookTypeName];
    [self.bookImgV sd_setImageWithURL:[NSURL URLWithString:detailModel.coverImage] placeholderImage:placeholderImg];
    if (detailModel.level != nil) {
        self.levelLabel.text = [NSString stringWithFormat:@"级别：%@",detailModel.level];
    }
    
 
    NSString * unitIconImgName = @"";
    if ([detailModel.bookType  isEqualToString:@"Book"]) {
        for (PracticeTypeModel * typeModel in detailModel.practiceTypes) {
            if(typeModel.practiceType && [typeModel.practiceType isEqualToString:@"zxlx"]){
                 unitIconImgName = @"homework_game_icon.png";
                self.gameLabel.hidden = NO;
            }
        }
       
    }else if ([detailModel.bookType isEqualToString:BookTypeCartoon]){
      
    }else{
        
        
    }
    
 
    self.bookUnitIconImgV.image = [UIImage imageNamed:unitIconImgName];
    
}


@end
