//
//  XLButtonBarPagerTabStripViewController.m
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

#import "XLButtonBarViewCell.h"
#import "XLButtonBarPagerTabStripViewController.h"



 
@interface XLButtonBarPagerTabStripViewController () <UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic) BOOL shouldUpdateButtonBarView;
@property (nonatomic) NSArray *cachedCellWidths;
@property (nonatomic) BOOL isViewAppearing;
@property (nonatomic) BOOL isViewRotating;
@property (nonatomic) BOOL isSlidingSwitchPage;//判断是否滑动切换新页面、 用于加载新页面的数据
@end

@implementation XLButtonBarPagerTabStripViewController

#pragma mark - Initialisation

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shouldUpdateButtonBarView = YES;
       
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.shouldUpdateButtonBarView = YES;
    }
    return self;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.buttonBarView.superview){
        // If buttonBarView wasn't configured in a XIB or storyboard then it won't have
        // been added to the view so we need to do it programmatically.
        [self.view addSubview:self.buttonBarView];
    }
    if (!self.bottomLineView.superview){
        // If buttonBarView wasn't configured in a XIB or storyboard then it won't have
        // been added to the view so we need to do it programmatically.
        [self.view addSubview:self.bottomLineView];
    }
    
    if (!self.buttonBarView.delegate){
        self.buttonBarView.delegate = self;
    }
    if (!self.buttonBarView.dataSource){
        self.buttonBarView.dataSource = self;
    }
    self.buttonBarView.labelFont = [UIFont boldSystemFontOfSize:18.0f];
    self.buttonBarView.leftRightMargin = 8;
    self.buttonBarView.scrollsToTop = NO;

    UICollectionViewFlowLayout *flowLayout = (id)self.buttonBarView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.buttonBarView.showsHorizontalScrollIndicator = NO;
    self.itemColorChangeFollowContentScroll = YES;
    self.itemFontChangeFollowContentScroll = YES;
    self.itemTitleFont = [UIFont systemFontOfSize:14];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.buttonBarView layoutIfNeeded];
    self.isViewAppearing = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isViewAppearing = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.isViewAppearing || self.isViewRotating) {
        // Force the UICollectionViewFlowLayout to get laid out again with the new size if
        // a) The view is appearing.  This ensures that
        //    collectionView:layout:sizeForItemAtIndexPath: is called for a second time
        //    when the view is shown and when the view *frame(s)* are actually set
        //    (we need the view frame's to have been set to work out the size's and on the
        //    first call to collectionView:layout:sizeForItemAtIndexPath: the view frame(s)
        //    aren't set correctly)
        // b) The view is rotating.  This ensures that
        //    collectionView:layout:sizeForItemAtIndexPath: is called again and can use the views
        //    *new* frame so that the buttonBarView cell's actually get resized correctly
        self.cachedCellWidths = nil; // Clear/invalidate our cache of cell widths
        UICollectionViewFlowLayout *flowLayout = (id)self.buttonBarView.collectionViewLayout;
        [flowLayout invalidateLayout];
        
        // Ensure the buttonBarView.frame is sized correctly after rotation on iOS 7 devices
        [self.buttonBarView layoutIfNeeded];
        
        // When the view first appears or is rotated we also need to ensure that the barButtonView's
        // selectedBar is resized and its contentOffset/scroll is set correctly (the selected
        // tab/cell may end up either skewed or off screen after a rotation otherwise)
        [self.buttonBarView moveToIndex:self.currentIndex animated:NO swipeDirection:XLPagerTabStripDirectionNone pagerScroll:XLPagerScrollOnlyIfOutOfScreen];
//        [self.buttonBarView initBarFrame];
    }
}


#pragma mark - View Rotation

// Called on iOS 8+ only
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.isViewRotating = YES;
    __typeof__(self) __weak weakSelf = self;
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     weakSelf.isViewRotating = NO;
                                 }];
}

// Called on iOS 7 only
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.isViewRotating = YES;
}

#pragma mark - Public methods

-(void)reloadPagerTabStripView
{
    self.cachedCellWidths = nil; // Clear/invalidate our cache of cell widths
 
    [super reloadPagerTabStripView];
    if ([self isViewLoaded]){
        [self.buttonBarView reloadData];
        [self.buttonBarView moveToIndex:self.currentIndex animated:NO swipeDirection:XLPagerTabStripDirectionNone pagerScroll:XLPagerScrollYES];
    }
}


