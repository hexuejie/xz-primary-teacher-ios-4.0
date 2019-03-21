//
//  ApplyMessageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ApplyMessageCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "NotifyRecvsModel.h"

@interface ApplyMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *msgTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *canclBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreedBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIImageView *lineV;
@property (nonatomic, strong) NotifyRecvModel * tempModel;

@end
@implementation ApplyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    [self setupSubView];
    [self setupSelectedBackgrondView];
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
//    self.msgDateLabel.text = [self compareCurrentTime:@"2017-06-25 17:22:22"];
  
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
    
}


- (void)setupApplyMessageInfo:(NotifyRecvModel *) notifyModel{
    self.tempModel = notifyModel;
    NSString * time = [ProUtils updateTime:[NSString stringWithFormat:@"%@", notifyModel.cTimestamp]];
    self.msgDateLabel.text = time;
    self.msgDetailLabel.text = notifyModel.content;
    self.msgTitleLabel.text = notifyModel.sendName;
    
    
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    
    totalHeight += [self.msgDetailLabel sizeThatFits:size].height;
    
    totalHeight += FITSCALE(30); // margins
    totalHeight += FITSCALE(20); // margins
    totalHeight += FITSCALE(40); // margins
    return CGSizeMake(size.width, totalHeight);
}

- (IBAction)refusedAction:(id)sender {
    self.handleBlock(0,[NSString stringWithFormat:@"%@",self.tempModel.recvId],self.handleIndexPath);
}
- (IBAction)agreedAction:(id)sender {
    self.handleBlock(1,[NSString stringWithFormat:@"%@",self.tempModel.recvId],self.handleIndexPath);
}


#pragma mark ---修改编辑状态时的选中图片
 
- (void)clearSysView{
    
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    for (UIView * view in self.bgView.subviews) {
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
