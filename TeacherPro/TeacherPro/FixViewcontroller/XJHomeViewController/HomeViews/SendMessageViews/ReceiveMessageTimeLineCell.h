//
//  SDTimeLineCell.h
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
 * QQ交流群: 362419100(2群) 459274049（1群已满）
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

#import <UIKit/UIKit.h>

#import "BaseTableViewCell.h"

@class NotifyRecvModel;
@class MessageVoiceView;
@interface ReceiveMessageTimeLineCell : BaseTableViewCell



@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *fatherView;
@property(nonatomic, strong)  MessageVoiceView * voiceView;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^playButtonClickedBlock)(NSIndexPath *indexPath,BOOL playBtnSelected,ReceiveMessageTimeLineCell * cellView);
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, strong) NotifyRecvModel *model;
 
@end