#pragma mark - Properties
- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.buttonBarView.frame)-1,self.view.frame.size.width, 1)];
        
    }
    return _bottomLineView;
}
-(XLButtonBarView *)buttonBarView
{
    if (_buttonBarView) return _buttonBarView;
    
    // If _buttonBarView is nil then it wasn't configured in a XIB or storyboard so
    // this class is being used programmatically. We need to initialise the buttonBarView,
    // setup some sensible defaults (which can of course always be re-set in the sub-class),
    // and set an appropriate frame. The buttonBarView gets added to to the view in viewDidLoad:
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 35, 0, 35);
    _buttonBarView = [[XLButtonBarView alloc] initWithFrame:[self buttonBarViewFrame] collectionViewLayout:flowLayout];
    _buttonBarView.backgroundColor = [UIColor whiteColor];
//    _buttonBarView.selectedBar.backgroundColor = UIColorFromRGB(0xAD9B6A);
    _buttonBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // If a XIB or storyboard hasn't been used we also need to register the cell reuseIdentifier
    // as well otherwise we'll get a crash when the code attempts to dequeue any cell's
    NSBundle * bundle = [NSBundle bundleForClass:[XLButtonBarView class]];
    NSURL * url = [bundle URLForResource:@"XLPagerTabStrip" withExtension:@"bundle"];
    if (url){
        bundle =  [NSBundle bundleWithURL:url];
    }
    [_buttonBarView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:bundle] forCellWithReuseIdentifier:@"Cell"];
    // If a XIB or storyboard hasn't been used then the containView frame that was setup in the
    // XLPagerTabStripViewController won't have accounted for the buttonBarView. So we need to adjust
    // its y position (and also its height) so that childVC's don't appear under the buttonBarView.

    self.containerView.frame = [self containerViewFrame];
    
    return _buttonBarView;
}

- (CGRect )buttonBarViewFrame{
    CGRect  buttonBarViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.buttonBarHeight?self.buttonBarHeight:44.0f);
    return buttonBarViewFrame;
}

- (CGRect )containerViewFrame{
    CGRect newContainerViewFrame = self.containerView.frame;
    newContainerViewFrame.origin.y = CGRectGetMaxY(self.buttonBarView.frame);
    newContainerViewFrame.size.height = self.containerView.frame.size.height - (CGRectGetMaxY(self.buttonBarView.frame) - self.containerView.frame.origin.y);
 
    return newContainerViewFrame;
}

