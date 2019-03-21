
//
//  GFMallAddressAdministerBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallAddressAdministerBottomView.h"
#import "PublicDocuments.h"

@interface GFMallAddressAdministerBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation GFMallAddressAdministerBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.addBtn.backgroundColor = project_main_blue;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 45/2;
    self.addBtn.layer.borderColor = [UIColor clearColor].CGColor;
}
- (IBAction)addAction:(id)sender {
    if (self.addBlock) {
        self.addBlock();
    }
    
}


@end
