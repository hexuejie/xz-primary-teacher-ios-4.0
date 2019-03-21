//
//  WriteMessageRecipientCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^WriteMessageAddRecipinetBlock)();
@interface WriteMessageRecipientCell : UITableViewCell
@property(nonatomic, copy) WriteMessageAddRecipinetBlock addRecipinetBlock;
- (void)setupContent:(NSString *)content;
@end