- (NSArray *)cachedCellWidths
{
    if (!_cachedCellWidths)
    {
        // First calculate the minimum width required by each cell
        
        UICollectionViewFlowLayout *flowLayout = (id)self.buttonBarView.collectionViewLayout;
        NSUInteger numberOfCells = self.pagerTabStripChildViewControllers.count;
        
        NSMutableArray *minimumCellWidths = [[NSMutableArray alloc] init];
        
        CGFloat collectionViewContentWidth = 0;
        
        for (UIViewController<XLPagerTabStripChildItem> *childController in self.pagerTabStripChildViewControllers)
        {
            UILabel *label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.font = self.buttonBarView.labelFont;
            label.text = [childController titleForPagerTabStripViewController:self];
            CGSize labelSize = [label intrinsicContentSize];
            
            CGFloat minimumCellWidth = labelSize.width + (self.buttonBarView.leftRightMargin * 2);
            NSNumber *minimumCellWidthValue = [NSNumber numberWithFloat:minimumCellWidth];
            [minimumCellWidths addObject:minimumCellWidthValue];
            
            collectionViewContentWidth += minimumCellWidth;
        }
        
        // To get an acurate collectionViewContentWidth account for the spacing between cells
        CGFloat cellSpacingTotal = ((numberOfCells-1) * flowLayout.minimumInteritemSpacing);
        collectionViewContentWidth += cellSpacingTotal;
        
        CGFloat collectionViewAvailableVisibleWidth = self.buttonBarView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
        CGFloat left = flowLayout.sectionInset.left;
        CGFloat right = flowLayout.sectionInset.right;
        
        NSLog(@"%f==%f==%f",left,right,self.buttonBarView.frame.size.width);
        // Do we need to stetch any of the cell widths to fill the screen width?
        if (!self.buttonBarView.shouldCellsFillAvailableWidth || collectionViewAvailableVisibleWidth < collectionViewContentWidth)
        {
            // The collection view's content width is larger that the visible width available so it needs to scroll
            // OR shouldCellsFillAvailableWidth == NO...
            // No need to stretch any of the cells, we can just use the minimumCellWidths for the cell widths.
            _cachedCellWidths = minimumCellWidths;
        }
        else
        {
            // The collection view's content width is smaller that the visible width available so it won't ever scroll
            // AND shouldCellsFillAvailableWidth == YES so we want to stretch the cells to fill the width.
            // We now need to calculate how much to stretch each tab...
            
            // In an ideal world the cell's would all have an equal width, however the cell labels vary in length
            // so some of the longer labelled cells might not need to stetch where as the shorter labelled cells do.
            // In order to determine what needs to stretch and what doesn't we have to recurse through suggestedStetchedCellWidth
            // values (the value decreases with each recursive call) until we find a value that works.
            // The first value to try is the largest (for the case where all the cell widths are equal)
            CGFloat stetchedCellWidthIfAllEqual = (collectionViewAvailableVisibleWidth - cellSpacingTotal) / numberOfCells;
            
            CGFloat generalMiniumCellWidth = [self calculateStretchedCellWidths:minimumCellWidths suggestedStetchedCellWidth:stetchedCellWidthIfAllEqual previousNumberOfLargeCells:0];
            
            NSMutableArray *stetchedCellWidths = [[NSMutableArray alloc] init];
            
            for (NSNumber *minimumCellWidthValue in minimumCellWidths)
            {
                CGFloat minimumCellWidth = minimumCellWidthValue.floatValue;
                CGFloat cellWidth = (minimumCellWidth > generalMiniumCellWidth) ? minimumCellWidth : generalMiniumCellWidth;
                NSNumber *cellWidthValue = [NSNumber numberWithFloat:cellWidth];
                [stetchedCellWidths addObject:cellWidthValue];
            }
            
            _cachedCellWidths = stetchedCellWidths;
        }
    }
    return _cachedCellWidths;
}

- (CGFloat)calculateStretchedCellWidths:(NSArray *)minimumCellWidths suggestedStetchedCellWidth:(CGFloat)suggestedStetchedCellWidth previousNumberOfLargeCells:(NSUInteger)previousNumberOfLargeCells
{
    // Recursively attempt to calculate the stetched cell width
    
    NSUInteger numberOfLargeCells = 0;
    CGFloat totalWidthOfLargeCells = 0;
    
    for (NSNumber *minimumCellWidthValue in minimumCellWidths)
    {
        CGFloat minimumCellWidth = minimumCellWidthValue.floatValue;
        if (minimumCellWidth > suggestedStetchedCellWidth) {
            totalWidthOfLargeCells += minimumCellWidth;
            numberOfLargeCells++;
        }
    }
    
    // Is the suggested width any good?
    if (numberOfLargeCells > previousNumberOfLargeCells)
    {
        // The suggestedStetchedCellWidth is no good :-( ... calculate a new suggested width
        UICollectionViewFlowLayout *flowLayout = (id)self.buttonBarView.collectionViewLayout;
        CGFloat collectionViewAvailableVisibleWidth = self.buttonBarView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
        NSUInteger numberOfCells = minimumCellWidths.count;
        CGFloat cellSpacingTotal = ((numberOfCells-1) * flowLayout.minimumInteritemSpacing);
        
        NSUInteger numberOfSmallCells = numberOfCells - numberOfLargeCells;
        CGFloat newSuggestedStetchedCellWidth =  (collectionViewAvailableVisibleWidth - totalWidthOfLargeCells - cellSpacingTotal) / numberOfSmallCells;
        
        return [self calculateStretchedCellWidths:minimumCellWidths suggestedStetchedCellWidth:newSuggestedStetchedCellWidth previousNumberOfLargeCells:numberOfLargeCells];
    }
    
    // The suggestion is good
    return suggestedStetchedCellWidth;
}


