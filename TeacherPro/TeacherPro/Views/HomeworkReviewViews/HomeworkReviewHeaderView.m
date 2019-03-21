//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  HomeworkReviewHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkReviewHeaderView.h"
#import "PublicDocuments.h"
@interface HomeworkReviewHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HomeworkReviewHeaderView

- (void)awakeFromNib{

    [super awakeFromNib];
    self.lineView.backgroundColor = UIColorFromRGB(0x797979);
}

@end
