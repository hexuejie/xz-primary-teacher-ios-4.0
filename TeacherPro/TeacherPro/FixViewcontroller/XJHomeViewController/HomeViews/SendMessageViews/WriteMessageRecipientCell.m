//
//  WriteMessageRecipientCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WriteMessageRecipientCell.h"
#import "PublicDocuments.h"

@interface WriteMessageRecipientCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@end
@implementation WriteMessageRecipientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
    self.width.constant = FITSCALE(58);
}

- (void)setupSubview{

    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = project_main_blue;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.contentLabel.font = fontSize_14;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addRecipientAction:(id)sender {
    if (self.addRecipinetBlock) {
        self.addRecipinetBlock();
    }
    
}
- (void)setupContent:(NSString *)content{

    self.contentLabel.text = content;
}
@end
