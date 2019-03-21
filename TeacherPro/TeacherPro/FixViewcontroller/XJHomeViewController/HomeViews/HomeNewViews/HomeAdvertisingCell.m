

//
//  HomeAdvertisingCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeAdvertisingCell.h"
#import "PublicDocuments.h"
#import "SDCycleScrollView.h"
#import "HomeListModel.h"
#import "UIView+add.h"

@interface HomeAdvertisingCell()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
@implementation HomeAdvertisingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.delegate = self;
    self.bannerView.titlesGroup = nil;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    self.bannerView.placeholderImage = [UIImage imageNamed:@"banner.png"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bannerView.backgroundColor = [UIColor whiteColor];
        [self.segmentView setCornerRadius:8 withShadow:YES withOpacity:10 withAlpha:0.06 withCGSize:CGSizeMake(0, 0)];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)checkAction:(id)sender {
    if (self.touckBlock) {
        self.touckBlock(TouchType_check);
    }
}

- (IBAction)releaseAction:(id)sender {
    if (self.touckBlock) {
        self.touckBlock(TouchType_release);
    }
}

- (IBAction)huiguClick:(id)sender {
    if (self.touckBlock) {
        self.touckBlock(TouchType_huigu);
    }
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

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.advertisingBlock) {
        self.advertisingBlock(index);
    }
}
@end
