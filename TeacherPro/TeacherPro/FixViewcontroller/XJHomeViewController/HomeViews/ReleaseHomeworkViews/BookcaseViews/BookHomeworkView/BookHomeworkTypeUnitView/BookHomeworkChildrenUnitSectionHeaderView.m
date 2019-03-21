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
//  BookHomeworkChildrenUnitSectionHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChildrenUnitSectionHeaderView.h"
#import "PublicDocuments.h"

@interface BookHomeworkChildrenUnitSectionHeaderView()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *sectionT;

@end
@implementation BookHomeworkChildrenUnitSectionHeaderView

- (void)awakeFromNib{

    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{

    self.sectionT.textColor = UIColorFromRGB(0x6b6b6b);
    self.sectionT.font = fontSize_14;
    self.lineView.backgroundColor = project_line_gray;
}
- (void)setupUnitName:(NSString *)name{

    self.sectionT.text = name;
}
@end
