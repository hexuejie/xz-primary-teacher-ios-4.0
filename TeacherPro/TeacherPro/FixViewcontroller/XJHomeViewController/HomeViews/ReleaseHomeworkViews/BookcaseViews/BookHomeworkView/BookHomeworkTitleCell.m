
//
//  BookHomeworkTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkTitleCell.h"
#import "PublicDocuments.h"
#import "BookPreviewModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"
#import "UIView+add.h"

@interface BookHomeworkTitleCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookType;
@property (weak, nonatomic) IBOutlet UILabel *leveLabel;


@property (weak, nonatomic) IBOutlet UIButton *changeBookBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bookUnitIconImgV;
@property (weak, nonatomic) IBOutlet UIImageView *bookTypeImgV;

@property (weak, nonatomic) IBOutlet UILabel *gameLabel;

@end
@implementation BookHomeworkTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    if (detailModel) {
         self.bookType.text = [NSString stringWithFormat:@"%@/%@",detailModel.subjectName,detailModel.bookTypeName];
    }else{
        
        self.bookType.text = @"";
    }
    if (detailModel.level != nil) {
        self.leveLabel.text = [NSString stringWithFormat:@"级别：%@",detailModel.level];
    }
    
   
    [self.bookImgV sd_setImageWithURL:[NSURL URLWithString:detailModel.coverImage] placeholderImage:placeholderImg];
    
    NSString * imageNameIcon = @"";
    NSString * unitIconImgName = @"";
    if ([detailModel.bookType  isEqualToString:@"Book"]) {
        imageNameIcon = @"homework_book_icon.png";
        
        for (PracticeTypeModel * typeModel in detailModel.practiceTypes) {
            if(typeModel.practiceType && [typeModel.practiceType isEqualToString:@"zxlx"]){
                unitIconImgName = @"homework_game_icon.png";
                self.gameLabel.hidden = NO;
            }
        }
      
    }else if ([detailModel.bookType isEqualToString:BookTypeCartoon]){
        imageNameIcon = @"homework_cartoon_icon.png";
    }else{
        
        imageNameIcon = @"homework_assistants_icon.png";
    }
    
    self.bookTypeImgV.image = [UIImage imageNamed: imageNameIcon];
    self.bookUnitIconImgV.image = [UIImage imageNamed:unitIconImgName];
}
- (IBAction)changeBookAction:(id)sender {
 
    if (self.changeBookBlock) {
        self.changeBookBlock();
    }

}

@end
