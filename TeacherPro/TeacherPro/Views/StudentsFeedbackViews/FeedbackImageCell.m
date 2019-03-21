
//
//  FeedbackImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "FeedbackImageCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "StudentHomeworkFeedbacksModel.h"
#import "PublicDocuments.h"

@interface FeedbackImageCell()
@property(nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;
@end
@implementation FeedbackImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{

    _picContainerView =  [SDWeiXinPhotoContainerView  new];
    [self.contentView  addSubview:_picContainerView];
    _picContainerView.sd_layout
    .leftSpaceToView(self.contentView,0); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置

}

- (void)setModel:(StudentFeedbackModel *)model{
    _picContainerView.isBack = YES;
    _picContainerView.otherType = YES;
    _picContainerView.picGeneralPathStringsArray = model.feedbackPhotos;
     _picContainerView.sd_layout.topSpaceToView(self.contentView, 0);
    UIView *bottomView;
    
    bottomView = _picContainerView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
