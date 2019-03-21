//
//  ReleaseAddBookworkCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseAddBookworkCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"

@interface ReleaseAddBookworkCell()


@property (weak, nonatomic) IBOutlet UIImageView *topImgV;

@end
@implementation ReleaseAddBookworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}

- (void)setupSubViews{

    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    UIImage * addBgImg = [ProUtils getResizableImage:[UIImage imageNamed:@"add_background_image"] withEdgeInset:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.addButton setBackgroundImage:addBgImg forState:UIControlStateNormal];
//
    
//    UIImage * topImg = [ProUtils getResizableImage:[UIImage imageNamed:@"add_bookwork_line"] withEdgeInset:UIEdgeInsetsMake(1, 1, 1, 1)];
    
//    [self.topImgV setImage:topImg];
}

- (void)addButtonAction{
    
    if (self.addBookBlock) {
        self.addBookBlock();
    }
    if ([self.delegate respondsToSelector:@selector(didAddBookwork:)]) {
        [self.delegate didAddBookwork:(self)];
    }
}
@end
