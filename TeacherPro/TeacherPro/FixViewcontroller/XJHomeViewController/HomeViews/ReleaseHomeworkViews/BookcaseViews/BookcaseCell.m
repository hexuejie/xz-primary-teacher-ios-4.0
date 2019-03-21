//
//  BookcaseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookcaseCell.h"
#import "BookcaseListsModel.h"
#import "UIImageView+WebCache.h"
#import "RepositoryListModel.h"
#import "PublicDocuments.h"
#import "UIView+add.h"

@interface BookcaseCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgV;
@property (weak, nonatomic) IBOutlet UIImageView *bookTypeImgV;
@property (weak, nonatomic) IBOutlet UILabel *bookTypeName;
@property (weak, nonatomic) IBOutlet UILabel *bookName;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bookUnitIconImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *hasBookSelfImgV;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;



@end
@implementation BookcaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

//    [self.bookImgV setCornerRadius:2.0 withShadow:YES withOpacity:10 withAlpha:0.08];
    
 
    self.bookTypeName.textColor = UIColorFromRGB(0x9f9f9f);
    self.bookTypeName.font = systemFontSize(14);
    self.bookName.textColor = UIColorFromRGB(0x6b6b6b);
    self.bookName.font = systemFontSize(16);
    self.bottomLine.backgroundColor = project_line_gray;
    self.hasBookSelfImgV.hidden = YES;
    self.gameLabel.font = fontSize_11;

    self.bookImgV.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.05].CGColor;//0.05
    self.bookImgV.layer.shadowOpacity = 8;
    self.bookImgV.layer.shadowOffset = CGSizeMake(0, 0);
    self.bookImgV.layer.shouldRasterize = NO;
//    self.bookImgV.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:radius] CGPath];

    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setupBookcaseInfo:(BookcaseModel *)model isEditState:(BOOL)editing{
    self.gameLabel.hidden = YES;
    UIImage * placeholderImg = [UIImage imageNamed:BooksPlaceholderImgName];
    NSURL * url =[NSURL URLWithString:model.coverImage];
    [self.bookImgV sd_setImageWithURL:url placeholderImage:placeholderImg];
    self.bookName.text = model.name;
    self.bookTypeName.text = [NSString stringWithFormat:@"%@/%@",model.subjectName,model.bookTypeName];
    
    self.deleteBtn.hidden = !editing;
  
//    if (self.deleteBtn.hidden) {
//        self.trailingWith.constant = 20;
//    }else{
//        self.trailingWith.constant = 50;
//    }
    self.trailingWith.constant = 30;
    
    NSString * imageNameIcon = @"";
    NSString * unitIconImgName = @"";
    if ([model.bookType  isEqualToString:@"Book"]) {
        imageNameIcon = @"homework_book_icon.png";
        
        for (NSDictionary * dic in model.practiceTypes) {
            if(dic[@"practiceType"] && [dic[@"practiceType"] isEqualToString:@"zxlx"]){
                unitIconImgName = @"homework_game_icon.png";
                self.gameLabel.hidden = NO;
            }
        }
        self.imageHeight.constant = 104;
    }else if ([model.bookType isEqualToString:BookTypeCartoon]){
        imageNameIcon = @"homework_cartoon_icon.png";
        self.imageHeight.constant = 98;
    }else{
        imageNameIcon = @"homework_assistants_icon.png";
        self.imageHeight.constant = 104;
    }
  
    self.bookTypeImgV.image = [UIImage imageNamed: imageNameIcon];
    self.bookUnitIconImgV.image = [UIImage imageNamed:unitIconImgName];
 
//    self.bookworkNumberLabel.text = [NSString stringWithFormat:@"共%@个练习",dic[@"workTotal"]];
}

- (void)setupSearchItemInfo:(RepositoryModel *)model{

    UIImage * placeholderImg = [UIImage imageNamed:BooksPlaceholderImgName];
    NSURL * url =[NSURL URLWithString:model.coverImage];
    [self.bookImgV sd_setImageWithURL:url placeholderImage:placeholderImg];
    self.bookName.text = model.name;
    self.bookTypeName.text = [NSString stringWithFormat:@"%@/%@",model.subjectName,model.bookTypeName];
    self.deleteBtn.hidden = YES;
    
    NSString * imageNameIcon = @"";
    NSString * unitIconImgName = @"";
    if ([model.bookType  isEqualToString:@"Book"]) {
        imageNameIcon = @"homework_book_icon.png";
        unitIconImgName = @"homework_game_icon.png";
    }else if ([model.bookType isEqualToString:BookTypeCartoon]){
        imageNameIcon = @"homework_cartoon_icon.png";
    }else{
        
        imageNameIcon = @"homework_assistants_icon.png";
    }
    
    self.bookTypeImgV.image = [UIImage imageNamed: imageNameIcon];
    self.bookUnitIconImgV.image = [UIImage imageNamed:unitIconImgName];

}

- (void)hasBookSelfState:(BOOL)state{
    if (state) {
        self.hasBookSelfImgV.hidden = NO;
    }else{
        self.hasBookSelfImgV.hidden = YES;
    }
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.index);
    }
    
}

@end
