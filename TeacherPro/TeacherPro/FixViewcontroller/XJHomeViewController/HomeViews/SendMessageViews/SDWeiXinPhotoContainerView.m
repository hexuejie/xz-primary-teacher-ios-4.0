//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDWeiXinPhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
@interface SDWeiXinPhotoContainerView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation SDWeiXinPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
      
    }
    
    self.imageViewsArray = [temp copy];
}

- (void)layerSubviewImg{
    if (self.isShowBorder) {
        for (UIView * view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                 [self setupImgBorder: (UIImageView*)view];
            }
            
        } 
    }
}
//设置图片边框
- (void)setupImgBorder:(UIImageView *)imgV{
    imgV.layer.borderColor = project_main_blue.CGColor;
    imgV.layer.borderWidth = 1;
    imgV.layer.cornerRadius = 8;
    
}
- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
     CGFloat  __block itemH = 0;
    if (_picPathStringsArray.count == 1) {
        

        UIImageView *imageView = [_imageViewsArray objectAtIndex:0];
        imageView.hidden = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_picPathStringsArray.firstObject] placeholderImage:[UIImage imageNamed:@"message_image_icon"] options:SDWebImageRefreshCached   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            

        }];
          itemH = itemW;
         imageView.frame = CGRectMake(0,0, itemW, itemH);
        
    } else {
        itemH = itemW;
    }
    
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5 * 1.5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < [_imageViewsArray count]) {
            long columnIndex = idx % perRowItemCount;
            long rowIndex = idx / perRowItemCount;
            UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
            imageView.hidden = NO;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"message_image_icon"]];
            imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;

        }
        
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
 
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

- (void)setPicGeneralPathStringsArray:(NSArray *)picGeneralPathStringsArray
{
    _picGeneralPathStringsArray = picGeneralPathStringsArray;
    
    for (long i = _picGeneralPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picGeneralPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    
    CGFloat itemW = (kScreenWidth-30-32)/4;
    CGFloat  __block itemH = 0;
    if (_picGeneralPathStringsArray.count == 1) {
        
        
        UIImageView *imageView = [_imageViewsArray objectAtIndex:0];
        imageView.hidden = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_picGeneralPathStringsArray.firstObject] placeholderImage:[UIImage imageNamed:@"message_image_icon"] options:SDWebImageRefreshCached   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            
        }];
        itemH = itemW;
        imageView.frame = CGRectMake(0,0, itemW, itemH);
        
    } else {
        itemH = itemW;
    }
    
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picGeneralPathStringsArray];
    CGFloat margin = 12;
    
    [_picGeneralPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < [_imageViewsArray count]) {
//            long columnIndex = idx % perRowItemCount;
//            long rowIndex = idx / perRowItemCount;
            UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
            imageView.hidden = NO;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"message_image_icon"]];
            imageView.frame = CGRectMake(idx * (itemW + margin) +16, 10, itemW, itemH);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 2.0;
            
            if (idx > 3) {
                imageView.hidden = YES;
            }else{
                imageView.hidden = NO;
                if (idx == 3 && [_picGeneralPathStringsArray count]>4) {
                    UILabel *labelBottom = [[UILabel alloc]initWithFrame:imageView.bounds];
                    labelBottom.text = [NSString stringWithFormat:@"+%ld",_picGeneralPathStringsArray.count-4];
                    labelBottom.textColor = [UIColor whiteColor];
                    labelBottom.textAlignment = NSTextAlignmentCenter;
                    labelBottom.font = [UIFont systemFontOfSize:22];
                    [imageView addSubview:labelBottom];
                    labelBottom.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
//                    labelBottom.alpha = 0.15;
                    labelBottom.userInteractionEnabled = NO;
                }
            }
        }
        
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picGeneralPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(kScreenWidth);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picPathStringsArray.count;
    if (browser.imageCount == 0) {
        browser.imageCount = self.picGeneralPathStringsArray.count;
    }
    browser.delegate = self;
    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 3) {
        return array.count;
    } else if (array.count <= 4) {
        if (self.otherType) {
            return 3;
        }else
          return 2;
    } else {
        return 3;
    }
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName;
    if (self.picPathStringsArray.count == 0) {
        imageName = self.picGeneralPathStringsArray[index];
    }else{
        imageName = self.picPathStringsArray[index];
    }
//    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    NSURL * url = [NSURL URLWithString:imageName];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    
    return imageView.image;
}

@end
