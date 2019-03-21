
//
//  BookPreviewDetailTypeCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookPreviewDetailTypeCell.h"
#import "PublicDocuments.h"
#import "BookPreviewModel.h"

@interface BookPreviewDetailTypeCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation BookPreviewDetailTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
}

-(void)setupDetailType:(PracticeTypeModel *)model withImgDic:(NSDictionary *)imgDic{

    self.titleLabel.text = model.practiceTypeDes;
    [self.iconImgV setImage:[UIImage imageNamed:imgDic[model.practiceType]]];
    self.detailLabel.text = model.practiceIntro;
}
@end
