

//
//  SendMessageTimeLineCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/30.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SendMessageTimeLineCell.h"

CGFloat maxContentHeight = 0; // 根据具体font而定
@interface SendMessageTimeLineCell()

@end
@implementation SendMessageTimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup]; 
    }
    return self;
}


- (void)setup
{
 
    self.fatherView = [[UIView alloc]init];
    self.fatherView.backgroundColor = [UIColor clearColor];
    // 设置imageView的tag，在PlayerView中取（建议设置100以上）
    self.fatherView.hidden = YES;
    self.fatherView.tag = 101;
    
    [self.contentView addSubview:self.fatherView];
    
    
    _iconView = [[UIImageView alloc]init];
    
    _nameLable = [[UILabel alloc]init];
    _nameLable.font = fontSize_14;
    _nameLable.textColor = project_main_blue;
    
    _receivedLable = [[UILabel alloc]init];
    _receivedLable.font = fontSize_14;
    _receivedLable.textColor = UIColorFromRGB(0x6b6b6b);
    
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = fontSize_14;
    _contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (maxContentHeight == 0) {
        maxContentHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [[UIButton alloc]init];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:project_main_blue forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font =  fontSize_14;
    

    
    _voiceView = [[MessageVoiceView alloc]init];
    _picContainerView = [[SDWeiXinPhotoContainerView alloc]init];
    _timeLabel = [UILabel new];
    _timeLabel.font = fontSize_11;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = UIColorFromRGB(0x9f9f9f);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    
    _readingIcon = [[UIImageView alloc]init];
    _readingNumberLabel = [[UILabel alloc]init];
    _readingNumberLabel.font = fontSize_11;
    _readingNumberLabel.backgroundColor = [UIColor clearColor];
    _readingNumberLabel.textAlignment = NSTextAlignmentRight;
    _readingNumberLabel.textColor = UIColorFromRGB(0x9f9f9f);
    
    NSArray *views = @[_iconView, _nameLable,_receivedLable, _contentLabel, _moreButton,_voiceView, _picContainerView ,_timeLabel,_readingIcon,_readingNumberLabel];
    
    [self.contentView sd_addSubviews:views];
    
    
    
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(FITSCALE(20))
    .heightIs(FITSCALE(20));
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(FITSCALE(20));
    [_nameLable setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
    
    _receivedLable.sd_layout
    .leftSpaceToView(_nameLable,margin)
    .topEqualToView(_nameLable)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(FITSCALE(20));
    
 
    
   
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin*2)
    .autoHeightRatio(0);
    
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(FITSCALE(30));
    
    CGFloat voiceHeight =FITSCALE(33);
    _voiceView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_moreButton, 10)
    .heightIs(voiceHeight)
    .rightSpaceToView(contentView, margin*4) ;
    _voiceView.layer.masksToBounds = YES;
    _voiceView.layer.cornerRadius =  voiceHeight/2;
    
    _picContainerView.sd_layout
    .leftEqualToView(_voiceView); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
     _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .heightIs(FITSCALE(20))
    .widthIs(FITSCALE(60));
     [self setupSelectedBackgrondView];
    
    
  
    
//    self.fatherView.sd_layout
//    .leftEqualToView(_voiceView)
//    .topEqualToView(self.contentView)
//    .heightIs(voiceHeight)
//    .rightEqualToView(_voiceView);
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(NotifySendsModel *)model
{
//    _model = model;
 
    _iconView.image = [UIImage imageNamed:@"message_recipient"];
    _nameLable.text =  @"发送给:";
    _contentLabel.text =   model.content ;
    
    _picContainerView.picPathStringsArray = model.imagesRsp;
    
    NSString * teachers = [model.target.teacherTarget componentsJoinedByString:@","];
    NSString * students = [model.target.studentTarget componentsJoinedByString:@","];
    NSString * receivedStr = @"";
    if (teachers && [teachers length] > 0) {
        receivedStr = [NSString stringWithFormat:@"%@",teachers];
    }
    if (students && [students length] > 0) {
        if (receivedStr.length > 0) {
            receivedStr = [NSString stringWithFormat:@"%@,%@",receivedStr,students];
        }else{
            receivedStr = [NSString stringWithFormat:@"%@",students];
        }
        
    }
    _receivedLable.text =[NSString stringWithFormat:@"%@", receivedStr];
    
    
    BOOL  _shouldShowMoreButton ;
    
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 30 - FITSCALE(20) - 10;
    
    CGRect textRect = [_contentLabel.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : fontSize_14} context:nil];
    if (textRect.size.height > maxContentHeight) {
        _shouldShowMoreButton = YES;
        
    } else {
        _shouldShowMoreButton = NO;
        _contentLabel.sd_layout.maxHeightIs(textRect.size.height+1);
    }
    
    if (_shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening  ) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentHeight+1);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    if (model.voice ) {
        
        CGFloat voiceHeight =FITSCALE(33);
        _voiceView.sd_layout.heightIs(voiceHeight);
        _voiceView.backgroundColor = UIColorFromRGB(0xF4F4F4);
        //            self.fatherView.sd_layout.heightIs(voiceHeight);
        WEAKSELF
        _voiceView.playBlock = ^(BOOL playBtnSelected) {
            if (weakSelf.playButtonClickedBlock) {
                weakSelf.playButtonClickedBlock(weakSelf.indexPath,playBtnSelected,weakSelf);
            }
        };
        
        
    }else{
        _voiceView.sd_layout.heightIs(0);
        //            self.fatherView.sd_layout.heightIs(0);
        _voiceView.backgroundColor = [UIColor clearColor];
    }
    CGFloat picContainerTopMargin = 0;
    if (_picContainerView.picPathStringsArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_voiceView, picContainerTopMargin);
    
    
    _timeLabel.text = [ProUtils updateTime:[NSString stringWithFormat:@"%@",model.ctimeRsp]];
    
    _timeLabel.sd_layout
    .topSpaceToView(_picContainerView, 10);
    
    _readingNumberLabel.text = [NSString stringWithFormat:@"%@/%@阅读",model.readedTargetCounter,model.targetCounter];
    
    _readingIcon.image = [UIImage imageNamed:@"send_message_reading_icon"];
    
    
    _readingNumberLabel.sd_layout
    .rightEqualToView(_contentLabel)
    .heightIs(FITSCALE(20))
    
    .topSpaceToView(_picContainerView, 10);;
    [_readingNumberLabel setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
    
    _readingIcon.sd_layout
    .rightSpaceToView(_readingNumberLabel, 10)
    .heightIs(FITSCALE(10))
    .widthIs(FITSCALE(14))
    .centerYEqualToView(_readingNumberLabel);
    
    
    UIView *bottomView;
    bottomView = _timeLabel;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ---修改编辑状态时的选中图片
 
 
//
- (void)clearSysView{
    
    
    for (UIView * view in self.contentView.subviews) {
        view.backgroundColor = [UIColor clearColor];
        for (UIView * sbuView in view.subviews) {
            sbuView.backgroundColor = [UIColor clearColor];
        }
    }
    _voiceView.backgroundColor =  UIColorFromRGB(0xF4F4F4);
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

- (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value: fontSize_16
     
                       range:range];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:color
     
                       range:range];
    
    return Attributed;
}

 
@end