#pragma mark - XLPagerTabStripViewControllerDelegate

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
{
    if (self.shouldUpdateButtonBarView){
        XLPagerTabStripDirection direction = XLPagerTabStripDirectionLeft;
        if (toIndex < fromIndex){
            direction = XLPagerTabStripDirectionRight;
        }
        [self.buttonBarView moveToIndex:toIndex animated:YES swipeDirection:direction pagerScroll:XLPagerScrollYES];
        
        XLButtonBarViewCell *oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex != fromIndex ? fromIndex : toIndex inSection:0]];
        
        XLButtonBarViewCell *newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        
       [self setupOldCellState:oldCell withNewCellState:newCell];
        
        if (self.changeCurrentIndexBlock) {
            XLButtonBarViewCell *oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex != fromIndex ? fromIndex : toIndex inSection:0]];
            
            XLButtonBarViewCell *newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            self.changeCurrentIndexBlock(oldCell, newCell, YES);
        }
    }
    if (self.isClickChangeView) {
        if (self.touchIndex !=toIndex) {
            return ;
        }
    }
    
    self.isSlidingSwitchPage = YES;
}

- (void)updateCurrentPageData{
    if (self.isSlidingSwitchPage) {
        [self changeCurrentIndexUpdate:self.currentIndex];
    }
    
}
- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    
    
}
-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
                   indexWasChanged:(BOOL)indexWasChanged
{
    if (self.shouldUpdateButtonBarView){
        [self.buttonBarView moveFromIndex:fromIndex
                                  toIndex:toIndex
                   withProgressPercentage:progressPercentage pagerScroll:XLPagerScrollYES];

        if (progressPercentage > 0.5) {
             self.isSlidingSwitchPage = YES;
        }else{
             self.isSlidingSwitchPage = NO;
        }
        XLButtonBarViewCell *oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex != fromIndex ? fromIndex : toIndex inSection:0]];
        XLButtonBarViewCell *newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];

         [self setupOldCellState:oldCell withNewCellState:newCell ];

        if (self.changeCurrentIndexProgressiveBlock) {
            XLButtonBarViewCell *oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex != fromIndex ? fromIndex : toIndex inSection:0]];
            XLButtonBarViewCell *newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            self.changeCurrentIndexProgressiveBlock(oldCell, newCell, progressPercentage, indexWasChanged, YES);

        }
    }
}

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
            withProgressRightScale:(CGFloat)rightScale
             withProgressLeftScale:(CGFloat)leftScale
                   indexWasChanged:(BOOL)indexWasChanged
                  isJumpChangeView:(BOOL)isJumpChangeView
{
    if (self.shouldUpdateButtonBarView){
        [self.buttonBarView moveFromIndex:fromIndex
                                  toIndex:toIndex
                   withProgressPercentage:progressPercentage pagerScroll:XLPagerScrollYES];
        if (progressPercentage > 0.5) {
            self.isSlidingSwitchPage = YES;
        }else{
            self.isSlidingSwitchPage = NO;
        }
        XLButtonBarViewCell *oldCell = nil;
        XLButtonBarViewCell *newCell =nil;
        if (!self.itemColorChangeFollowContentScroll) {
          oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex != fromIndex ? fromIndex : toIndex inSection:0]];
            newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            
            [self setupOldCellState:oldCell withNewCellState:newCell ];

        }else{
            if (isJumpChangeView) {
                newCell  = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem: 0 inSection:0]];
                oldCell  = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:  toIndex inSection:0]];
            }else{
                oldCell  = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem: leftScale ==1 ?toIndex: fromIndex inSection:0]];
                if ((leftScale != 1 && fromIndex < toIndex)||fromIndex > toIndex) {
                    //避免右滑最后 newcell 和oldcell 重叠 颜色错乱
                    newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:  toIndex inSection:0]];
                }
                
            }
            
            //        printf("\n=fromIndex==%ld== toIndex==%ld==self.currentIndex==%ld",fromIndex,toIndex,self.currentIndex);
            
            /***
             左右滑动颜色值差值交换
             **/
            //右滑
            if (fromIndex < toIndex) {
                
                [self setupOldCellState:oldCell withNewCellState:newCell withRightScale:rightScale withProgressLeftScale:leftScale];
            }else if (fromIndex >toIndex){
                //左滑
                [self setupOldCellState:oldCell withNewCellState:newCell withRightScale: leftScale withProgressLeftScale:rightScale];
            }
        }
        
 
        if (self.changeCurrentIndexProgressiveBlock) {
            XLButtonBarViewCell *oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex != fromIndex ? fromIndex : toIndex inSection:0]];
            XLButtonBarViewCell *newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            self.changeCurrentIndexProgressiveBlock(oldCell, newCell, progressPercentage, indexWasChanged, YES);
            
        }
    }
    
}


