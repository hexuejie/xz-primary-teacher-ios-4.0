//
//  PhonicsHomeworkCollectionViewHeader.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/7.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "PhonicsHomeworkCollectionViewHeader.h"
#import "PublicDocuments.h"
#import "BookPreviewModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"
#import "UIView+add.h"

@interface PhonicsHomeworkCollectionViewHeader()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookType;


@property (weak, nonatomic) IBOutlet UIButton *changeBookBtn;

@end

@implementation PhonicsHomeworkCollectionViewHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
    [self.bookImgV setCornerRadius:2.0 withShadow:YES withOpacity:10 withAlpha:0.08];
    
}

-(void)setupPreviewDetailInfo:(BookPreviewDetailModel *)detailModel{
    
    UIImage * placeholderImg = [UIImage imageNamed:BooksPlaceholderImgName];
    
    self.bookName.text = detailModel.name;
    if (detailModel) {
        self.bookType.text = [NSString stringWithFormat:@"%@/%@",detailModel.subjectName,detailModel.bookTypeName];
    }else{
        
        self.bookType.text = @"";
    }
    
    
    [self.bookImgV sd_setImageWithURL:[NSURL URLWithString:detailModel.coverImage] placeholderImage:placeholderImg];
    
    NSString * imageNameIcon = @"";
    NSString * unitIconImgName = @"";
    if ([detailModel.bookType  isEqualToString:@"Book"]) {
        imageNameIcon = @"homework_book_icon.png";
        
        for (PracticeTypeModel * typeModel in detailModel.practiceTypes) {
            if(typeModel.practiceType && [typeModel.practiceType isEqualToString:@"zxlx"]){
                unitIconImgName = @"homework_game_icon.png";
               
            }
        }
        
    }else if ([detailModel.bookType isEqualToString:BookTypeCartoon]){
        imageNameIcon = @"homework_cartoon_icon.png";
    }else{
        
        imageNameIcon = @"homework_assistants_icon.png";
    }
}

@end
