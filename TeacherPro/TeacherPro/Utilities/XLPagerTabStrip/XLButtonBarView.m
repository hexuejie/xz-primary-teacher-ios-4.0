//
//  XLButtonBarView.m
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

@interface XLButtonBarView ()

 
@property UIView * bottomLineView;
@property NSUInteger selectedOptionIndex;
@property NSUInteger selectedBarOptionIndex;
@end

@implementation XLButtonBarView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeXLButtonBarView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeXLButtonBarView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initializeXLButtonBarView];
    }
    return self;
}


-(void)initializeXLButtonBarView
{
    _selectedOptionIndex = 0;
    _selectedBarOptionIndex = 0;
    _selectedBarHeight = 5;
    _bottomLineHeight = 3;
    
    if ([self.selectedBar superview] == nil){
        [self addSubview:self.selectedBar];
    }
   
}


-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated swipeDirection:(XLPagerTabStripDirection)swipeDirection pagerScroll:(XLPagerScroll)pagerScroll
{
    self.selectedOptionIndex = index;
    [self updateSelectedBarPositionWithAnimation:animated swipeDirection:swipeDirection pagerScroll:pagerScroll];

}

-(void)moveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withProgressPercentage:(CGFloat)progressPercentage pagerScroll:(XLPagerScroll)pagerScroll
{
    // First, calculate and set the frame of the 'selectedBar'
    
    self.selectedOptionIndex = (progressPercentage > 0.5 ) ? toIndex : fromIndex;
    
    CGRect fromFrame = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]].frame;
    NSInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    CGRect toFrame;
  
    if (toIndex < 0 || toIndex > numberOfItems - 1){
        if (toIndex < 0) {
            UICollectionViewLayoutAttributes * cellAtts = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            toFrame = CGRectOffset(cellAtts.frame, -cellAtts.frame.size.width, 0);
        }
        else{
            UICollectionViewLayoutAttributes * cellAtts = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:(numberOfItems - 1) inSection:0]];
            toFrame = CGRectOffset(cellAtts.frame, cellAtts.frame.size.width, 0);
        }
    }
    else{
        toFrame = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]].frame;
    }
    
    if (!self.isAutoIndicatorWidth) {
        CGFloat toFrameCellW = toFrame.size.width;
        toFrame.size.width = self.indicatorWidth?self.indicatorWidth:20;
        toFrame.origin.x = toFrame.origin.x + toFrameCellW/2 -toFrame.size.width/2;
        
        CGFloat fromFrameCellW = fromFrame.size.width;
        fromFrame.size.width =  self.indicatorWidth?self.indicatorWidth:20;
        fromFrame.origin.x = fromFrame.origin.x + fromFrameCellW/2 -fromFrame.size.width/2;
    }
    
    
    CGRect targetFrame = fromFrame;
    targetFrame.size.width = fromFrame.size.width;
    
    targetFrame.size.height = self.selectedBar.frame.size.height;
    
    CGRect selectedBarFrame = CGRectZero;
    if (!self.isAutoCrawlerIndicator) {
        targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * progressPercentage;
        targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * progressPercentage;
        selectedBarFrame = CGRectMake(targetFrame.origin.x, self.selectedBar.frame.origin.y, targetFrame.size.width, self.selectedBar.frame.size.height);
    }else{
        
        CGFloat fromCenterX = CGRectGetMidX(fromFrame)  ;
        CGFloat toCenterX = CGRectGetMidX(toFrame) ;
        // 爬行的宽
        CGFloat crawlingWidth = fabs(toCenterX - fromCenterX);
        
  
        CGFloat offsetX =  progressPercentage * crawlingWidth;
        CGFloat indicatorW = fromFrame.size.width;
        if (!self.isAutoIndicatorWidth) {
             indicatorW = self.indicatorWidth?self.indicatorWidth:20;
        }
//         printf("\n==offsetX==%f===progressPercentage==%f",offsetX,progressPercentage);
 
            if ( offsetX < crawlingWidth / 2) {
                targetFrame.size.width = offsetX * 2 + indicatorW;
                if (toIndex > fromIndex) {
                    //右滑
                     targetFrame.origin.x = fromCenterX - indicatorW/2;
                }else if (toIndex < fromIndex){
                    //左滑
                     targetFrame.origin.x = fromCenterX + indicatorW/2 - targetFrame.size.width;
                }
               
            }else {
                targetFrame.size.width = (crawlingWidth - offsetX) * 2 +indicatorW;
                 if (toIndex > fromIndex) {
                      //右滑
                     targetFrame.origin.x = toCenterX +indicatorW/2 - targetFrame.size.width;
                     
                 }else if (toIndex < fromIndex){
                     //左滑
                     targetFrame.origin.x = toCenterX - indicatorW/2;
                 }
                
            }
 
        selectedBarFrame = CGRectMake(targetFrame.origin.x, self.selectedBar.frame.origin.y, targetFrame.size.width, self.selectedBar.frame.size.height);
    }
 
    self.selectedBar.frame = selectedBarFrame;
    
    // Next, calculate and set the contentOffset of the UICollectionView
    // (so it scrolls the selectedBar into the appriopriate place given the self.selectedBarAlignment)
    
    float targetContentOffset = 0;
    // Only bother calculating the contentOffset if there are sufficient tabs that the bar can actually scroll!
    if (self.contentSize.width > self.frame.size.width)
    {
        CGFloat toContentOffset = [self contentOffsetForCellWithFrame:toFrame index:toIndex];
        CGFloat fromContentOffset = [self contentOffsetForCellWithFrame:fromFrame index:fromIndex];
        
        targetContentOffset = fromContentOffset + ((toContentOffset - fromContentOffset) * progressPercentage);
    }
    
    // If there is a large difference between the current contentOffset and the contentOffset we're about to set
    // then the change might be visually jarring so animate it.  (This will likely occur if the user manually
    // scrolled the XLButtonBarView and then subsequently scrolled the UIPageViewController)
    // Alternatively if the fromIndex and toIndex are the same then this is the last call to this method in the
    // progression so as a precaution always animate this contentOffest change
    BOOL animated = (ABS(self.contentOffset.x - targetContentOffset) > 30) || (fromIndex == toIndex);
    
    [self setContentOffset:CGPointMake(targetContentOffset, 0) animated:animated];
}


