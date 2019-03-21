//
//  NewReportPictureProblemHeader.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/16.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewReportPictureProblemHeader.h"

@implementation NewReportPictureProblemHeader

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame: frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _circleView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth, 80)];
    _circleView.backgroundColor = [UIColor clearColor];
    [self addSubview:_circleView];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 99, kScreenWidth, 1)];
    viewLine.backgroundColor = HexRGB(0xF5F5F5);
    [self addSubview:viewLine];
}

- (void)configUI:(NSIndexPath *)indexPath {
    [self customLayoutSubView:_chartView1 index:0 current:60];
    [self customLayoutSubView:_chartView2 index:1 current:100];
    [self customLayoutSubView:_chartView3 index:2 current:0];
}

- (void)customLayoutSubView:(SCCircleChart *)circle index:(NSInteger)index current:(NSInteger)current{
    if (circle) {
        [circle removeFromSuperview];
        circle = nil;
    }//15   105
    circle = [[SCCircleChart alloc] initWithFrame:CGRectMake((46+38)*index, 0, 46, 46)
                                            total:@100
                                          current:[NSNumber numberWithInteger:current]
                                        clockwise:YES];
    [circle setStrokeColor:HexRGB(0x3DAEFF)];
    circle.duration = 0.01;
    circle.chartType = SCChartFormatTypeNone;
    circle.format = @"%d%%\n正确率";
    [circle strokeChart];
    [_circleView addSubview:circle];
    if (index == 0) {
        _chartView1 = circle;
        _titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake((46+38)*index, 48, 46, 20)];
        _titleLabel1.textColor = HexRGB(0x8A8F99);
        _titleLabel1.font = [UIFont systemFontOfSize:12];
        _titleLabel1.textAlignment = NSTextAlignmentCenter;
        _titleLabel1.text = @"1";
        [_circleView addSubview:_titleLabel1];
    }else if (index == 1) {
        _chartView2 = circle;
        _titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake((46+38)*index, 48, 46, 20)];
        _titleLabel2.textColor = HexRGB(0x8A8F99);
        _titleLabel2.font = [UIFont systemFontOfSize:12];
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.text = @"2";
        [_circleView addSubview:_titleLabel2];
    }else if (index == 2) {
        _chartView3 = circle;
        _titleLabel3 = [[UILabel alloc]initWithFrame:CGRectMake((46+38)*index, 48, 46, 20)];
        _titleLabel3.textColor = HexRGB(0x8A8F99);
        _titleLabel3.font = [UIFont systemFontOfSize:12];
        _titleLabel3.textAlignment = NSTextAlignmentCenter;
        [_circleView addSubview:_titleLabel3];
        
        _titleLabel3.text = @"1";
    }
}

- (void)setCurrnetSelected:(NSInteger)currnetSelected{
    _currnetSelected = currnetSelected;
    CGFloat orX = 0;
    if (_currnetSelected == 0) {
        orX = _chartView1.frame.origin.x+13;
    }else if (_currnetSelected == 1) {
        orX = _chartView2.frame.origin.x+13;
    }else if (_currnetSelected == 2) {
        orX = _chartView3.frame.origin.x+13;
    }
    CGRect frame = CGRectMake(orX, 77, 19, 3);//100
    
    _titleLabel1.textColor = HexRGB(0x8A8F99);
    _titleLabel2.textColor = HexRGB(0x8A8F99);
    _titleLabel3.textColor = HexRGB(0x8A8F99);
    if (!self.tagView) {
        self.tagView = [[UIView alloc]initWithFrame:frame];
        self.tagView.backgroundColor = HexRGB(0x3DAEFF);
        self.tagView.layer.masksToBounds = YES;
        self.tagView.layer.cornerRadius = 1.5;
        [_circleView addSubview:self.tagView];
        self.currnetSelected = currnetSelected;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.tagView.frame = frame;
            if (_currnetSelected == 0) {
                _titleLabel1.textColor = HexThemColor;
            }else if (_currnetSelected == 1) {
               _titleLabel2.textColor = HexThemColor;
            }else if (_currnetSelected == 2) {
              _titleLabel3.textColor = HexThemColor;
            }
        }];
    }
}

@end
