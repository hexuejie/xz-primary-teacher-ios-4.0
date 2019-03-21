//
//  LXAttributedURLModel.m
//  lexiwed2
//
//  Created by Kyle on 2017/4/19.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "LXAttributedURLModel.h"



@implementation LXAttributedURLModel

+(instancetype)modelWith:(NSString *)linkString rang:(NSRange)range{

    LXAttributedURLModel *model = [[LXAttributedURLModel alloc] init];
    model.linkData = linkString;
    model.range = range;
    return model;
}


@end


@implementation LXLinkContentModel




@end
