//
//  LXAttributedURLModel.h
//  lexiwed2
//
//  Created by Kyle on 2017/4/19.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "BaseObject.h"

@interface LXAttributedURLModel : BaseObject

@property (nonatomic,copy)                NSString   *linkData;
@property (nonatomic,assign)                NSRange range;

+(instancetype)modelWith:(NSString *)linkString rang:(NSRange)range;

@end


@interface LXLinkContentModel : BaseObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *links;

@end
