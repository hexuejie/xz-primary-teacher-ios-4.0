//
//  SystemMessageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SystemMessageCell.h"
#import "PublicDocuments.h"
#import "NotifyRecvsModel.h"
#import "ProUtils.h"
#import "UIView+SDAutoLayout.h"
@interface SystemMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *msgName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redingImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

@end
@implementation SystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.msgName.textColor = project_main_blue;
    self.msgName.font = fontSize_13;
    self.contentLabel.font = fontSize_13;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.dateLabel.font = fontSize_10;
    self.redingImgV.hidden = YES;
    self.dateLabel.textColor = UIColorFromRGB(0x9f9f9f);
 
    [self setupSelectedBackgrondView];
    
    [self setupSubviewAutoLayout];
}

- (void)setupSubviewAutoLayout{

//    _contentLabel.sd_layout
//    .leftEqualToView(_nameLable)
//    .topSpaceToView(_nameLable, margin)
//    .rightSpaceToView(contentView, margin*2)
//    .autoHeightRatio(0);

    
//   self.userImgV.sd_resetNewLayout
//    .leftSpaceToView(self, 10)
//    .topSpaceToView(self, 10)
//    .widthIs(40)
//    .heightIs(40);
   
//    self.msgName.sd_layout
//    .leftSpaceToView(self, 10)
//    .centerYIs(self.userImgV.centerY);
//    [self.msgName setSingleLineAutoResizeWithMaxWidth:FITSCALE(100)];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupSystemMessageInfo:(NotifyRecvModel *) notifyModel{

    NSString * time = [ProUtils updateTime:[NSString stringWithFormat:@"%@", notifyModel.cTimestamp ]];
    self.dateLabel.text = time;
    self.contentLabel.text = notifyModel.content;
    self.msgName.text = notifyModel.sendName;
    
    
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += FITSCALE(30); // margins
    totalHeight += FITSCALE(20); // margins
    return CGSizeMake(size.width, totalHeight);
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
