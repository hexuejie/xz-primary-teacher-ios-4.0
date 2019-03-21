//
//  XLButtonBarView.h
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "XLPagerTabStripViewController.h"

typedef NS_ENUM(NSUInteger, XLPagerScroll) {
    XLPagerScrollNO,
    XLPagerScrollYES,
    XLPagerScrollOnlyIfOutOfScreen
};

typedef NS_ENUM(NSUInteger, XLSelectedBarAlignment) {
    XLSelectedBarAlignmentLeft,
    XLSelectedBarAlignmentCenter,
    XLSelectedBarAlignmentRight,
    XLSelectedBarAlignmentProgressive
};

@interface XLButtonBarView : UICollectionView
//是否爬行动画   默认为no
@property (assign, nonatomic) BOOL isAutoCrawlerIndicator;
//是否根据内容自动识别宽  默认为no
@property (assign, nonatomic) BOOL isAutoIndicatorWidth;
//设定固定的宽
@property (assign,nonatomic) CGFloat indicatorWidth;
@property (strong, nonatomic) UIView * selectedBar;
//
@property (nonatomic) CGFloat selectedBarHeight;
@property (nonatomic) CGFloat bottomLineHeight;
@property (nonatomic) XLSelectedBarAlignment selectedBarAlignment;
@property (nonatomic) BOOL shouldCellsFillAvailableWidth;
@property UIFont * labelFont;
@property NSUInteger leftRightMargin;

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated swipeDirection:(XLPagerTabStripDirection)swipeDirection pagerScroll:(XLPagerScroll)pagerScroll;

-(void)moveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withProgressPercentage:(CGFloat)progressPercentage pagerScroll:(XLPagerScroll)pagerScroll;


-(void)updateselectBarFrameWithoffset:(CGFloat)offsetx  wideMultiple:(NSUInteger)wideMultiple ;

- (void)initBarFrame;
- (void)updateIndex:(NSInteger) selectedOptionIndex;
@end