-(void)setupOldCellState:(XLButtonBarViewCell *)oldCell withNewCellState:(XLButtonBarViewCell *)newCell withRightScale:(CGFloat)rightScale withProgressLeftScale:(CGFloat)leftScale{

    CGFloat normalRed, normalGreen, normalBlue, normalAlpha;
    CGFloat selectedRed, selectedGreen, selectedBlue, selectedAlpha;
    
    [[self getTabTitleColorNor] getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
    [[self getTabTitleColorSelected] getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:&selectedAlpha];
    
    // 获取选中和未选中状态的颜色差值
    CGFloat redDiff = selectedRed - normalRed;
    CGFloat greenDiff = selectedGreen - normalGreen;
    CGFloat blueDiff = selectedBlue - normalBlue;
    CGFloat alphaDiff = selectedAlpha - normalAlpha;
 printf("\n=alphaDiff==%f===%f==rightScale==%f==leftScale==%f",redDiff,alphaDiff,rightScale,leftScale);
    
    if (oldCell) {
        oldCell.label.textColor =  [UIColor colorWithRed:leftScale * redDiff + normalRed
                                                   green:leftScale * greenDiff + normalGreen
                                                    blue:leftScale * blueDiff + normalBlue
                                                   alpha:leftScale * alphaDiff + normalAlpha];
        

        oldCell.imageView.highlighted = NO;
        oldCell.button.selected = NO;
        
        if (self.itemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0f) {
            // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
            
            // 计算字体大小的差值
            CGFloat diff = self.itemTitleUnselectedFontScale - 1;
            // 根据偏移量和差值，计算缩放值
            oldCell.label.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1);
            
        }
    }
    
    if (newCell) {
        newCell.label.textColor =[UIColor colorWithRed:rightScale * redDiff + normalRed
                                                 green:rightScale * greenDiff + normalGreen
                                                  blue:rightScale * blueDiff + normalBlue
                                                 alpha:rightScale * alphaDiff + normalAlpha];
      
        newCell.imageView.highlighted = YES;
        newCell.button.selected = YES;
        if (self.itemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0f) {
            // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
            
            // 计算字体大小的差值
            CGFloat diff = self.itemTitleUnselectedFontScale - 1;
            // 根据偏移量和差值，计算缩放值
       
          newCell.label.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1);
        }
    }
    

}


/**
 *  获取未选中字体与选中字体大小的比例
 */
- (CGFloat)itemTitleUnselectedFontScale {
    if (_itemTitleSelectedFont) {
        return self.itemTitleFont.pointSize / _itemTitleSelectedFont.pointSize;
    }
    return 1.0f;
}

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
                     updateToIndex:(NSInteger)toIndex{

    
}

- (void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController offset:(CGFloat)offsetx wideMultiple:(NSUInteger)wideMultiple{
  
    [self.buttonBarView updateselectBarFrameWithoffset:offsetx  wideMultiple: wideMultiple ];
      
}

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
              updateNetworkToIndex:(NSInteger)toIndex{
  
//    [self.buttonBarView updateIndex:toIndex];
    
}
- (void)pagerTabStripViewControllerTouchTabUpdateIndex:(NSUInteger)index{

    [self.buttonBarView updateIndex:index];
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cachedCellWidths.count > indexPath.row)
    {
        NSNumber *cellWidthValue = self.cachedCellWidths[indexPath.row];
        CGFloat cellWidth = [cellWidthValue floatValue];
        return CGSizeMake(cellWidth, collectionView.frame.size.height);
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //There's nothing to do if we select the current selected tab
	if (indexPath.item == self.currentIndex)
		return;
	
    [self.buttonBarView moveToIndex:indexPath.item animated:YES swipeDirection:XLPagerTabStripDirectionNone pagerScroll:XLPagerScrollYES];
    self.shouldUpdateButtonBarView = NO;
    
    XLButtonBarViewCell *oldCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
 
    XLButtonBarViewCell *newCell = (XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]];
    
    
    [self setupOldCellState:oldCell withNewCellState:newCell];
    
    if (self.isProgressiveIndicator) {
        if (self.changeCurrentIndexProgressiveBlock) {
            self.changeCurrentIndexProgressiveBlock(oldCell, newCell, 1, YES, YES);
        }
    }
    else{
        if (self.changeCurrentIndexBlock) {
            self.changeCurrentIndexBlock(oldCell, newCell, YES);
        }
    }
    
    [self moveToViewControllerAtIndex:indexPath.item];
}

