
//
//  ChooseParseItemContentImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseParseItemContentImageCell.h"
#import "AssistantsQuestionModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface ChooseParseItemContentImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (assign, nonatomic) NSInteger  imageOrangeH;

@end
@implementation ChooseParseItemContentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubView];
    // Initialization code
}
- (void)setupSubView{
    
    self.stateBtn.layer.masksToBounds = YES;
}
- (void)setupModel:(QuestionModel *)model{
    
    if ( model.imgs) {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs.firstObject]];
    }
    
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
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height withIndexPath:(NSInteger )index {
    
    __block CGFloat contentImgVHeight =  0;
      contentImgVHeight = height;
     self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
  
    if (model.imgs) {
        WEAKSELF
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs[index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
             CGFloat cropHeight =  image.size.width/ weakSelf.contentImageView.frame.size.width *contentImgVHeight;
//
//            CGImageRef sourceImageRef = [image CGImage];
//             CGRect cropRect = CGRectMake(0, 0, image.size.width, cropHeight);
//            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
//            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//            weakSelf.contentImageView.image = newImage;
//            STRONGSELF
//            UIImage *tempImage  =  [ProUtils imageCompressForWidth:image targetWidth:self.frame.size.width];
//            if (tempImage.size.height <= contentImgVHeight) {
//                contentImgVHeight = image.size.height;
//                strongSelf.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
//                strongSelf.imageOrangeH = self.defaultHeight;
//
//            }else{
//
//                  strongSelf.imageOrangeH = strongSelf.contentImageView.image.size.height;
//                  strongSelf.contentImageView.image = [ProUtils imageCompressForWidth:image targetWidth:self.frame.size.width];
//                 strongSelf.imageOrangeH = strongSelf.contentImageView.image.size.height;
//
//            }
//
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
