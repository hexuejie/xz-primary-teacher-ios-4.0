//
//  TeachingAssistantsDetailCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsDetailCell.h"
#import "UIView+Layout.h"
#import "AssistantsDetailModel.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"


@implementation WireframeView

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self confightView];
    }
    return self;
}

- (void)confightView{
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    
}
- (void)setupViewStatus:(BOOL)status{
    UIColor * borderColor = nil;
    UIColor * bgColor = nil;
    if (status) {
        borderColor = UIColorFromRGB(0xf9be8f);
        bgColor = UIColorFromRGB(0xfce8d8);
    }else{
        borderColor = UIColorFromRGB(0x00b8ef);
        bgColor  = [UIColor clearColor];
    }
    self.layer.borderColor = borderColor.CGColor;
    self.backgroundColor = bgColor;
}

@end



@implementation TeachingAssistantsDetailCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    self.backgroundColor = [UIColor clearColor];
    self.previewView = [[PhotoPreviewView alloc] initWithFrame:self.bounds];
    __weak typeof(self) weakSelf = self;
   
   
    [self.previewView setSingleTapGestureBlock:^(NSString * unitId, NSString *questionNum){
        if (weakSelf.singleTapGestureBlock) {
            weakSelf.singleTapGestureBlock(unitId, questionNum,weakSelf.indexPath);
        }
    }];
    [self.previewView setImageProgressUpdateBlock:^(double progress) {
        if (weakSelf.imageProgressUpdateBlock) {
            weakSelf.imageProgressUpdateBlock(progress);
        }
    }];
    [self.previewView setSingleYWDDTapGestureBlock:^(NSString *unitId, NSString *readId) {
        if (weakSelf.singleYWDDTapGestureBlock) {
            weakSelf.singleYWDDTapGestureBlock(unitId, readId,weakSelf.indexPath);
        }
    }];
    [self addSubview:self.previewView];
}


- (void)setupModel:(AssistantsDetailModel *)model withSelectedData:(NSArray *)selectedArray{
     _previewView.tag = self.indexPath.item;
    _previewView.currentPage = self.currentPage;
    [_previewView setupModel:model atIndexPath:self.indexPath withSelectedData:selectedArray];
}
- (void)setupChangeSeleted:(BOOL)changeSeleted{
    self.previewView.isChangeSeleted = changeSeleted;
}
- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}

- (void)setCropRect:(CGRect)cropRect {
    _cropRect = cropRect;
    _previewView.cropRect = cropRect;
}

@end

@interface PhotoPreviewView ()<UIScrollViewDelegate>

@end

@implementation PhotoPreviewView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
   
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageContainerView];
        [self.imageContainerView addSubview:self.imageView];
  
        
        
//        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//        tap2.numberOfTapsRequired = 2;
//
//        //如果双击确定偵測失败才會触发单击
//        [tap1 requireGestureRecognizerToFail:tap2];
//        [self addGestureRecognizer:tap2];
        
        [self configProgressView];
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
    }
    return _scrollView;
}

- (UIView *)imageContainerView{
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
         _imageContainerView.userInteractionEnabled =YES;
    }
    return _imageContainerView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled =YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
  
    return _imageView;
}
- (void)configProgressView {
 
}

- (void)setupModel:(AssistantsDetailModel *)model atIndexPath:(NSIndexPath *)indexPath withSelectedData:(NSArray *)selectedArray{
    AssistantsPagesModel * pageModel = model.pages[indexPath.item];
    [self.imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:pageModel.img] placeholderImage:[UIImage imageNamed:@""]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self resizeSubviews];
        [self drawWireframeModel:model withSelectedArray:selectedArray];
    } ];
    
    
}

- (void)drawWireframeModel:(AssistantsDetailModel *)model withSelectedArray:(NSArray *)selectedArray{
    
     CGFloat scale = 2.6;
   
    if (model.questions) {
    
        if (iPhone4) {
            scale = 3;
        }  if (iPhone5) {
            scale = 3;
        }else if (iPhone6){
            scale = 2.55;
        }else if(iPhone6Plus){
            scale = 2.3;
        }else{
            scale = 2.55;
        }
        [self setupTeachingAssistantsModel:model withScale:scale withSelectedArray:selectedArray];
    }else if (model.reads){
        if(iPhone4){
            scale = 2;
        } else if (iPhone5) {
            scale = 2;
        }else if (iPhone6){
            scale = 1.7;
        }else if(iPhone6Plus){
            scale = 1.55;
        }else{
            scale = 1.7;
        }
        [self setupYWDDModel:model withScale:scale withSelectedArray:selectedArray];
        
    }
    
}
//教辅
- (void)setupTeachingAssistantsModel:(AssistantsDetailModel *)model withScale:(CGFloat )scale  withSelectedArray:(NSArray *)selectedArray{
    
    for ( AssistantsQuestionsModel * questionsModel in model.questions) {
        //确保是当前页 和过滤小题
        if (([questionsModel.page intValue]  != self.currentPage  )|| [questionsModel.questionNum containsString:@"."] ) {
            continue ;
        }
        
        CGFloat x = [questionsModel.coord[0] floatValue] /scale;
        CGFloat y = [questionsModel.coord[1] floatValue] /scale;
        CGFloat width =  [questionsModel.coord[2] floatValue] /scale - x;
        CGFloat height =  [questionsModel.coord[3] floatValue] /scale- y;
        CGRect frame = CGRectMake(x,y,width, height);
        
        WireframeView * wireframeView = nil;
        
        if (![self.imageView viewWithTag:[questionsModel.questionNum  integerValue]] ) {
            wireframeView = [[WireframeView alloc]initWithFrame:frame];
            
            wireframeView.alpha = 0.5;
            wireframeView.unitId = questionsModel.unitId;
            wireframeView.questionNum = questionsModel.questionNum;
            wireframeView.tag = [questionsModel.questionNum  integerValue];
            wireframeView.page = questionsModel.page;
            [self.imageView addSubview:wireframeView];
        }else{
            wireframeView =[self.imageView viewWithTag:[questionsModel.questionNum  integerValue]];
        }
        
        if ( [self isVerifyData:selectedArray[self.tag ] Checked:questionsModel.questionNum]) {
            [wireframeView setupViewStatus:YES];
        }else{
            [wireframeView setupViewStatus:NO];
        }
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tap1.numberOfTapsRequired = 1;
        [wireframeView addGestureRecognizer:tap1];
    
    }
    
    
}