-(void)updateSelectedBarPositionWithAnimation:(BOOL)animation swipeDirection:(XLPagerTabStripDirection __unused)swipeDirection pagerScroll:(XLPagerScroll)pagerScroll
{
    CGRect selectedBarFrame = self.selectedBar.frame;
    
    NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForItem:self.selectedOptionIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:selectedCellIndexPath];
    CGRect selectedCellFrame = attributes.frame;
    
    [self updateContentOffsetAnimated:animation pagerScroll:pagerScroll toFrame:selectedCellFrame toIndex:selectedCellIndexPath.row];
    if (self.isAutoIndicatorWidth) {
        selectedBarFrame.size.width = selectedCellFrame.size.width;
        selectedBarFrame.origin.x = selectedCellFrame.origin.x ;
    }else{
        selectedBarFrame.size.width = self.indicatorWidth?self.indicatorWidth:20;
        selectedBarFrame.origin.x = selectedCellFrame.origin.x + attributes.frame.size.width/2 -selectedBarFrame.size.width/2;
    }
    
    if (animation){
        [UIView animateWithDuration:0.3 animations:^{
            self.selectedBar.frame = selectedBarFrame;
           
        }];
    }
    else{
        self.selectedBar.frame = selectedBarFrame;
   
    }

}



#pragma mark - Helpers

- (void)updateContentOffsetAnimated:(BOOL)animated pagerScroll:(XLPagerScroll)pageScroller toFrame:(CGRect)selectedCellFrame toIndex:(NSUInteger)toIndex
{
    if (pageScroller != XLPagerScrollNO)
    {
        if (pageScroller == XLPagerScrollOnlyIfOutOfScreen)
        {
            if  ((selectedCellFrame.origin.x  >= self.contentOffset.x)
                 && (selectedCellFrame.origin.x < (self.contentOffset.x + self.frame.size.width - self.contentInset.left))){
                return;
            }
        }
        
        CGFloat targetContentOffset = 0;
        // Only bother calculating the contentOffset if there are sufficient tabs that the bar can actually scroll!
        if (self.contentSize.width > self.frame.size.width)
        {
            targetContentOffset = [self contentOffsetForCellWithFrame:selectedCellFrame index:toIndex];
        }
        
        [self setContentOffset:CGPointMake(targetContentOffset, 0) animated:animated];
    }
}

- (CGFloat)contentOffsetForCellWithFrame:(CGRect)cellFrame index:(NSUInteger)index
{
    UIEdgeInsets sectionInset = ((UICollectionViewFlowLayout *)self.collectionViewLayout).sectionInset;
    
    CGFloat alignmentOffset = 0;
    
    switch (self.selectedBarAlignment)
    {
        case XLSelectedBarAlignmentLeft:
        {
            alignmentOffset = sectionInset.left;
            break;
        }
        case XLSelectedBarAlignmentRight:
        {
            alignmentOffset = self.frame.size.width - sectionInset.right - cellFrame.size.width;
            break;
        }
        case XLSelectedBarAlignmentCenter:
        {
            alignmentOffset = (self.frame.size.width - cellFrame.size.width) * 0.5;
            break;
        }
        case XLSelectedBarAlignmentProgressive:
        {
            CGFloat cellHalfWidth = cellFrame.size.width * 0.5;
            CGFloat leftAlignmentOffest = sectionInset.left + cellHalfWidth;
            CGFloat rightAlignmentOffset = self.frame.size.width - sectionInset.right - cellHalfWidth;
            NSInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
            CGFloat progress = index / (CGFloat)(numberOfItems - 1);
            alignmentOffset = leftAlignmentOffest + ((rightAlignmentOffset - leftAlignmentOffest) * progress) - cellHalfWidth;
            break;
        }
    }
    
    CGFloat contentOffset = cellFrame.origin.x - alignmentOffset;
    
    // Ensure that the contentOffset wouldn't scroll the UICollectioView passed the beginning
    contentOffset = MAX(0, contentOffset);
    // Ensure that the contentOffset wouldn't scroll the UICollectioView passed the end
    contentOffset = MIN(self.contentSize.width - self.frame.size.width, contentOffset);
    
    return contentOffset;
}

