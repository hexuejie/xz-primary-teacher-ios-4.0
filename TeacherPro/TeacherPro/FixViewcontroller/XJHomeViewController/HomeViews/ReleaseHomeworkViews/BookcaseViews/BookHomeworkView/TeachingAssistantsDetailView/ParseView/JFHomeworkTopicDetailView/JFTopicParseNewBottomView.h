//
//  JFTopicParseNewBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JFTopicParseSureButtonBlock)(BOOL state);

@interface JFTopicParseNewBottomView : UIView
@property(nonatomic,copy) JFTopicParseSureButtonBlock sureBlock;
@end
