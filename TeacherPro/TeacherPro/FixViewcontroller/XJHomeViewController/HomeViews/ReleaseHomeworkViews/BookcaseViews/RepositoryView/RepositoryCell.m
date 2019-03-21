//
//  RepositoryCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryCell.h"
#import "RepositoryListModel.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface RepositoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UIImageView *bookTypeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *hasInBookShelfImgV;

@end
@implementation RepositoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.bookImgV.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.05].CGColor;//0.05
    self.bookImgV.layer.shadowOpacity = 8;
    self.bookImgV.layer.shadowOffset = CGSizeMake(0, 0);
//    self.bookImgV.layer.shadowRadius = 5;
    self.bookImgV.layer.shouldRasterize = NO;
    
    self.hasInBookShelfImgV.backgroundColor = [UIColor clearColor];
    
}
- (void)setupRepositoryInfo:(RepositoryModel *)model  {
    
    UIImage * placeholderImg = [UIImage imageNamed:BooksPlaceholderImgName];
    NSURL * url =[NSURL URLWithString:model.coverImage];
    [self.bookImgV sd_setImageWithURL:url placeholderImage:placeholderImg];
    self.bookName.text = model.name;
  
    
    NSString * imageNameIcon = @"";
    self.imageHeight.constant = 123;
    if ([model.bookType  isEqualToString:@"Book"]) {
        imageNameIcon = @"homework_book_icon.png";
    }else if ([model.bookType isEqualToString:BookTypeCartoon]){
        self.imageHeight.constant = 116;
        imageNameIcon = @"homework_cartoon_icon.png";
    }else{
        imageNameIcon = @"homework_assistants_icon.png";
    }
    
    self.bookTypeImgV.image = [UIImage imageNamed: imageNameIcon];
    if ([model.hasInBookShelf integerValue] == 1) {
        self.hasInBookShelfImgV.hidden = NO;
    }else{
        self.hasInBookShelfImgV.hidden = YES;
    }
    
    [ProUtils changeLineSpaceForLabel:self.bookName WithSpace:UILABEL_LINE_SPACE];
}


@end
