//
//  NewReportListonTableViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/11.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewReportListonTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel3;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel4;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceMidWidth;


@end

NS_ASSUME_NONNULL_END
