//
//  TagView.h
//  CustomTag
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TagViewDelegate <NSObject>

@optional

-(void)handleSelectTag:(NSString *)keyWord;

@end
@interface TagView : UIView
@property (nonatomic ,weak)id <TagViewDelegate>delegate;
@property(nonatomic, strong) UIFont  * btnFont;
@property(nonatomic, strong) UIColor  * textColor;
@property(nonatomic, strong) UIColor * itemBgColor;
@property(nonatomic, strong) UIColor  * edgeLineColor;
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign)  CGFloat borderWidth  ;
@property (nonatomic ,strong)NSArray * arr;
+ (CGFloat) getViewHeightData:(NSArray *)array;
@end
