//
//  ReleaseBookworkCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseBookworkCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
#import "UIView+add.h"

@interface ReleaseBookworkCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgV;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;//关闭
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//布置时间
@property (weak, nonatomic) IBOutlet UILabel *bookworkNumberLabel;//布置作业数量
@property (weak, nonatomic) IBOutlet UILabel *bookworkPress;//
@property (weak, nonatomic) IBOutlet UILabel *bookName;//书本名字
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;//书本图片

@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@property (weak, nonatomic) IBOutlet UIImageView *jfIconImgV;//是否是教辅作业
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet UIView *testView;


@end
@implementation ReleaseBookworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.jfIconImgV.hidden = YES;
    self.bottomLine.hidden =YES;
   

    self.backgroundImgV.backgroundColor = [UIColor whiteColor];
    [self.bookImgV setImage:[UIImage imageNamed:BooksPlaceholderImgName]];
    [self.closeButton addTarget:self action:@selector(deleteBookhomework) forControlEvents:UIControlEventTouchUpInside];
    self.lineView.backgroundColor = project_line_gray;

    [self.bookImgV setCornerRadius:2.0 withShadow:YES withOpacity:10 withAlpha:0.08];
    
}

- (UIImage *)cornerImage:(UIImage *)image{
    
    UIGraphicsBeginImageContext(image.size);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2.0] addClip];
    
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)deleteBookhomework{

    if (self.deleteBlock) {
        self.deleteBlock(self.index);
    }
    
}

- (void)setupBookworkInfo:(NSString *)info{
    NSData * newdata = [info dataUsingEncoding:NSUTF8StringEncoding];      //theXML为nsstring
    id json = [NSJSONSerialization JSONObjectWithData:newdata options:0 error:nil];
    
    self.bookName.text = json[@"name"];
    [self.bookImgV  sd_setImageWithURL:json[@"bookImg"] placeholderImage:[UIImage imageNamed:BooksPlaceholderImgName]];
    self.bookImgV.image = [self cornerImage:self.bookImgV.image];
    if (json[@"subjectName"] && [json[@"subjectName"] length] >0) {
         self.bookworkPress.text = [NSString stringWithFormat:@"%@/%@",json[@"subjectName"],json[@"bookTypeName"]];
    }else{
     self.bookworkPress.text = [NSString stringWithFormat:@"%@",json[@"bookTypeName"]];
    }
   
    self.bookworkNumberLabel.text = [NSString stringWithFormat:@"共%@个练习",json[@"workTotal"]];

}


- (void)setuphomeworkBookInfo:(NSDictionary *)dic{

    self.bookName.text = dic[@"bookName"];
    [self.bookImgV  sd_setImageWithURL:dic[@"coverImage"] placeholderImage:[UIImage imageNamed:BooksPlaceholderImgName]];
    self.bookImgV.image = [self cornerImage:self.bookImgV.image];
    self.imageHeight.constant = 104;
    //找出绘本
    if ([dic[@"bookType"] isEqualToString:BookTypeCartoon]) {
        NSString * bookworkPrees = @"";
        if (dic[@"subjectName"]) {
            bookworkPrees =  [NSString stringWithFormat:@"%@/%@",dic[@"subjectName"],@"绘本"];
        }else{
            bookworkPrees = @"绘本";
        }
        self.bookworkPress.text = bookworkPrees;
        self.imageHeight.constant = 91;
    }else  if ([dic[@"bookType"] isEqualToString:@"Book"]){
       self.bookworkPress.text = [NSString stringWithFormat:@"%@/%@",dic[@"subjectName"],@"教材"];
        self.bookworkNumberLabel.hidden = NO;
    }else if ([dic[@"bookType"] isEqualToString:@"JFBook"]){
        self.bookworkPress.text = [NSString stringWithFormat:@"%@/%@",dic[@"subjectName"],@"教辅"];
        self.bookworkNumberLabel.hidden = NO;
         self.jfIconImgV.hidden = NO;
    }
    self.bookworkNumberLabel.text = [NSString stringWithFormat:@"共%@个练习",dic[@"workTotal"]];
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showHemoworkDetailType{
    [self hidenDeleteBtn];
    [self showBottomLine];
    
}
- (void)showBottomLine{
    self.bottomLine.hidden = NO;
}
- (void)hidenDeleteBtn{
    
    self.closeButton.hidden = YES;
}
@end
