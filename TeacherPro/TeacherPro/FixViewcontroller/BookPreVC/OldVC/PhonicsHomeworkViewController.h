//
//  PhonicsHomeworkViewController.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/7.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "ReleaseAddBookworkCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhonicsHomeworkViewController : BaseCollectionViewController

@property (nonatomic, strong) ReleaseAddBookworkCell * bottomView;
- (instancetype)initWithBookId:(NSString *)bookId;
@end

NS_ASSUME_NONNULL_END
