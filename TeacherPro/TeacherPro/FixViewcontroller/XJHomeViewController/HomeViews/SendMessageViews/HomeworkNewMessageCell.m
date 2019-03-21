
//
//  HomeworkNewMessageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkNewMessageCell.h"
#import "NotifyRecvsModel.h"
#import "ProUtils.h"
#import "UIView+SDAutoLayout.h"
#import "PublicDocuments.h"
@interface HomeworkNewMessageCell()

@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UIButton *detailBtn;
@property (strong, nonatomic)  UIImageView *userImgV;
@property (strong, nonatomic)  UIImageView *arrowImgV;
@end
@implementation HomeworkNewMessageCell
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
 
    self.userImgV = [UIImageView new];
    
    self.name = [UILabel new];
    self.name.text = @"系统";
    
    self.contentLabel = [UILabel new];
    self.contentLabel.numberOfLines = 0;
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    self.detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.detailBtn setTitle:@"查看作业详情" forState: UIControlStateNormal] ;
 
    self.arrowImgV = [UIImageView new];
    [self.arrowImgV setImage:[UIImage imageNamed:@"homework_detail_arrow"]  ];
    self.arrowImgV.contentMode = UIViewContentModeScaleAspectFit;
    
    self.dateLabel = [UILabel new];
    
    
    
    NSArray *views = @[self.name,self.userImgV,self.contentLabel,self.dateLabel,self.detailBtn,self.arrowImgV];
    
    
    [self.contentView sd_addSubviews:views];
    
    
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    CGFloat iconHeight = FITSCALE(40);
    
    self.userImgV.sd_layout
    .leftSpaceToView(contentView, margin+5)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(iconHeight)
    .heightIs(iconHeight);
    
    self.name.sd_layout
    .leftSpaceToView(self.userImgV, margin)
    .centerYIs(self.userImgV.centerY + margin);
    
    self.name.numberOfLines = 1;
    [self.name setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
    
    self.dateLabel.sd_layout
    .rightSpaceToView(self.contentView, 16)
    .heightIs(20)
    .centerYEqualToView(self.name);
    [self.dateLabel setSingleLineAutoResizeWithMaxWidth:FITSCALE(80)];
    
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.name)
    .topSpaceToView(self.name, margin)
    .rightEqualToView(self.dateLabel)
    .autoHeightRatio(0) ;
    
    
   
    
    self.arrowImgV.sd_layout
    .rightEqualToView(self.dateLabel)
    .topSpaceToView(self.contentLabel, margin)
    .heightIs(12)
    .widthIs(18);
    
    
    self.detailBtn.sd_layout
    .rightSpaceToView(self.arrowImgV, margin)
   
    .centerYEqualToView(self.arrowImgV)
    .heightIs(FITSCALE(20));
    
    
    self.userImgV.image = [UIImage imageNamed:@"system_portrait"];
    
    
    self.name.textColor = project_main_blue;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    [self.detailBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    self.dateLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.dateLabel.font = fontSize_10;
    self.contentLabel.font = fontSize_13;
    self.name.font = fontSize_13;
    self.detailBtn.titleLabel.font = fontSize_13;
    
}
- (void)detailAction:(id)sender {
    if (self.detailBlock) {
        self.detailBlock(self.index);
    }
}

- (void)setNotifyRecvModel:(NotifyRecvModel *)notifyRecvModel{
    self.contentLabel.text = notifyRecvModel.content;
    
    self.dateLabel.text = [ProUtils updateTime:[NSString stringWithFormat:@"%@",notifyRecvModel.cTimestamp]];
    self.name.text = notifyRecvModel.sendName;
    
    
    UIView *bottomView = self.detailBtn;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark ---修改编辑状态时的选中图片
//
- (void)clearSysView{
    
    for (UIView * view in self.contentView.subviews) {
        view.backgroundColor = [UIColor whiteColor];
        for (UIView * sbuView in view.subviews) {
            sbuView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    for (UIControl *control in self.subviews){
        if ([control isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView") ]) {
            //去掉选中时线条
            control.backgroundColor = [UIColor clearColor];
            
        }
        
    }
    
}

- (void)setupSelectedBackgrondView{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = backgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