//语文点读
- (void)setupYWDDModel:(AssistantsDetailModel *)model withScale:(CGFloat )scale  withSelectedArray:(NSArray *)selectedArray{
    [self.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
 
  
    
    for ( YWDDQuestionsModel * questionsModel in model.reads) {
        //确保是当前页 和过滤小题
        if (([questionsModel.page intValue]  != self.currentPage  )  ) {
            continue ;
        }
        
        CGFloat x = [questionsModel.coord[0] floatValue] /scale;
        CGFloat orangeX = [questionsModel.coord[0] floatValue] /scale;
        CGFloat orangeY = (self.imageView.image.size.height-[questionsModel.coord[3] floatValue]) /scale;
        CGFloat y = ( [questionsModel.coord[1] floatValue]) /scale;
        CGFloat width =  [questionsModel.coord[2] floatValue] /scale - x;
        CGFloat height =  [questionsModel.coord[3] floatValue] /scale- y;
        CGRect frame = CGRectMake(orangeX,orangeY,width, height);
        
 
       __block WireframeView * wireframeView = nil;
  
        if (!wireframeView) {
            wireframeView = [[WireframeView alloc]initWithFrame:frame];
            
            wireframeView.alpha = 0.5;
            wireframeView.unitId = questionsModel.unitId;
            wireframeView.id = questionsModel.id;
 
            wireframeView.page = questionsModel.page;
            [self.imageView addSubview:wireframeView];
        }
        
        if ( [self isVerifyData:selectedArray[self.tag ] withCheckedReadId:questionsModel.id]) {
            [wireframeView setupViewStatus:YES];
        }else{
            [wireframeView setupViewStatus:NO];
        }
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleYWTap:)];
        tap1.numberOfTapsRequired = 1;
        [wireframeView addGestureRecognizer:tap1];
        
    }
    
    
}
- (BOOL)isVerifyData:(NSArray *)selectedArray Checked:(NSString *)questionsNumber{
    BOOL  checked = NO;
    if (selectedArray &&selectedArray.count >0) {
        checked = [selectedArray containsObject:questionsNumber];
    }
    return checked;
}
- (BOOL)isVerifyData:(NSArray *)selectedArray withCheckedReadId:(NSString *)readId{
    BOOL  checked = NO;
    if (selectedArray &&selectedArray.count >0) {
        checked = [selectedArray containsObject:readId];
    }
    return checked;
}

- (void)recoverSubviews {
    [self.scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.tz_origin = CGPointZero;
    _imageContainerView.tz_width = self.scrollView.tz_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.tz_height / self.scrollView.tz_width) {
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.scrollView.tz_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (_imageContainerView.tz_height > self.tz_height && _imageContainerView.tz_height - self.tz_height <= 1) {
        _imageContainerView.tz_height = self.tz_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.tz_height, self.tz_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.tz_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= self.tz_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
    [self refreshScrollViewContentSize];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _scrollView.maximumZoomScale = allowCrop ? 4.0 : 2.5;
}

- (void)refreshScrollViewContentSize {
    if (_allowCrop) {
        // 1.7.2 如果允许裁剪,需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
        // 1.让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.frame.size.width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.frame.size.height, self.frame.size.height) - self.cropRect.size.height) / 2;
        CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.frame.size.height) + contentHeightAdd;
        _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
        _scrollView.alwaysBounceVertical = YES;
        // 2.让scrollView新增滑动区域（裁剪框左上角的图片部分）
        if (contentHeightAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
 
    WireframeView * wireframeView = (WireframeView *)tap.view;
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock(wireframeView.unitId, wireframeView.questionNum);
        
        [wireframeView setupViewStatus:YES];
    }
}

- (void)singleYWTap:(UITapGestureRecognizer *)tap {
    
    WireframeView * wireframeView = (WireframeView *)tap.view;
    if (self.singleYWDDTapGestureBlock) {
        self.singleYWDDTapGestureBlock(wireframeView.unitId, wireframeView.id);
        if (self.isChangeSeleted) {
           [wireframeView setupViewStatus:YES];
        }
    }
}
#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.frame.size.width > _scrollView.contentSize.width) ? ((_scrollView.frame.size.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.frame.size.height > _scrollView.contentSize.height) ? ((_scrollView.frame.size.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end



