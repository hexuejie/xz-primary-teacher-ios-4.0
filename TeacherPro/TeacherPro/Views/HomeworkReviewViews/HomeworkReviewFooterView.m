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
//  HomeworkReviewFooterView.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkReviewFooterView.h"
#import "PublicDocuments.h"
@interface HomeworkReviewFooterView()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation HomeworkReviewFooterView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.lineView.backgroundColor = UIColorFromRGB(0x797979);
}


@end
