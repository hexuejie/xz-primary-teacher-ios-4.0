
//
//  HWBookInfoCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWBookInfoCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
#import "UIView+add.h"

@interface HWBookInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
@implementation HWBookInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}
- (void)setupSubViews{
    [self.bookImgV setCornerRadius:2.0 withShadow:YES withOpacity:10 withAlpha:0.08];
    
    self.bookNameLabel.font = fontSize_13;
    self.bookNameLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.bookTypeLabel.font = fontSize_13;
    self.bookTypeLabel.textColor = [UIColor whiteColor] ;
    self.subjectLabel.font = fontSize_13;
    self.subjectLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.numberLabel.font = fontSize_13;
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    UIColor * bookTypeBGColor = nil;
    //  且是教材
    if ([dic[@"bookType"] isEqualToString:@"Book"]) {
        bookTypeBGColor = UIColorFromRGB(0xF99E1C);
    }
    //绘本
    if ( [dic[@"bookType"] isEqualToString:BookTypeCartoon]) {
      bookTypeBGColor = UIColorFromRGB(0xF40083);
    }
    //教辅
    if ([dic[@"bookType"] isEqualToString:@"JFBook"]) {
        bookTypeBGColor = UIColorFromRGB(0x27D0FE);
    }
    self.bookTypeLabel.backgroundColor = bookTypeBGColor;
    self.bookTypeLabel.text = dic[@"bookTypeName"];
    self.bookNameLabel.text = dic[@"bookName"];
    if (dic[@"subjectName"]) {
         self.subjectLabel.text = [@"科目：" stringByAppendingString:dic[@"subjectName"]];
    }else{
        self.subjectLabel.text = @"";
    }
    self.numberLabel.text = [NSString stringWithFormat:@"共%@个练习",dic[@"workTotal"]];
    [self.bookImgV sd_setImageWithURL:[NSURL URLWithString:dic[@"coverImage"]] placeholderImage:[UIImage imageNamed:BooksPlaceholderImgName]];
    
  
}

@end
