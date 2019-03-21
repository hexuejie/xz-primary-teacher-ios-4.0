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
//  ReleaseHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseHeaderView.h"
#import "PublicDocuments.h"
@implementation ReleaseHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
 
    self.iconlineView.backgroundColor = project_line_gray;
    self.topLineView.backgroundColor = project_line_gray;
//    self.bgView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.bgView.backgroundColor = [UIColor clearColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
