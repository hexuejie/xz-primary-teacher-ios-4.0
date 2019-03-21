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
//  BookHomeworkUnitRemindingCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkUnitRemindingHeaderView.h"
#import "PublicDocuments.h"

@interface BookHomeworkUnitRemindingHeaderView()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *remindingLabel;

@end
@implementation BookHomeworkUnitRemindingHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}
- (void)setupSubview{

    self.bgView.backgroundColor = UIColorFromRGB(0xDFEBFF);
    self.remindingLabel.textColor = project_main_blue;
    self.remindingLabel.font = fontSize_10;
    
}

- (void)setupReminding:(NSString *)remindingStr{

    self.remindingLabel.text = remindingStr;
   
}
@end
