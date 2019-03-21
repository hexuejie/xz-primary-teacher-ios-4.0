//
//  CheckHomeworkDetailImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailImageCell.h"
#import "CheckHomeworkDetailModel.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "PublicDocuments.h"
@interface CheckHomeworkDetailImageCell()
@property(nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;
@property(nonatomic, strong) UIView *lineView;
@end
@implementation CheckHomeworkDetailImageCell

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
//    self.contentView.backgroundColor = [UIColor redColor];
    _picContainerView =  [SDWeiXinPhotoContainerView  new];
    [self.contentView  addSubview:_picContainerView];
    _picContainerView.sd_layout
    .leftSpaceToView(self.contentView ,0); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    _lineView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(FITSCALE(0.5))
    .bottomEqualToView(self.contentView);
    _lineView.backgroundColor = project_line_gray;
    
}

- (void)setModel:(CheckHomeworkDetailModel *)model{
    
    _picContainerView.sd_layout.topSpaceToView(self.contentView, 0);
    _picContainerView.otherType = YES;
//    _picContainerView.picPathStringsArray = model.photos;
    _picContainerView.picGeneralPathStringsArray = model.photos;
  
    UIView *bottomView;
    bottomView = _picContainerView;
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
