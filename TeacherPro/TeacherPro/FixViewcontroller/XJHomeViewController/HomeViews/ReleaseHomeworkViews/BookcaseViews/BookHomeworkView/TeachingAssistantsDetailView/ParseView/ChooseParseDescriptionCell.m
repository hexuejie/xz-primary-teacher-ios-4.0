//
//  ChooseParseDescriptionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseParseDescriptionCell.h"
#import "AssistantsDetailModel.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
#import "SDWeiXinPhotoContainerView.h"
#import "ProUtils.h"
@interface ChooseParseDescriptionCell()
@property (strong, nonatomic)   UILabel *msgLabel;
@property (strong, nonatomic)   UIButton *selectBtn;
@property (strong, nonatomic)   UIView *bgView;
@property (strong, nonatomic)   SDWeiXinPhotoContainerView *picContainerView;
@end
@implementation ChooseParseDescriptionCell
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
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
 
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setTitle:@"使用我的解析" forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectBtn setTitleColor:UIColorFromRGB(0xb6b6b6) forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.selectBtn setImage: [UIImage imageNamed:@"unselected_parse_icon"] forState:UIControlStateNormal];
    [self.selectBtn setImage: [UIImage imageNamed:@"selected_parse_icon"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage  * normal_bg = [ProUtils  createImageWithColor:UIColorFromRGB(0xE2E2E2) withFrame:CGRectMake(0, 0, 1, 1)];
    UIImage  * selected_bg = [ProUtils  createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, 1, 1)];
    [self.selectBtn setBackgroundImage:normal_bg forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:selected_bg forState:UIControlStateSelected];
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.layer.cornerRadius = 5;
    
 
    self.msgLabel = [UILabel  new];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.backgroundColor = [UIColor clearColor];
 
    self.msgLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.msgLabel.font = [UIFont systemFontOfSize:14];
    
    self.picContainerView = [SDWeiXinPhotoContainerView new];
    self.picContainerView.backgroundColor= [UIColor clearColor];
    self.picContainerView.isShowBorder = YES;
    [self.picContainerView layerSubviewImg];
    NSArray *views = @[self.bgView,self.selectBtn,self.msgLabel,self.picContainerView];
    
    
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    self.bgView.sd_layout.topSpaceToView(contentView, 0)
    .leftEqualToView(contentView)
    .rightSpaceToView(contentView, 0)
    .bottomEqualToView(contentView);
  
 
    self.selectBtn.sd_layout.topSpaceToView(contentView,10)
    .rightSpaceToView(contentView, 10)
    .widthIs(120)
    .heightIs(30);
    
    
    self.msgLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(self.selectBtn,20)
    .rightSpaceToView(contentView,margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftSpaceToView(contentView,20)
     .topEqualToView(self.msgLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    [ProUtils setupButtonContent:self.selectBtn withType:ButtonContentType_imageRight];
}


- (void)setupSelectedBackgrondView{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = backgroundView;
    
}

- (void)setModel:(QuestionAnalysisModel *)model{
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
- (void)setupSelectedState:(BOOL )state{
    
    self.selectBtn.selected = state;
}
- (void)selectAction:(UIButton *)sender{
    if(!sender.selected){
        sender.selected = YES;
        if (self.selectedAnalysisBlock) {
            self.selectedAnalysisBlock(self.indexPath);
        }
    }
    
}
@end

