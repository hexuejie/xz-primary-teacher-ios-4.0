//
//  MessageListCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "MessageListCell.h"
#import "PublicDocuments.h"
#import "UIView+WZLBadge.h"

@interface MessageListCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *notifyNumberLabel;

@end
@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{

  
    self.iconImgV.contentMode = UIViewContentModeScaleAspectFit;
   
    
    self.notifyNumberLabel.hidden = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupMessageCellInfo:(NSDictionary *)info{

    self.iconImgV.image = [UIImage imageNamed:info[@"icon"]];
    self.titleLabel.text = info[@"title"];
  
}

- (void)setupNewMessageNumber:(NSInteger )newNumber withNotifyNumber:(NSNumber *)notifyCount{
    if (!notifyCount) {
        notifyCount = [NSNumber numberWithInt:0];
    }
    self.notifyNumberLabel.hidden = NO;
  
    [self.iconImgV showNumberBadgeWithValue:newNumber animationType:WBadgeAnimTypeNone];
     self.notifyNumberLabel.text = [NSString stringWithFormat:@"%@条", notifyCount];
}
@end
