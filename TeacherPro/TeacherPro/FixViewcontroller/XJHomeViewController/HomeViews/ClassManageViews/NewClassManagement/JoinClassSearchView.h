//
//  JoinClassSearchView.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JoinClassSearchBlock)(NSString * phoneOrCoding);
typedef void(^JoinClassInputBlock)(NSString * phoneOrCoding);
@interface JoinClassSearchView : UIView
@property(nonatomic, copy) JoinClassSearchBlock searchBlock;
@property(nonatomic, copy) JoinClassInputBlock  inputPhoneBlock;
@end
