//
//  XLPagerTabStripViewController.h
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

#import <UIKit/UITableViewController.h>
#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
@class XLPagerTabStripViewController;

/**
 The `XLPagerTabStripChildItem` protocol is adopted by child controllers of XLPagerTabStripViewController. Each child view controller has to define a color and either a image or string in order to create the related UISegmentedControl option and update the color accordingly when the selected child view controller change.
 */
@protocol XLPagerTabStripChildItem <NSObject>

@required

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController;

@optional

- (UIImage *)imageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController;
- (UIImage *)highlightedImageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController;
- (UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController;

@end



typedef NS_ENUM(NSUInteger, XLPagerTabStripDirection) {
    XLPagerTabStripDirectionLeft,
    XLPagerTabStripDirectionRight,
    XLPagerTabStripDirectionNone
};



@protocol XLPagerTabStripViewControllerDelegate <NSObject>

@optional

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
                   indexWasChanged:(BOOL)indexWasChanged;

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
            withProgressRightScale:(CGFloat)rightScale
            withProgressLeftScale:(CGFloat)leftScale
                   indexWasChanged:(BOOL)indexWasChanged
                  isJumpChangeView:(BOOL)isJumpChangeView;


-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
                     updateNetworkToIndex:(NSInteger)toIndex;

- (void)pagerTabStripViewControllerTouchTabUpdateIndex:(NSUInteger )index;
- (void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
             offset:(CGFloat)offsetx
       wideMultiple:(NSUInteger) wideMultiple;
- (void)updateCurrentPageData;
@end


@protocol XLPagerTabStripViewControllerDataSource <NSObject>

@required

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController;

@end



@interface XLPagerTabStripViewController : BaseNetworkViewController <XLPagerTabStripViewControllerDelegate, XLPagerTabStripViewControllerDataSource, UIScrollViewDelegate>

@property (readonly) NSArray * pagerTabStripChildViewControllers;
@property (nonatomic, retain) IBOutlet UIScrollView * containerView;
@property (nonatomic, assign) IBOutlet id<XLPagerTabStripViewControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<XLPagerTabStripViewControllerDataSource> dataSource;

@property (assign, nonatomic) NSUInteger currentIndex;
//增加属性 点击的标签
@property ( readonly) NSUInteger touchIndex;


//增加属性 区分点击/滑动   Yes 点击  NO 滑动
@property ( readonly) BOOL isClickChangeView;
@property BOOL skipIntermediateViewControllers;
@property BOOL isProgressiveIndicator;
@property BOOL isElasticIndicatorLimit;
 @property  BOOL isJumpChangeView;
-(void)moveToViewControllerAtIndex:(NSUInteger)index;
-(void)moveToViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;
-(void)moveToViewController:(UIViewController *)viewController;
-(void)moveToViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(void)reloadPagerTabStripView;

@end
