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
//  PasswordView.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PasswordView.h"
#import "PublicDocuments.h"
@implementation PasswordView

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.textField.textColor = UIColorFromRGB(0x6b6b6b);
    self.textField.font = fontSize_14;
}

@end
