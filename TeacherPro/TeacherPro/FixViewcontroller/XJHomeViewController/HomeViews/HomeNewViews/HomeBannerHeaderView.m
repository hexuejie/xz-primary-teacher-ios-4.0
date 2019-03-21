
//
//  HomeBannerHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeBannerHeaderView.h"
#import "PublicDocuments.h"
#import "SDCycleScrollView.h"
#import "HomeListModel.h"

@interface HomeBannerHeaderView()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@end
@implementation HomeBannerHeaderView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.delegate = self;
    self.bannerView.titlesGroup = nil;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    self.bannerView.placeholderImage = [UIImage imageNamed:@"banner.png"];
    
}
- (void)setupHomeAdModel:(HomeListModel *)model{
    if (model.sysAdverts) {
        NSMutableArray *imagesURLStrings = [NSMutableArray array];
        for (HomeSysAdvertsModel * tempModel in model.sysAdverts) {
            [imagesURLStrings addObject:tempModel.adUrl];
        }
        self.bannerView.imageURLStringsGroup = imagesURLStrings;
    }
}
 
@end
