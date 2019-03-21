//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "ReceiveMessageTimeLineCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "MessageVoiceView.h"
#import "NotifyRecvsModel.h"
#import "ProUtils.h"

//const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定



@implementation ReceiveMessageTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    MessageVoiceView * _voiceView;
    UIImageView * _readingImgV;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    
    _iconView = [UIImageView new];
    
    _iconView.layer.borderColor = [UIColor clearColor].CGColor;
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.borderWidth = 0.5;
    _iconView.layer.cornerRadius = FITSCALE(40)/2;
    
    _nameLable = [UILabel new];
    _nameLable.font = fontSize_14;
    _nameLable.textColor = project_main_blue;
    
    _contentLabel = [UILabel new];
    _contentLabel.font = fontSize_14;
    _contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:project_main_blue forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font =  fontSize_14;
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = fontSize_11;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = UIColorFromRGB(0x9f9f9f);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _readingImgV = [UIImageView new];
    _readingImgV.image = [UIImage imageNamed:@"red_point"];
    
    _voiceView = [MessageVoiceView new];
    _voiceView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    
    
    NSArray *views = @[_iconView, _nameLable,_readingImgV,_timeLabel, _contentLabel, _moreButton,_voiceView, _picContainerView ];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    CGFloat iconHeight = FITSCALE(40);
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(iconHeight)
    .heightIs(iconHeight);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .centerYIs(_iconView.centerY + margin);
   
    [_nameLable setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
    _nameLable.numberOfLines = 1;
 
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0) ;
    
    _readingImgV.sd_layout
    .rightSpaceToView(contentView, margin)
    .centerYEqualToView(_nameLable)
    .widthIs(FITSCALE(10))
    .heightIs(FITSCALE(10));
    _readingImgV.hidden = YES;
    
    _timeLabel.sd_layout
    .rightSpaceToView(_readingImgV, 5)
    .heightIs(20)
    .centerYEqualToView(_nameLable);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:FITSCALE(80)];
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(FITSCALE(30));
    
    CGFloat  voiceHeight = FITSCALE(33);
    _voiceView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_moreButton, 10)
    .heightIs(voiceHeight)
    .rightEqualToView(_contentLabel);
    _voiceView.layer.masksToBounds = YES;
    _voiceView.layer.cornerRadius =  voiceHeight/2;
    
    _picContainerView.sd_layout
    .leftEqualToView(_voiceView); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    [self setupSelectedBackgrondView];
    
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:( NotifyRecvModel *)model
{
    
//    _iconView.image = [UIImage imageNamed:model[@"iconName"]];
//    _nameLable.text =  model[@"name"];
//    _contentLabel.text =   model[@"msgContent"] ;
//    _picContainerView.picPathStringsArray = model[@"picNamesArray"];
    
    
    UIImage *  placeholderImg =  nil;
    if ([model.sendSex isEqualToString:@"female"]) {
        
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }else if ([model.sendSex isEqualToString:@"male"]){
        placeholderImg = [UIImage imageNamed:@"tearch_man"];
    } else{
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.sendThumbnail] placeholderImage:placeholderImg];
    
  
    
    
    _nameLable.text =  model.sendName ;
    _contentLabel.text =   model.content    ;
    
//    if ([model.contentType isEqualToString:@"00"]) {
//        
//        _contentLabel.text =   model.content ;
//    }else if ([model.contentType isEqualToString:@"01"]) {
//        
//        NSArray * contentArray = [model.content componentsSeparatedByString:@"\n"];
//        
//        NSString * tempContent = @"";
//        for (int i = 0; i< [contentArray count] ; i++) {
//            
//            NSString * newline = @"\n";
//            if (i == 0) {
//                newline = @"";
//            }
//            NSString * item = [NSString stringWithFormat:@"%d. ",i+1];
//            tempContent = [tempContent stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",newline,item,contentArray[i]]];
//            
//        }
//        
//        NSMutableAttributedString * contentAttributedString = [[NSMutableAttributedString alloc]initWithString:tempContent];
//        for (int i = 0; i< [contentArray count]; i++) {
//            NSString * item = [NSString stringWithFormat:@"%d.",i+1];
//            NSRange range= [tempContent  rangeOfString:[NSString stringWithFormat:@"%@",item]];
//            
//            //            [contentAttributedString addAttribute:NSFontAttributeName
//            //
//            //                               value: fontSize_16
//            //
//            //                               range:range];
//            [contentAttributedString addAttribute:NSForegroundColorAttributeName
//             
//                                            value:UIColorFromRGB(0x9BADAF)
//             
//                                            range:range];
//            
//        }
//        _contentLabel.attributedText = contentAttributedString;
//    }
    
    _picContainerView.picPathStringsArray = model.images ;

    
    BOOL  _shouldShowMoreButton ;
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    
    
    CGRect textRect = [_contentLabel.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : fontSize_14} context:nil];
    if (textRect.size.height > maxContentLabelHeight) {
        _shouldShowMoreButton = YES;
    } else {
        _shouldShowMoreButton = NO;
    }
    
    if (_shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening ) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
       
            
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight+1);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
            
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
       _contentLabel.sd_layout.maxHeightIs(textRect.size.height+1);
    }
    
    if (model.voice ) {
        
      CGFloat  voiceHeight = FITSCALE(33);
      _voiceView.sd_layout.heightIs(voiceHeight);
        WEAKSELF
        _voiceView.playBlock = ^(BOOL playBtnSelected) {
            if (weakSelf.playButtonClickedBlock) {
                weakSelf.playButtonClickedBlock(weakSelf.indexPath,playBtnSelected,weakSelf);
            }
        };
        
//           [_voiceView setupVoiceDuration:model.voiceDuration];
    }else{
      _voiceView.sd_layout.heightIs(0);
    }
    CGFloat picContainerTopMargin = 0;
    if (_picContainerView.picPathStringsArray.count) {
        picContainerTopMargin = 16;
    }
    _picContainerView.sd_layout.topSpaceToView(_voiceView, picContainerTopMargin);
   
    
    UIView *bottomView;
    
    //    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
    //        bottomView = _timeLabel;
    //    } else {
    //        bottomView = _commentView;
    //    }
    bottomView = _picContainerView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = [ProUtils updateTime:[NSString stringWithFormat:@"%@",model.cTimestamp]];
    
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


@end