#pragma merk - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pagerTabStripChildViewControllers.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLButtonBarViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSAssert([cell isKindOfClass:[XLButtonBarViewCell class]], @"UICollectionViewCell should be or extend XLButtonBarViewCell");
    XLButtonBarViewCell * buttonBarCell = (XLButtonBarViewCell *)cell;
    UIViewController<XLPagerTabStripChildItem> * childController =   [self.pagerTabStripChildViewControllers objectAtIndex:indexPath.item];
  
    [buttonBarCell.label setText:[childController titleForPagerTabStripViewController:self]];

     [buttonBarCell.button setTitle:[childController titleForPagerTabStripViewController:self] forState:UIControlStateNormal];
    
    if ([childController respondsToSelector:@selector(imageForPagerTabStripViewController:)]) {
        UIImage *image = [childController imageForPagerTabStripViewController:self];
        buttonBarCell.imageView.image = image;
        [buttonBarCell.button setImage:image forState:UIControlStateNormal];
    }
    
    if ([childController respondsToSelector:@selector(highlightedImageForPagerTabStripViewController:)]) {
        UIImage *image = [childController highlightedImageForPagerTabStripViewController:self];
        buttonBarCell.imageView.highlightedImage = image;
        [buttonBarCell.button setImage:image forState:UIControlStateSelected];
    }
    
    [buttonBarCell.button setTitleColor:HexRGB(0x525B66) forState:UIControlStateSelected];//13272059308
    [buttonBarCell.button setTitleColor:[self getTabTitleColorNor] forState:UIControlStateNormal];
    if(indexPath.row == 0){
 
        [self setupOldCellState:nil withNewCellState:buttonBarCell];
    }
    
    else{
         [self setupOldCellState:buttonBarCell withNewCellState:nil];
        
    }
    
    if (self.isProgressiveIndicator) {
        if (self.changeCurrentIndexProgressiveBlock) {
            self.changeCurrentIndexProgressiveBlock(self.currentIndex == indexPath.item ? nil : cell , self.currentIndex == indexPath.item ? cell : nil, 1, YES, NO);
        }
    }
    else{
        if (self.changeCurrentIndexBlock) {
            self.changeCurrentIndexBlock(self.currentIndex == indexPath.item ? nil : cell , self.currentIndex == indexPath.item ? cell : nil, NO);
        }
    }
    
    return buttonBarCell;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [super scrollViewDidEndScrollingAnimation:scrollView];
    if (scrollView == self.containerView){
        self.shouldUpdateButtonBarView = YES;
    }
}


-(void)setupOldCellState:(XLButtonBarViewCell *)oldCell withNewCellState:(XLButtonBarViewCell *)newCell{
//    printf("\ncell====newcell");
    if (oldCell) {
        oldCell.label.textColor =  [self getTabTitleColorNor];
       
        oldCell.imageView.highlighted = NO;
        oldCell.button.selected = NO;
        if (self.itemFontChangeFollowContentScroll) {
             oldCell.label.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale,
                                                             self.itemTitleUnselectedFontScale);
             
        }else{
             oldCell.label.font = self.itemTitleFont;
        }
    }
  
    if (newCell) {
        newCell.label.textColor = [self getTabTitleColorSelected];
        
        newCell.imageView.highlighted = YES;
        newCell.button.selected = YES;
        if (self.itemFontChangeFollowContentScroll) {
            // 如果支持字体平滑渐变切换，则设置item的scale
            newCell.label.transform = CGAffineTransformMakeScale(1, 1);
        } else{
            newCell.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            newCell.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            if (self.itemTitleSelectedFont) {
               newCell.label.font = self.itemTitleSelectedFont;
            }else{
                newCell.label.font = self.itemTitleFont;
            }
            
        }
    }
   
}

- (UIColor *)getTabTitleColorSelected{
    
    return HexRGB(0x525B66);
}
- (UIColor *)getTabTitleColorNor{
    return HexRGB(0xA1A7B3);
}
@end
