//
//  TAssistantsAddMyParseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/30.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAssistantsAddMyParesBlock)( );
@interface TAssistantsAddMyParseCell : UITableViewCell
@property(nonatomic, copy) TAssistantsAddMyParesBlock addBlock;
@end
