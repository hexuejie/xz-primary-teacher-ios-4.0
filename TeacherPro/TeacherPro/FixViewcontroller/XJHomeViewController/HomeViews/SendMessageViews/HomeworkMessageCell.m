//
//  HomeworkMessageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkMessageCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "NotifyRecvsModel.h"
@interface HomeworkMessageCell ()
@property (weak, nonatomic) IBOutlet UIView *ImgV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end
@implementation HomeworkMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.name.textColor = project_main_blue;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    [self.detailBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    self.dateLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.dateLabel.font = fontSize_10;
    self.contentLabel.font = fontSize_13;
    self.name.font = fontSize_13;
    self.detailBtn.titleLabel.font = fontSize_13;
 
    [self setupSelectedBackgrondView];
  
}
- (void)layoutSubviews{
    [super layoutSubviews ];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupHomeworkMessageInfo:(NotifyRecvModel *)model{

    self.contentLabel.text = model.content;
 
    self.dateLabel.text = [ProUtils updateTime:[NSString stringWithFormat:@"%@",model.cTimestamp]];
    self.name.text = model.sendName;
    
  
}


// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat totalHeight = 0;
//    
//    totalHeight += [self.contentLabel sizeThatFits:self.contentLabel.frame.size].height;
//    
//    totalHeight += FITSCALE(30); // margins
//    totalHeight += FITSCALE(20); // margins
//    totalHeight += FITSCALE(30);
//    return CGSizeMake(size.width, totalHeight);
//}


#pragma mark ---修改编辑状态时的选中图片


//
- (void)clearSysView{
    
    
    //    self.bgView.backgroundColor = [UIColor whiteColor];
    //    self.imgV.backgroundColor = [UIColor whiteColor];
    //    self.msgTitleLabel.backgroundColor = UIColorFromRGB(0xE7F1FE);
    self.ImgV.backgroundColor = [UIColor whiteColor];
    for (UIView * view in self.contentView.subviews) {
        view.backgroundColor = [UIColor whiteColor];
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
- (IBAction)detailAction:(id)sender {
    if (self.detailBlock) {
        self.detailBlock(self.index);
    }
}

@end
