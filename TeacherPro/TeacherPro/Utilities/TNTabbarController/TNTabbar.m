//
//  TNTabbar.m
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import "TNTabbar.h"
#import "TNTabbarItem.h"
#import "CommonConfig.h"
@interface TNTabbar ()
@property (nonatomic) CGFloat itemWidth;

@property (nonatomic) UIView *tabbarBgView;
@end
@implementation TNTabbar


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    _tabbarBgView = [[UIView alloc] init];
    
    [self addSubview:_tabbarBgView];

}


-(void)layoutSubviews{

    CGSize frameSize = self.frame.size;
//    self.tabbarBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frameSize.width, frameSize.height)];
//    [self addSubview:self.tabbarBgView];
    NSInteger index  = 0;

    self.itemWidth=round(frameSize.width/self.items.count);
    for(TNTabbarItem *item in self.items){
        [item setFrame:CGRectMake(index*self.itemWidth, 0, self.itemWidth, frameSize.height)];
        item.backgroundColor=[UIColor whiteColor];
        [item setNeedsDisplay];
        index++;
    }
    
    //update tag

    self.layer.borderColor=tn_border_color.CGColor;
    self.layer.borderWidth=0.5f;
}

#pragma mark eventmethod
-(void)tabbarItemSelected:(TNTabbarItem *)item{
    
    if([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]){
        NSInteger index=[self.items indexOfObject:item];
        if(![[self delegate]tabBar:self shouldSelectItemAtIndex:index]){
            return;
        }
    }
    [self setSelectedItem:item];
    
    if([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]){
        NSInteger index=[self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
    
}

#pragma mark configmethod

-(void)setItemWidth:(CGFloat)itemWidth{
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    
    for(TNTabbarItem * item in items){
        [item removeFromSuperview];
    }
    _items = items.copy;
    for(TNTabbarItem * item in items){
        [item addTarget:self action:@selector(tabbarItemSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)setSelectedItem:(TNTabbarItem *)selectedItem {
    if(_selectedItem==selectedItem){
        return;
    }
    [_selectedItem setSelected:NO];
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

- (void)setTabbarBgView:(UIView *)tabbarBgView {
    _tabbarBgView = tabbarBgView;
}

- (void)setTabbarHeight:(CGFloat)tabbarHeight {
    _tabbarHeight = tabbarHeight;
}



@end
