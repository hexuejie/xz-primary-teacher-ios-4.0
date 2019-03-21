//
//  JFHomeworkTopicImageContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFHomeworkTopicImageContentCell.h"
#import "AssistantsQuestionModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface JFHomeworkTopicImageContentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@end

@implementation JFHomeworkTopicImageContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    [self setupSubView];
 
}
- (void)setupSubView{
     
}

- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height withIndexPath:(NSInteger )index {
    
    
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (model.imgs) {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs[index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
