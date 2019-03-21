//
//  ApplyNewMessageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ApplyNewMessageCell.h"
#import "NotifyRecvsModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"

@interface ApplyNewMessageCell()
@property (strong, nonatomic)   UILabel *msgTitleLabel;
@property (strong, nonatomic)   UILabel *msgDetailLabel;
@property (strong, nonatomic)   UILabel *msgDateLabel;
@property (strong, nonatomic)   UIButton *canclBtn;
@property (strong, nonatomic)   UIButton *agreedBtn;
@property (strong, nonatomic)   UIView *bgView;
@property (strong, nonatomic)   UIImageView *imgV;
@property (strong, nonatomic)   UIImageView *lineV;

@end
@implementation ApplyNewMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        [self setupSelectedBackgrondView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    
}
- (void)setup
{

    
    self.imgV = [UIImageView new];
    self.imgV.image = [UIImage imageNamed:@"system_portrait"];
    self.imgV.layer.borderColor = [UIColor clearColor].CGColor;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.borderWidth = 0.5;
    self.imgV.layer.cornerRadius = FITSCALE(40)/2;
    
    
    self.msgTitleLabel = [UILabel new];
   
    
    self.msgDetailLabel = [UILabel new];
    self.msgDetailLabel.numberOfLines = 0;
    
    
    self.msgDateLabel = [UILabel new];
    
    self.canclBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.canclBtn addTarget:self action:@selector(refusedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.canclBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    [self.canclBtn setTitle:@"拒绝" forState: UIControlStateNormal] ;
    [self.canclBtn setImage:[UIImage imageNamed:@"apply_message_Refused"] forState:UIControlStateNormal];
    
    self.agreedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreedBtn addTarget:self action:@selector(agreedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreedBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    
    [self.agreedBtn setTitle:@"同意" forState: UIControlStateNormal] ;
    [self.agreedBtn setImage:[UIImage imageNamed:@"apply_message_agreed"] forState:UIControlStateNormal];
 
    self.lineV = [UIImageView new];
    
    NSArray *views = @[self.msgTitleLabel,self.imgV,self.msgDetailLabel,self.msgDateLabel,self.canclBtn,self.agreedBtn,self.lineV];
    
    [self.contentView sd_addSubviews:views];
    
    
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    CGFloat iconHeight = FITSCALE(40);
    
    
    self.imgV.sd_layout
    .leftSpaceToView(contentView, margin+5)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(iconHeight)
    .heightIs(iconHeight);
    
    self.msgTitleLabel.sd_layout
    .leftSpaceToView(self.imgV, margin)
    .centerYIs(self.imgV.centerY + margin);
    
    self.msgTitleLabel.numberOfLines = 1;
    [self.msgTitleLabel setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
    
    self.msgDateLabel.sd_layout
    .rightSpaceToView(self.contentView, 16)
    .heightIs(20)
    .centerYEqualToView(self.msgTitleLabel);
    [self.msgDateLabel setSingleLineAutoResizeWithMaxWidth:FITSCALE(80)];
    
    
    self.msgDetailLabel.sd_layout
    .leftEqualToView(self.msgTitleLabel)
    .topSpaceToView(self.msgTitleLabel, margin)
    .rightEqualToView(self.msgDateLabel)
    .autoHeightRatio(0) ;
    
    self.lineV.sd_layout
    .leftEqualToView(self.msgDetailLabel)
    .topSpaceToView(self.msgDetailLabel,margin)
    .rightEqualToView(self.msgDateLabel)
    .heightIs(2);
    
    self.agreedBtn.sd_layout
    .rightEqualToView(self.msgDateLabel)
    .topSpaceToView(self.lineV, margin)
    .heightIs(44)
    .widthIs(60);
    
    
    self.canclBtn.sd_layout
    .rightSpaceToView(self.agreedBtn, 20)
    .topEqualToView(self.agreedBtn)
    .heightIs(44)
    .widthIs(60);
   
    
    

    [self setupSubView];
    
    
}
- (void)setupSelectedBackgrondView{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = backgroundView;
    
}
- (void)setupSubView{
    self.msgTitleLabel.textColor = project_main_blue;
    self.msgTitleLabel.backgroundColor = UIColorFromRGB(0xE7F1FE);
    
    self.canclBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.canclBtn setTitleColor:UIColorFromRGB(0xF54B6C) forState:UIControlStateNormal];
    [self.agreedBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    self.agreedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.msgDetailLabel.font = fontSize_13;
    self.msgTitleLabel.font = fontSize_13;
    self.msgDateLabel.font = fontSize_11;
    self.canclBtn.titleLabel.font = fontSize_13;
    self.agreedBtn.titleLabel.font = fontSize_13;
    self.msgDetailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.msgDateLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.lineV.image = [UIImage imageNamed:@"line_apply"];
}

- (void)setNotifyRecvModel:(NotifyRecvModel *)notifyRecvModel{
   
    _notifyRecvModel = notifyRecvModel;
    NSString * time = [ProUtils updateTime:[NSString stringWithFormat:@"%@", notifyRecvModel.cTimestamp]];
    self.msgDateLabel.text = time;
    self.msgDetailLabel.text = notifyRecvModel.content;
    self.msgTitleLabel.text = notifyRecvModel.sendName;
    
   
    UIImage *  placeholderImg =  nil;
    if ([notifyRecvModel.sendSex isEqualToString:@"female"]) {
        
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }else if ([notifyRecvModel.sendSex isEqualToString:@"male"]){
        placeholderImg = [UIImage imageNamed:@"tearch_man"];
    } else{
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:notifyRecvModel.sendThumbnail] placeholderImage:placeholderImg];
    UIView *bottomView = self.agreedBtn;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}


- (void)refusedAction:(id)sender {
    self.handleBlock(0,[NSString stringWithFormat:@"%@",self.notifyRecvModel.recvId],self.handleIndexPath);
}

- (void)agreedAction:(id)sender {
    self.handleBlock(1,[NSString stringWithFormat:@"%@",self.notifyRecvModel.recvId],self.handleIndexPath);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ---修改编辑状态时的选中图片

- (void)clearSysView{
    
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    for (UIView * view in self.contentView.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }
    
    self.msgTitleLabel.backgroundColor = UIColorFromRGB(0xE7F1FE);
    for (UIControl *control in self.subviews){
        if ([control isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView") ]) {
            //去掉选中时线条
            control.backgroundColor = [UIColor clearColor];
            
        }
        
    }
    
}
@end
