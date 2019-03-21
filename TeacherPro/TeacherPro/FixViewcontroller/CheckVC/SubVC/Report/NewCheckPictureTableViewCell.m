//
//  NewCheckPictureTableViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewCheckPictureTableViewCell.h"
#import "UIView+add.h"
#import "SCChart.h"

@interface NewCheckPictureTableViewCell()
{
    SCPieChart *chartView;
    
    NSString *chartView1;
    NSString *chartView2;
    NSString *chartView3;
    NSString *chartView4;
}
@end

@implementation NewCheckPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //19宽的圆环
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.backgroundBottom setCornerRadius:6 withShadow:YES withOpacity:10];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    if (dataDic ==nil) {
        return;
    }
    _dataDic = dataDic;
    
    self.nameLabel.text = _dataDic[@"title"];
    [self.rankButton setTitle:_dataDic[@"scoreLevel"] forState:UIControlStateNormal];
    
    for (int i = 0; i<[_dataDic[@"masteLevels"] count]; i++) {
        NSDictionary *tempDic = _dataDic[@"masteLevels"][i];
        if (i == 0) {
            
            chartView1 = tempDic[@"studentCount"];
            self.prefectLabel.text = [NSString stringWithFormat:@"%@：%@人",tempDic[@"levelName"],tempDic[@"studentCount"]];
        }else if (i == 1) {
            
            chartView2 = tempDic[@"studentCount"];
            self.basicLabel.text = [NSString stringWithFormat:@"%@：%@人",tempDic[@"levelName"],tempDic[@"studentCount"]];
        }else if (i == 2) {
            
            chartView3 = tempDic[@"studentCount"];
            self.needLabel.text = [NSString stringWithFormat:@"%@：%@人",tempDic[@"levelName"],tempDic[@"studentCount"]];
        }else if (i == 3) {
            
            chartView4 = tempDic[@"studentCount"];
            self.nonLabel.text = [NSString stringWithFormat:@"%@：%@人",tempDic[@"levelName"],tempDic[@"studentCount"]];
        }
    }
}

- (void)configUI:(NSIndexPath *)indexPath {
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    NSArray *items = @[[SCPieChartDataItem dataItemWithValue:[chartView1 floatValue] color:HexRGB(0x33AAFF) description:@"A"],
                       [SCPieChartDataItem dataItemWithValue:[chartView2 floatValue] color:HexRGB(0xFFC35C) description:@"B"],
                       [SCPieChartDataItem dataItemWithValue:[chartView3 floatValue] color:HexRGB(0x36CBCB) description:@"C"],
                       [SCPieChartDataItem dataItemWithValue:[chartView4 floatValue] color:HexRGB(0xCFE4FF) description:@"D"],
                       ];
    
    chartView = [[SCPieChart alloc] initWithFrame:self.circleView.bounds items:items];
    chartView.descriptionTextColor = [UIColor clearColor];
    chartView.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:10];
    [chartView strokeChart];
    chartView.userInteractionEnabled = NO;
    [self.circleView addSubview:chartView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
