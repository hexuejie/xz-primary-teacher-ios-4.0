//
//  UICollectionView+LXMoveDeleteCell.m
//  lexiwed2
//
//  Created by ganyue on 2018/7/2.
//  Copyright © 2018年 乐喜网. All rights reserved.
//

#import "UICollectionView+LXMoveDeleteCell.h"
#import <objc/runtime.h>
typedef NS_ENUM(NSUInteger, AutoScrollDirection) {
    AutoScrollDirectionNone = 0,
    AutoScrollDirectionUp,
    AutoScrollDirectionDown,
    AutoScrollDirectionLeft,
    AutoScrollDirectionRight
};

@interface UICollectionView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *rearrangeLong;
@property (nonatomic, assign) AutoScrollDirection autoScrollDirection;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *moveView;
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;
@property (nonatomic, strong) UICollectionViewCell *moveCell;

@property (nonatomic, assign) CGPoint offsetPoint;
@end

@implementation UICollectionView (LXMoveDeleteCell)

#pragma mark - Getter & Setter

- (CGPoint)offsetPoint{
    return [objc_getAssociatedObject(self, @selector(offsetPoint)) CGPointValue];
    
}

- (void)setOffsetPoint:(CGPoint)offsetPoint{
    objc_setAssociatedObject(self, @selector(offsetPoint), @(offsetPoint), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)moveView {
    return objc_getAssociatedObject(self, @selector(moveView));
}

- (UICollectionViewCell *)moveCell {
    return objc_getAssociatedObject(self, @selector(moveCell));
}

- (NSIndexPath *)sourceIndexPath {
    return objc_getAssociatedObject(self, @selector(sourceIndexPath));
}

- (BOOL)rearrangementEnable {
    return [objc_getAssociatedObject(self, @selector(rearrangementEnable)) boolValue];
}

- (BOOL)moveTypeEnable {
    return [objc_getAssociatedObject(self, @selector(moveTypeEnable)) boolValue];
}

- (CGFloat)autoScrollSpeet {
    return [objc_getAssociatedObject(self, @selector(autoScrollSpeet)) doubleValue];
}

- (CGFloat)longPressMagnification {
    return [objc_getAssociatedObject(self, @selector(longPressMagnification)) doubleValue];
}

- (id<LXCollectionViewCellMoveSoreDelegate>)moveDelegate {
    return objc_getAssociatedObject(self, @selector(moveDelegate));
}

- (UILongPressGestureRecognizer *)rearrangeLong {
    return objc_getAssociatedObject(self, @selector(rearrangeLong));
}

- (AutoScrollDirection)autoScrollDirection {
    return [objc_getAssociatedObject(self, @selector(autoScrollDirection)) unsignedIntegerValue];
}

- (CADisplayLink *)displayLink {
    return objc_getAssociatedObject(self, @selector(displayLink));
}

- (void)setMoveView:(UIView *)moveView {
    objc_setAssociatedObject(self, @selector(moveView), moveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMoveCell:(UICollectionViewCell *)moveCell {
    objc_setAssociatedObject(self, @selector(moveCell), moveCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSourceIndexPath:(NSIndexPath *)sourceIndexPath {
    objc_setAssociatedObject(self, @selector(sourceIndexPath), sourceIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRearrangementEnable:(BOOL)rearrangementEnable {
    objc_setAssociatedObject(self, @selector(rearrangementEnable), @(rearrangementEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (rearrangementEnable) {
        [self setupMoveRearrangement];
    } else {
        [self removeGestureRecognizer:self.rearrangeLong];
    }
}

- (void)setMoveTypeEnable:(BOOL)moveTypeEnable{
    objc_setAssociatedObject(self, @selector(moveTypeEnable), @(moveTypeEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAutoScrollSpeet:(CGFloat)autoScrollSpeet {
    objc_setAssociatedObject(self, @selector(autoScrollSpeet), @(autoScrollSpeet), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLongPressMagnification:(CGFloat)longPressMagnification {
    objc_setAssociatedObject(self, @selector(longPressMagnification), @(longPressMagnification), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMoveDelegate:(id<LXCollectionViewCellMoveSoreDelegate>)moveDelegate {
    objc_setAssociatedObject(self, @selector(moveDelegate), moveDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setRearrangeLong:(UILongPressGestureRecognizer *)rearrangeLong {
    objc_setAssociatedObject(self, @selector(rearrangeLong), rearrangeLong, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAutoScrollDirection:(AutoScrollDirection)autoScrollDirection {
    objc_setAssociatedObject(self, @selector(autoScrollDirection), @(autoScrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDisplayLink:(CADisplayLink *)displayLink {
    objc_setAssociatedObject(self, @selector(displayLink), displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private methods

- (void)setupMoveRearrangement {
    if (!self.autoScrollSpeet) {
        self.autoScrollSpeet = 5;
    }
    
    if (!self.longPressMagnification) {
        self.longPressMagnification = 1.2;
    }
    
    self.rearrangeLong = [[UILongPressGestureRecognizer alloc]
                               initWithTarget:self action:@selector(longPressGestureAction:)];
    [self addGestureRecognizer:self.rearrangeLong];
}

- (UIView *)snapshotOfView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:image];
}

- (void)startDisplayLink {
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = displaylink;
}

- (void)stopDisplayLink {
    if (!self.displayLink) {
        return;
    }
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)autoScrollCollectionViewWithTouchMoveView:(UIView *)moveView {
    CGRect moveViewRectInSuperView = [moveView convertRect:moveView.bounds toView:self.superview];
    
    if (self.contentSize.height > self.frame.size.height) { // vertical scroll
        if (moveViewRectInSuperView.size.height > self.frame.size.height) {
            return;
        }
        
        if (moveViewRectInSuperView.origin.y + moveView.frame.size.height > self.frame.size.height) { // bottom
            if (self.autoScrollDirection == AutoScrollDirectionUp) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionUp;
            [self startDisplayLink];
            
            return;
            
        } else if (moveViewRectInSuperView.origin.y < 0) { // top
            
            if (self.autoScrollDirection == AutoScrollDirectionDown) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionDown;
            [self startDisplayLink];
            
            return;
        }
        
    } else if(self.contentSize.width > self.frame.size.width) { // horizontal scroll
        
        if (moveViewRectInSuperView.size.width > self.frame.size.width) {
            return;
        }
        
        if (moveViewRectInSuperView.origin.x + moveView.frame.size.width > self.frame.size.width) { // right
            
            if (self.autoScrollDirection == AutoScrollDirectionLeft) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionLeft;
            [self startDisplayLink];
            
            return;
            
        } else if (moveViewRectInSuperView.origin.x < 0) { // left
            
            if (self.autoScrollDirection == AutoScrollDirectionRight) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionRight;
            [self startDisplayLink];
            
            return;
        }
    }
    
    self.autoScrollDirection = AutoScrollDirectionNone;
    [self stopDisplayLink];
}

- (void)autoScrollUpdateWithDirection:(AutoScrollDirection)autoScrollDirection {
    CGPoint offset = self.contentOffset;
    CGRect moveViewRect = self.moveView.frame;
    
    switch (autoScrollDirection) {
        case AutoScrollDirectionNone: {
            [self stopDisplayLink];
            break;
        }
        case AutoScrollDirectionLeft: {
            CGFloat diff = self.contentOffset.x - (self.contentSize.width - self.frame.size.width);
            
            if(diff + self.autoScrollSpeet >= 0) {
                offset.x = self.contentSize.width - self.frame.size.width;
                self.contentOffset = offset;
                
                moveViewRect.origin.x += - diff;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.x += self.autoScrollSpeet;
            self.contentOffset = offset;
            
            moveViewRect.origin.x += self.autoScrollSpeet;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AutoScrollDirectionRight: {
            if (self.contentOffset.x - self.autoScrollSpeet <= 0) {
                offset.x = 0;
                self.contentOffset = offset;
                
                moveViewRect.origin.x -= self.contentOffset.x;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.x -= self.autoScrollSpeet;
            self.contentOffset = offset;
            
            moveViewRect.origin.x -= self.autoScrollSpeet;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AutoScrollDirectionUp: {
            CGFloat diff = self.contentOffset.y - (self.contentSize.height - self.frame.size.height);
            
            if (diff + self.autoScrollSpeet >= 0) {
                offset.y = self.contentSize.height - self.frame.size.height;
                self.contentOffset = offset;
                
                moveViewRect.origin.y += -diff;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.y += self.autoScrollSpeet;
            self.contentOffset = offset;
            
            moveViewRect.origin.y += self.autoScrollSpeet;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AutoScrollDirectionDown: {
            if (self.contentOffset.y - self.autoScrollSpeet <= 0) {
                offset.y = 0;
                self.contentOffset = offset;
                
                moveViewRect.origin.y -= self.contentOffset.y;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.y -= self.autoScrollSpeet;
            self.contentOffset = offset;
            
            moveViewRect.origin.y -= self.autoScrollSpeet;
            self.moveView.frame = moveViewRect;
            
            break;
        }
    }
    
    if (autoScrollDirection != AutoScrollDirectionNone) {
        NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:self.moveView.center];
        
        if (!targetIndexPath) {
            targetIndexPath = [self findIndexPathFailureHandleWithMoveView:self.moveView
                                                           scrollDirection:autoScrollDirection];
        }
        
        if (targetIndexPath) {
            [self longPressChangeWithTargetPath:targetIndexPath pressPoint:self.moveView.center];
        }
    }
}

- (NSIndexPath *)findIndexPathFailureHandleWithMoveView:(UIView *)moveView
                                        scrollDirection:(AutoScrollDirection)autoScrollDirection {
    NSIndexPath *indexPath = nil;
    
    switch (autoScrollDirection) {
        case AutoScrollDirectionRight: {
            CGPoint firstPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionLeft: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionDown: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMaxY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionUp: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMinY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionNone: {
            break;
        }
            
    }
    
    return indexPath;
}

#pragma mark - Event Response

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint pressPoint = [longPress locationInView:longPress.view];
    NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:pressPoint];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self longPressBeginWithTargetPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self longPressChangeWithTargetPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
        default: {
            [self longPressEndWithTargetPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
    }
}

- (void)longPressBeginWithTargetPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint {
    if (!targetIndexPath) {
        return;
    }
    
    self.sourceIndexPath = targetIndexPath;
    self.moveCell = [self cellForItemAtIndexPath:self.sourceIndexPath];
    
    if ([self.moveDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.moveDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
    }
    
    self.moveView = [self snapshotOfView:self.moveCell];
    self.moveView.frame = self.moveCell.frame;
    
    self.moveView.layer.shadowColor = HexRGB(0xeeeeee).CGColor;
    self.moveView.layer.shadowOffset = CGSizeMake(0, 0);
    self.moveView.layer.shadowOpacity = 0.5;
    self.moveView.layer.shadowRadius = 6;
    [self addSubview:self.moveView];
    
    self.moveCell.hidden = YES;
    [self bringSubviewToFront:self.moveView];
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.transform = CGAffineTransformMakeScale(self.longPressMagnification, self.longPressMagnification);
        self.offsetPoint = CGPointMake(pressPoint.x - self.moveView.center.x, pressPoint.y - self.moveView.center.y);
    }];
}

- (void)longPressChangeWithTargetPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint{
    if (self.moveView) {
        self.moveView.center = CGPointMake(pressPoint.x -self.offsetPoint.x, pressPoint.y - self.offsetPoint.y);
        [self autoScrollCollectionViewWithTouchMoveView:self.moveView];
    }
    if (!self.sourceIndexPath || !targetIndexPath || [targetIndexPath isEqual:self.sourceIndexPath]) {
        return;
    }
    
    if ([self.moveDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.moveDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
        if (![self.moveDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:targetIndexPath]) {
            return;
        }
    }
    
    if ([self.moveDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:fromIndexPath:toIndexPath:)]) {
        if (![self.moveDelegate collectionView:self shouldMoveCell:self.moveCell fromIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath]) {
            return;
        }
    }
    
    [self moveItemAtIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath];
    
    
    if ([self.moveDelegate respondsToSelector:@selector(collectionView:didMoveCell:fromIndexPath:toIndexPath:)]) {
        [self.moveDelegate collectionView:self didMoveCell:self.moveCell fromIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath];
    }
    
    self.sourceIndexPath = targetIndexPath;
}

- (void)longPressEndWithTargetPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint{
    if (!self.sourceIndexPath) {
        return;
    }
    
    if ([self.moveDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.moveDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
    }
    
    if ([self.moveDelegate respondsToSelector:@selector(collectionView:putDownCell:atIndexPath:)]) {
        [self.moveDelegate collectionView:self putDownCell:self.moveCell atIndexPath:self.sourceIndexPath];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.center = self.moveCell.center;
        self.moveView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.moveCell.hidden = NO;
        [self.moveView removeFromSuperview];
        self.moveView = nil;
        self.moveCell = nil;
        self.sourceIndexPath = nil;
        [self autoScrollCollectionViewWithTouchMoveView:self.moveView];
    }];
}

- (void)displayLinkUpdate {
    [self autoScrollUpdateWithDirection:self.autoScrollDirection];
}

@end
