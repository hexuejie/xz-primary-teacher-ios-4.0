

//
//  RepostioryBannerHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "RepositoryBannerHeaderView.h"
#import "SDCycleScrollView.h"
#import "ProUtils.h"
#import "PublicDocuments.h"

@interface RepositoryBannerHeaderView()<SDCycleScrollViewDelegate>
@property(nonatomic, weak) IBOutlet SDCycleScrollView * bannerView;
@property(nonatomic, weak) IBOutlet UIButton * bookBtn;
@property(nonatomic, weak) IBOutlet UIButton * cartoonBtn;
@property (weak, nonatomic) IBOutlet UIButton *assistantsBtn;

@end


@implementation RepositoryBannerHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.bookBtn.titleLabel.font = fontSize_13;
    //    [self.bookBtn  setBackgroundImage:[ProUtils getResizableImage:[UIImage imageNamed:@"book_btn_bg"] withEdgeInset:UIEdgeInsetsMake(20,40, 0, 40)] forState:UIControlStateNormal];
    //     [self.cartoonBtn  setBackgroundImage:[ProUtils getResizableImage:[UIImage imageNamed:@"cartoon_btn_icon"] withEdgeInset:UIEdgeInsetsMake(0,10, 0, -10)] forState:UIControlStateNormal];
    //     [self.assistantsBtn  setBackgroundImage:[ProUtils getResizableImage:[UIImage imageNamed:@"assistants_btn_bg"] withEdgeInset:UIEdgeInsetsMake(20, 0, 0, 40)] forState:UIControlStateNormal];
    self.bookBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.cartoonBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.assistantsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
}


- (void)setupBanner{
    
    //    NSArray *imagesURLStrings = @[
    //                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
    //                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
    //                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
    //                                  ];
    
    
    NSArray *imagesName = @[@"bookhomework_banner.png"];
    self.bannerView.localizationImageNamesGroup = imagesName;
    //    self.bannerView.imageURLStringsGroup = imagesURLStrings;
    self.bannerView.titlesGroup = nil;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.delegate = self;
    self.bannerView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    self.bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}
- (IBAction)bookAction:(id)sender {
    if (self.bottomBlock) {
        self.bottomBlock(RepositoryBannerHeaderViewBottomType_book);
    }
}

- (IBAction)cartoonAction:(id)sender {
    if (self.bottomBlock) {
        self.bottomBlock(RepositoryBannerHeaderViewBottomType_cartoon);
    }
}
- (IBAction)assistantsAction:(id)sender {
    
    if(self.bottomBlock){
        self.bottomBlock(RepositoryBannerHeaderViewBottomType_assistants);
    }
}



@end
