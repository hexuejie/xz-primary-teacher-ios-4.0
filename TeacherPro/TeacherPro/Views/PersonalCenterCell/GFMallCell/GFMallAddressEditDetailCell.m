//
//  GFMallAddressEditDetailCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallAddressEditDetailCell.h"
#import "TTextView.h"
#import "PublicDocuments.h"

@interface GFMallAddressEditDetailCell ()
@property (weak, nonatomic) IBOutlet TTextView *textView;

@end
@implementation GFMallAddressEditDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configView];
}
- (void)configView{
    self.textView.font = fontSize_14;
    self.textView.textColor = UIColorFromRGB(0x6b6b6b);
    self.textView.placeholderColor = UIColorFromRGB(0xc3c3c3);
    
     
    
    WEAKSELF
    [self.textView addTextDidChangeHandler:^(TTextView *textView) {
        STRONGSELF
         if (strongSelf.inputBlock) {
            strongSelf.inputBlock(textView.text);
        }
    }];
    
}

- (void)setupContent:(NSString *)contentStr{
    if (contentStr) {
         self.textView.text = contentStr;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
