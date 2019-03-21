//
//  TouchButton.h
//  AplusEduPro
//
//  Created by neon on 15/7/28.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchBlock)(void);
typedef void (^NewClassSureTouchBlock)(NSString * inputText);
@interface TouchButton : UIButton


@property (nonatomic, copy) TouchBlock touchBlock;
@property (nonatomic, copy) NewClassSureTouchBlock newClassBlock;
@property (nonatomic, copy) NSString * inputText;
@end
