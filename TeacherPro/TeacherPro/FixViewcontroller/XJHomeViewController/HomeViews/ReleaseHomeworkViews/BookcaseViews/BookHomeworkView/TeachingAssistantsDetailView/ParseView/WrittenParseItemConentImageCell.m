//
//  WrittenParseItemConentImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WrittenParseItemConentImageCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
#import "AssistantsQuestionModel.h" 
#import "ProUtils.h"
@interface WrittenParseItemConentImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (assign, nonatomic) NSInteger  imageOrangeH;
@end
@implementation WrittenParseItemConentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}


- (void)setupSubView{
 
    self.stateBtn.layer.masksToBounds = YES;
}
- (IBAction)stateButtonAction:(UIButton *)sender{
    sender.selected =  !sender.selected;
    if (self.detailBlock) {
        self.detailBlock(self.imageOrangeH);
    }
}

- (void)setupButtonState:(BOOL)state{
    
    self.stateBtn.selected = state;
}
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height {
    
    __block CGFloat contentImgVHeight =  0;
       contentImgVHeight = height;
  
        self.contentImgV.contentMode = UIViewContentModeScaleAspectFill;
    
    if (model.imgs) {
        WEAKSELF
        [self.contentImgV sd_setImageWithURL:[NSURL URLWithString:model.imgs.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat cropHeight =  image.size.width/ weakSelf.contentImgV.frame.size.width *contentImgVHeight;
            
            CGImageRef sourceImageRef = [image CGImage];
            CGRect cropRect = CGRectMake(0, 0, image.size.width, cropHeight);
            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
            weakSelf.contentImgV.image = newImage;
//            STRONGSELF
//            UIImage *tempImage  =  [ProUtils imageCompressForWidth:image targetWidth:self.frame.size.width];
//            if (tempImage.size.height < contentImgVHeight) {
//                contentImgVHeight = image.size.height;
//                strongSelf.contentImgV.contentMode = UIViewContentModeScaleAspectFit;
//                strongSelf.imageOrangeH = self.defaultHeight;
//            }else{
//
//                strongSelf.contentImgV.image = [ProUtils imageCompressForWidth:image targetWidth:self.frame.size.width];
//
//                strongSelf.imageOrangeH = strongSelf.contentImgV.image.size.height;
//            }
            
        }];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
