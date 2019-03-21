//
//  TeachingAssistantsListItemImageContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListItemImageContentCell.h"
#import "AssistantsQuestionModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"
#import "PublicDocuments.h"

@interface TeachingAssistantsListItemImageContentCell()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (assign,nonatomic) CGFloat  imageOrangeH;
@end
@implementation TeachingAssistantsListItemImageContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubView];
    // Initialization code
    
}
 
- (void)setupSubView{
   
    self.contentImageView.clipsToBounds = YES;
    [self.stateBtn addTarget:self action:@selector(stateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.contentImageView.layer.masksToBounds = YES;
}
- (void)stateButtonAction:(UIButton *)sender{
    sender.selected =  !sender.selected;
    if (self.detailBlock) {
        self.detailBlock( self.indexPath ,self.imageOrangeH);
    }
}

- (void)setupButtonState:(BOOL)state{
    self.stateBtn.selected = state;
}
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height withIndex:(NSInteger)index {
    
    __block CGFloat contentImgVHeight =  0;
    contentImgVHeight = height;
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentImageView.userInteractionEnabled = YES;
    if (model.imgs) {
//        WEAKSELF
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs[index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            CGFloat cropHeight =  image.size.width/ weakSelf.contentImageView.frame.size.width *contentImgVHeight;
//
//            CGImageRef sourceImageRef = [image CGImage];
//            CGRect cropRect = CGRectMake(0, 0, image.size.width, cropHeight);
//            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
//            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//            weakSelf.contentImageView.image = newImage;
 
 
        }];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end

