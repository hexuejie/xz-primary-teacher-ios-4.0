//
//  HomeworkSuspensionView.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkSuspensionView.h"
#import "PublicDocuments.h"
#import "UIView+add.h"

@interface HomeworkSuspensionView()
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;


@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
@implementation HomeworkSuspensionView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //    UIImage * image = [self.bgImgV.image stretchableImageWithLeftCapWidth:floorf(self.bgImgV.image.size.width - 10) topCapHeight:floorf(self.bgImgV.image.size.height  - 10)];
    //    self.bgImgV.image = image;
    
    [self.segementView setCornerRadius:8 withShadow:YES withOpacity:10 withAlpha:0.06 withCGSize:CGSizeMake(0, 0)];
   
}
- (IBAction)checkAction:(id)sender {
    if (self.touckBlock) {
        self.touckBlock(HomeworkSuspensionTouchType_check);
    }
}

- (IBAction)releaseAction:(id)sender {
    if (self.touckBlock) {
        self.touckBlock(HomeworkSuspensionTouchType_release);
    }
}


- (IBAction)huiguAction:(id)sender {
    if (self.touckBlock) {
        self.touckBlock(HomeworkSuspensionTouchType_huigu);
    }
}


@end
