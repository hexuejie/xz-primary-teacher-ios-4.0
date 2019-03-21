//
//  WrittenParseItemUploadImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WrittenParseItemUploadImageCell.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
@interface WrittenParseItemUploadImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation WrittenParseItemUploadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
    self.imageV.userInteractionEnabled = YES;
    self.deleteBtn.hidden = YES;
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage)];
    [self.imageV addGestureRecognizer:tap];
}
- (void)setupImage:(UIImage *)image{
    self.deleteBtn.hidden = NO;
    self.imageV.image = image;
    [self setupBoundsLayer:YES];
    
}
- (void)setupBoundsLayer:(BOOL)show{
    CGFloat cornerRadius = 0;
    BOOL masksToBounds = NO;
    CGColorRef borderColor = [UIColor clearColor].CGColor ;
    if (show) {
        borderColor =  project_main_blue.CGColor;
        cornerRadius = 15;
        masksToBounds = YES;
    }else{
        borderColor =  [UIColor clearColor].CGColor;
        cornerRadius = 0;
        masksToBounds = NO;
  
    }
    self.imageV.layer.masksToBounds = masksToBounds;
    self.imageV.layer.cornerRadius = cornerRadius;
    self.imageV.layer.borderWidth = 1;
    self.imageV.layer.borderColor = borderColor;
}
- (void)setupImageUrl:(NSString *)imageUrl{
    self.deleteBtn.hidden = NO;
   [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self setupBoundsLayer:YES];
}

- (void)addImage{
    if (self.addImageBlock) {
        self.addImageBlock();
    }

}
- (void)setupSubview{
    
    self.bgView.backgroundColor = [UIColor whiteColor];
}
- (IBAction)deleteBtn:(id)sender {
    self.deleteBtn.hidden = YES;
    self.imageV.image = [UIImage imageNamed:@"parse_picture_add"];
    [self setupBoundsLayer:NO];
    if (self.deleteImageBlock) {
        self.deleteImageBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
