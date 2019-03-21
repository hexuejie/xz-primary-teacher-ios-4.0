//
//  GFMallOrderBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GFMallOrderBottomViewBlock)();
@interface GFMallOrderBottomView : UIView
- (void)setupPayCoin:(NSString *)payCoin;
@property(nonatomic, copy) GFMallOrderBottomViewBlock sureBlock;
@end
