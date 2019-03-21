//
//  HomeworkSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkSectionView.h"
#import "PublicDocuments.h"
@interface HomeworkSectionView()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end
@implementation HomeworkSectionView
- (void)awakeFromNib{
    [super awakeFromNib];

     [self.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupSectionTitle:(NSString *)title{
    self.title.text = title;
    
}
- (void)setupMoreBtnState:(BOOL)isShow{
    
    self.moreBtn.hidden = !isShow;
}

- (void)moreBtnAction{
    
    if (self.moreBlock) {
        self.moreBlock();
    }
}
@end
