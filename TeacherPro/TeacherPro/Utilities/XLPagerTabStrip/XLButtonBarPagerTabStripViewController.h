//
//  XLButtonBarPagerTabStripViewController.h
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

#import "XLButtonBarView.h"
#import "XLButtonBarViewCell.h"
#import "XLPagerTabStripViewController.h"

@interface XLButtonBarPagerTabStripViewController : XLPagerTabStripViewController

@property (copy) void (^changeCurrentIndexProgressiveBlock)(XLButtonBarViewCell* oldCell, XLButtonBarViewCell *newCell, CGFloat progressPercentage, BOOL indexWasChanged, BOOL fromCellRowAtIndex);
@property (copy) void (^changeCurrentIndexBlock)(XLButtonBarViewCell* oldCell, XLButtonBarViewCell *newCell, BOOL animated);

@property (strong, nonatomic) XLButtonBarView * buttonBarView;
@property (assign, nonatomic) CGFloat buttonBarHeight;
@property (strong, nonatomic) UIView * bottomLineView;
@property (nonatomic, strong) UIFont  *itemTitleFont;               // 标题字体
@property (nonatomic, strong) UIFont  *itemTitleSelectedFont;       // 选中时标题的字体
/**
 *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
 */
@property (nonatomic, assign, getter = isItemColorChangeFollowContentScroll) BOOL itemColorChangeFollowContentScroll;

/**
 *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
 */
@property (nonatomic, assign, getter = isItemFontChangeFollowContentScroll) BOOL itemFontChangeFollowContentScroll;
//添加检测当前显示的视图改变时 调用子类方法  toindex 显示的视图下标  isClickChangeView Yes 点击切换  NO为滑动切换
- (void)changeCurrentIndexUpdate:(NSInteger )toIndex;

- (CGRect )buttonBarViewFrame;
- (CGRect )containerViewFrame;
- (UIColor *)getTabTitleColorSelected;
- (UIColor *)getTabTitleColorNor;
@end
