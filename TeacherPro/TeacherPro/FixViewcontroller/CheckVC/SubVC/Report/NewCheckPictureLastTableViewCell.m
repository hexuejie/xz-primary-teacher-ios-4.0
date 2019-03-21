//
//  NewCheckPictureLastTableViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewCheckPictureLastTableViewCell.h"
#import "UIView+add.h"


@interface NewCheckPictureLastTableViewCell ()
{
    NSDictionary *tempCartoonPracticesDic1;
    NSDictionary *tempCartoonPracticesDic2;
    NSDictionary *tempCartoonPracticesDic3;
}
@end

@implementation NewCheckPictureLastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.backgroundbottom setCornerRadius:6 withShadow:YES withOpacity:1.2];
    self.circleView.userInteractionEnabled = YES;
}



- (void)configUI:(NSIndexPath *)indexPath {
    NSDictionary *lastTempdic = [self.dataArray lastObject];
    
    for (int i = 0; i<[lastTempdic[@"cartoonPractices"]  count]; i++) {
        NSDictionary *tempCartoonPracticesDic = lastTempdic[@"cartoonPractices"][i];
        if (i == 0) {
            
            tempCartoonPracticesDic1 = tempCartoonPracticesDic;
            [self customLayoutSubView:_chartView1 index:0 current:[[tempCartoonPracticesDic[@"correctRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""]    integerValue]];
        }else if (i == 1) {
            
            tempCartoonPracticesDic2 = tempCartoonPracticesDic;
            [self customLayoutSubView:_chartView2 index:1 current:[[tempCartoonPracticesDic[@"correctRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""]    integerValue]];
        }else if (i == 2) {
            
            tempCartoonPracticesDic3 = tempCartoonPracticesDic;
            [self customLayoutSubView:_chartView3 index:2 current:[[tempCartoonPracticesDic[@"correctRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""]    integerValue]];
        }
    }
    
    
    if (self.dataArray.count >= 1) {
        NSDictionary *tempdic = [self.dataArray firstObject];
        if ([@"hbpy"isEqualToString:tempdic[@"typeId"]]) {//只有z上部分
            
            [self.rangButton setTitle:tempdic[@"scoreLevel"] forState:UIControlStateNormal];
            if (self.dataArray.count == 1) {
                self.secondBottom.hidden = YES;
            }
            
        }else{//只有下部分
            if (self.dataArray.count == 1) {
                self.secondTop.constant = 0;
            }
        }
    }
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
    [self.circleView addSubview:circle];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
