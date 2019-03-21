//
//  SendMessageTimeLineCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/30.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "MessageVoiceView.h"
#import "TeacherSendsModel.h"
#import "ProUtils.h"

@class NotifySendsModel;
@class MessageVoiceView;

@interface SendMessageTimeLineCell : BaseTableViewCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_receivedLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    MessageVoiceView * _voiceView;
    UIImageView * _readingIcon;
    UILabel * _readingNumberLabel;
}

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) UILabel *receivedLable;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIButton *moreButton;

@property(nonatomic, strong)UIImageView * readingIcon;
@property(nonatomic, strong)UILabel * readingNumberLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *fatherView;
@property(nonatomic, strong)  MessageVoiceView * voiceView;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^playButtonClickedBlock)(NSIndexPath *indexPath,BOOL playBtnSelected,SendMessageTimeLineCell * cellView);
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, strong) NotifySendsModel *model;

@end
