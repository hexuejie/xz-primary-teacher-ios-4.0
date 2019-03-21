//
//  AssistantsQuestionItemContentImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AssistantsQuestionItemContentImageCell.h"
#import "UIImageView+WebCache.h"
#import "HomeworkAssitantsQuestionsListModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface AssistantsQuestionItemContentImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
@implementation AssistantsQuestionItemContentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupItemContent:(HomeworkAssitantsQuestionModel *)model withHeight:(CGFloat )heght withIndexPath:(NSInteger) index{
 
    CGFloat contentImgVHeight =  heght;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (model.imgs) {
        WEAKSELF
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgs[index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            CGFloat cropHeight =  image.size.width/ weakSelf.imgView.frame.size.width *contentImgVHeight;
//
//            CGImageRef sourceImageRef = [image CGImage];
//            CGRect cropRect = CGRectMake(0, 0, image.size.width, cropHeight);
//            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
//            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//            weakSelf.imgView.image = newImage;
//            STRONGSELF
//            UIImage *tempImage  =  [ProUtils imageCompressForWidth:image targetWidth:self.frame.size.width];
//
//            if (tempImage.size.height <= contentImgVHeight) {
//                
//                strongSelf.imgView.contentMode = UIViewContentModeScaleAspectFit;
//
//
//            }else{
////
////                strongSelf.imageOrangeH = strongSelf.imgView.image.size.height;
//                strongSelf.imgView.image = [ProUtils imageCompressForWidth:image targetWidth:self.frame.size.width];
////                strongSelf.imageOrangeH = strongSelf.imgView.image.size.height;
//
//            }
            
        }];
    }
    
}
@end
