//
//  NewRewardFooterReusableView.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewRewardFooterReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *decreatButton;

@property (strong, nonatomic) NSString *countStr;
@property (assign, nonatomic) BOOL isreward;
@end

NS_ASSUME_NONNULL_END
