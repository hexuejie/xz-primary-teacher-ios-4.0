//
//  EditContentFooterView.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,ReleaseEditContentFooterViewType){
    ReleaseEditContentFooterViewType_normal = 0          ,
    ReleaseEditContentFooterViewType_textViewButton      ,//文字编写
    ReleaseEditContentFooterViewType_todoButton          ,//项目
    ReleaseEditContentFooterViewType_photoButton         ,//图片
    ReleaseEditContentFooterViewType_voiceButton         ,//录像
    
};

typedef void(^ReleaseEditContentFooterViewBlock)(ReleaseEditContentFooterViewType type );

@interface ReleaseEditContentFooterView : UITableViewHeaderFooterView
@property(nonatomic, copy) ReleaseEditContentFooterViewBlock  buttonsBlock;
- (void)buttonSelectedTag:(ReleaseEditContentFooterViewType)tag;
@end
