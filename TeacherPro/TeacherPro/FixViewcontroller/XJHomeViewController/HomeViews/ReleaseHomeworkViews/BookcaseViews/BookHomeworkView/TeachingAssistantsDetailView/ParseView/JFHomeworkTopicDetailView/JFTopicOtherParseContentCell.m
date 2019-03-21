
//
//  JFTopicOtherParseContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicOtherParseContentCell.h"
#import "JFTopicOtherTeacherParseModel.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
#import "SDWeiXinPhotoContainerView.h"
#import "ProUtils.h"
@interface JFTopicOtherParseContentCell()
@property (strong, nonatomic)   UILabel *msgLabel;
@property (strong, nonatomic)   UIView *bgView;
@property (strong, nonatomic)   SDWeiXinPhotoContainerView *picContainerView;
@end
@implementation JFTopicOtherParseContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        [self setupSelectedBackgrondView];
    }
    return self;
}
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
     
    self.msgLabel = [UILabel  new];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.backgroundColor = [UIColor clearColor];
    
    self.msgLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.msgLabel.font = [UIFont systemFontOfSize:14];
    
    self.picContainerView = [SDWeiXinPhotoContainerView new];
    self.picContainerView.backgroundColor= [UIColor clearColor];
    self.picContainerView.isShowBorder = YES;
       [self.picContainerView layerSubviewImg];
    NSArray *views = @[self.bgView,self.msgLabel,self.picContainerView];
    
    
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    self.bgView.sd_layout.topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView,6)
    .rightSpaceToView(contentView, 6)
    .bottomEqualToView(contentView);
    
    
   
    self.msgLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView,margin)
    .rightSpaceToView(contentView,margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftSpaceToView(contentView,20)
    .topEqualToView(self.msgLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
   
}


- (void)setupSelectedBackgrondView{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = backgroundView;
    
}

- (void)setModel:(JFTopicTeacherParseModel *)model{
    if (model) {
        _model = model;
        self.msgLabel.text = model.analysis;
        
        self.msgLabel.sd_layout.maxHeightIs(MAXFLOAT);
        CGFloat picContainerTopMargin = 0;
        
        if (model.analysisPic) {
            self.picContainerView.picPathStringsArray = @[model.analysisPic];
            picContainerTopMargin = 15;
        }else{
            self.picContainerView.picPathStringsArray = nil;
        }
        _picContainerView.sd_layout.topSpaceToView(self.msgLabel, picContainerTopMargin);
        
    }else{
        self.msgLabel.text = @"";
        self.picContainerView.picPathStringsArray = nil;
    }
    UIView *bottomView = self.picContainerView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
