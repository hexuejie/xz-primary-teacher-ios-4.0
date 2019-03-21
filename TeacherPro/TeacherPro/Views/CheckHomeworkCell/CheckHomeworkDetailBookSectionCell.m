//
//  CheckHomeworkBookSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//


//
//{
//    [
//     {page:1,no:1,audioSrc:"/ios/dist/a.mp3"},
//     {page:1,no:2,audioSrc:"/ios/dist/b.mp3"}
//    ],[
//       {page:2,no:1,audioSrc:"/ios/dist/c.mp3"},
//       {page:2,no:1,audioSrc:"/ios/dist/d.mp3"}
//    ]
//    ...
//}

//书本类型
#import "CheckHomeworkDetailBookSectionCell.h"
#import "PublicDocuments.h"
@interface CheckHomeworkDetailBookSectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
 
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
@implementation CheckHomeworkDetailBookSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setupTitle:(NSString *)title withImageName:(NSString *)imageName  withCount:(NSString *)countStr withNumber:(NSString *)numberStr {
    self.titleLabel.text = title;
//    self.iconImgV.image = [UIImage imageNamed:imageName];
    self.numberLabel.text =  numberStr;
    self.countLabel.text =  countStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