#pragma mark - Properties

- (void)setSelectedBarHeight:(CGFloat)selectedBarHeight
{
    _selectedBarHeight = selectedBarHeight;
    _selectedBar.frame = CGRectMake(_selectedBar.frame.origin.x, self.frame.size.height - _selectedBarHeight, _selectedBar.frame.size.width, _selectedBarHeight);
}

- (UIView *)selectedBar
{
    if (!_selectedBar) {
        _selectedBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - _selectedBarHeight, 0, _selectedBarHeight)];
        _selectedBar.layer.zPosition = 9999;
        _selectedBar.backgroundColor = [UIColor blackColor];
    }
    return _selectedBar;
}
- (void)setBottomLineHeight:(CGFloat)bottomLineHeight
{
    _bottomLineHeight = bottomLineHeight;
    _bottomLineView.frame = CGRectMake(_bottomLineView.frame.origin.x, self.frame.size.height - _bottomLineHeight , _bottomLineView.frame.size.width, _bottomLineHeight);
}



-(void)updateselectBarFrameWithoffset:(CGFloat)offsetx wideMultiple:(NSUInteger)wideMultiple  {
    
    CGRect selectedBarFrame = self.selectedBar.frame;
  
  
    NSInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionViewLayout;
    CGFloat space =   (numberOfItems -1)* flowLayout.minimumInteritemSpacing /numberOfItems;
    
    NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForItem:self.selectedBarOptionIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:selectedCellIndexPath];
    CGFloat indicatorWidth = attributes.frame.size.width;
    
    CGFloat btn_w =  indicatorWidth+ space;// 宽度
//    CGFloat btn_w = IPHONE_WIDTH/numberOfItems;
    CGFloat w =  btn_w;
 
    CGFloat line_x = (btn_w - w )/2 + (self.selectedBarOptionIndex) * btn_w;
    
 
     CGFloat max_w =  btn_w * wideMultiple ;
    if (offsetx < (self.selectedBarOptionIndex) *  [UIScreen mainScreen].bounds.size.width) {
//        NSLog(@"指示标 向左");
 
        CGFloat endoffsetx = (self.selectedBarOptionIndex) * [UIScreen mainScreen].bounds.size.width - offsetx;
        if ( w + MIN(endoffsetx, max_w) < max_w) {

            selectedBarFrame.size.width = w + MIN(endoffsetx, max_w);
        }else{

            selectedBarFrame.size.width = max_w;

            
        }
        selectedBarFrame.origin.x = w +line_x - selectedBarFrame.size.width ;
        self.selectedBar.frame = selectedBarFrame;

        
    }else{
//        NSLog(@"指示标 向右");

        CGFloat endoffsetx = offsetx - (self.selectedBarOptionIndex)*  [UIScreen mainScreen].bounds.size.width;
        
        if ( w + MIN(endoffsetx, max_w)< max_w) {
           

            selectedBarFrame.size.width = w + MIN(endoffsetx, max_w);

        }else{
           

            selectedBarFrame.size.width = max_w;

        }
        self.selectedBar.frame = selectedBarFrame;
  
    }

    
    
}


- (void)initBarFrame{

    NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForItem:self.selectedBarOptionIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:selectedCellIndexPath];
    CGRect selectedCellFrame = attributes.frame;
    
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionViewLayout;
   NSInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    CGFloat space =   (numberOfItems -1)* flowLayout.minimumInteritemSpacing /numberOfItems;
 
    selectedCellFrame.size.height = self.selectedBarHeight;
    selectedCellFrame.origin.x = self.selectedBar.frame.origin.x;
    selectedCellFrame.origin.y = self.selectedBar.frame.origin.y;
    selectedCellFrame.size.width =  selectedCellFrame.size.width +space;
    self.selectedBar.frame  = selectedCellFrame;
    [self updateIndex:self.selectedBarOptionIndex];
}

- (void)updateIndex:(NSInteger) selectedOptionIndex{
    self.selectedBarOptionIndex = selectedOptionIndex;
    
    CGRect selectedBarFrame = self.selectedBar.frame;
    NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForItem:self.selectedBarOptionIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:selectedCellIndexPath];
      CGRect selectedCellFrame = attributes.frame;
     CGFloat lineW = selectedCellFrame.size.width;

 
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = selectedBarFrame;
        frame.origin.x = selectedCellFrame.origin.x ;
        frame.size.width = lineW;
     
        self.selectedBar.frame = frame;
        
    }];
 
}
@end
