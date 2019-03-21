//
//  SystemMessageNewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SystemMessageNewCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIView+SDAutoLayout.h"
#import "NotifyRecvsModel.h"
@interface SystemMessageNewCell()
@property (strong, nonatomic)  UILabel *msgName;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UIImageView *redingImgV;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UIImageView *userImgV;
@end

@implementation SystemMessageNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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

    
    self.msgName = [UILabel new];
    self.msgName.font = fontSize_14;
    self.msgName.textColor = UIColorFromRGB(0x6b6b6b);
 
 
    self.contentLabel = [UILabel new];
    self.contentLabel.font = fontSize_14;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.contentLabel.numberOfLines = 0;
 
    self.dateLabel = [UILabel new];
   
    
    NSArray *views = @[self.msgName,self.userImgV,self.contentLabel,self.dateLabel];
    
    [self.contentView sd_addSubviews:views];
    
    
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    CGFloat iconHeight = FITSCALE(40);
 
    
    self.userImgV.sd_layout
    .leftSpaceToView(contentView, margin+5)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(iconHeight)
    .heightIs(iconHeight);

    self.msgName.sd_layout
    .leftSpaceToView(self.userImgV, margin)
    .centerYIs(self.userImgV.centerY + margin);

     self.msgName.numberOfLines = 1;
    [self.msgName setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
  
    self.dateLabel.sd_layout
    .rightSpaceToView(self.contentView, 16)
    .heightIs(20)
    .centerYEqualToView(self.msgName);
    [self.dateLabel setSingleLineAutoResizeWithMaxWidth:FITSCALE(80)];
    
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.msgName)
    .topSpaceToView(self.msgName, margin)
    .rightEqualToView(self.dateLabel)
    .autoHeightRatio(0) ;
    
    
   

    
    self.msgName.textColor = project_main_blue;
    self.msgName.font = fontSize_13;
    self.contentLabel.font = fontSize_13;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.dateLabel.font = fontSize_10;
    self.redingImgV.hidden = YES;
    self.dateLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.userImgV.image = [UIImage imageNamed:@"system_portrait"];
}

- (void)setNotifyModel:(NotifyRecvModel *)notifyModel{
    NSString * time = [ProUtils updateTime:[NSString stringWithFormat:@"%@", notifyModel.cTimestamp ]];
    self.dateLabel.text = time;
    self.contentLabel.text = notifyModel.content;
    self.msgName.text = notifyModel.sendName;
    UIView *bottomView = self.contentLabel;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
@end
