//
//  MyBooksCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MyBooksCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "HomeListModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+add.h"

@interface MyBooksCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIImageView *addImgV;



@end
@implementation MyBooksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = systemFontSize(13);
    self.titleLabel.textColor = UIColorFromRGB(0x525B66);
    [self.titleLabel sizeToFit];
    
//    [self.iconImgV setCornerRadius:2.0 withShadow:YES withOpacity:10 withAlpha:0.08];
    self.iconImgV.layer.masksToBounds = YES;
    self.iconImgV.layer.cornerRadius = 4.0;
    self.iconImgV.layer.borderWidth = 1.0;
    self.iconImgV.layer.borderColor = HexRGB(0xF5F5F5).CGColor;
    
}
- (void)setupBookData:(id)bookModel{
    
     HomeBooksModel * model = bookModel;
     UIImage * placeholderImg = [UIImage imageNamed:BooksPlaceholderImgName];
     self.titleLabel.text = model.name;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.coverImage] placeholderImage:placeholderImg];
    self.addImgV.hidden = YES;
    [ProUtils changeLineSpaceForLabel:self.titleLabel WithSpace:UILABEL_LINE_SPACE];
    
    
}
- (void)setupAddBookUI{
    
    [self.iconImgV setImage:[UIImage imageNamed:@"home_shuben_add_bg.png"]];
    self.titleLabel.text = @"添加书籍";
    self.addImgV.hidden = NO;
}
@end
