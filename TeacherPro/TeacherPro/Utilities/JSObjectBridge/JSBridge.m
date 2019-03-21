//
//  JSBridge.m
//  CPYJSCoreDemo
//
//  Created by ciel on 2016/9/29.
//  Copyright © 2016年 CPY. All rights reserved.
//

#import "JSBridge.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "GTMBase64.h"
#import "ProUtils.h"

#define SAVE_WORK_KEY   @"saveWorkKEY"
#define SAVE_UNIT_KEY   @"saveUNITKEY"

@implementation JSBridge


- (id)findToken{
     NSLog(@"%s",__FUNCTION__);
    NSString * token = @"";
    //传token
    if ([[SessionHelper sharedInstance] checkSession]) {
        
        token =  [[SessionHelper sharedInstance] getAppSession].token;
        
    }
  
    return token;
}

- (void)saveWork:(id)sender{
     NSLog(@"%s",__FUNCTION__);
//    NSData *decodeData = [GTMBase64 decodeData:[sender dataUsingEncoding:NSUTF8StringEncoding]];
//    NSString *base64DecodeString = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
// 
    [[NSUserDefaults standardUserDefaults] setObject:sender forKey:SAVE_WORK_KEY];
    
}

- (NSString *)getHtmlWorkData{
    NSLog(@"%s",__FUNCTION__);

     NSString * saveString = [[NSUserDefaults standardUserDefaults]  objectForKey:SAVE_WORK_KEY];
//     NSData *encodeData = [GTMBase64 encodeData:[saveString dataUsingEncoding:NSUTF8StringEncoding]];
//    NSString *base64EncodeStr = [[NSString alloc]initWithData:encodeData encoding:NSUTF8StringEncoding];
    
    return saveString ;
}


- (void)removeHtmlData  {
     NSLog(@"%s",__FUNCTION__);
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:SAVE_WORK_KEY];
}

- (void)saveUnit:(id)sender{
     NSLog(@"%s",__FUNCTION__);
     [[NSUserDefaults standardUserDefaults] setObject:sender forKey:SAVE_UNIT_KEY];
    
}
- (id)getHtmlUnitData{
     NSLog(@"%s",__FUNCTION__);
    NSString * unit =  [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_UNIT_KEY];
    
   return unit;
}

- (void)removeHtmlUnitData{
      NSLog(@"%s",__FUNCTION__);
     [[NSUserDefaults standardUserDefaults]  removeObjectForKey:SAVE_WORK_KEY];
}

- (void)stopPlayer{
    NSLog(@"%s",__FUNCTION__);
    if ([self.delegate  respondsToSelector:@selector(stopPlayer)]) {
        [self.delegate stopPlayer];
    }
}

- (void)suspendedPlayer{
    NSLog(@"%s",__FUNCTION__);
    if([self.delegate  respondsToSelector:@selector(suspendedPlayer)]){
    
        [self.delegate suspendedPlayer];
    }
}

- (void)startPlayerUrl:(id)urlStr{
    NSLog(@"%s",__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(startPlayerUrl:)]) {
        [self.delegate startPlayerUrl:urlStr];
    }
    
}

- (void)startPlayerUrl{

    if ([self.delegate respondsToSelector:@selector(restorePlayer)]) {
         [self.delegate respondsToSelector:@selector(restorePlayer)];
    }
   
}
-(void)restorePlayer{
    NSLog(@"%s",__FUNCTION__);
    if([self.delegate  respondsToSelector:@selector(restorePlayer)]){
        
        [self.delegate restorePlayer];
    }
}

- (id)getPlayerAudioURL{
    id url = @"";
    if ([self.delegate respondsToSelector:@selector(getPlayerAudioURL)]) {
    
       url = [self.delegate getPlayerAudioURL];
    }
 
    return url;
}


- (void)startDownLoadAudio:(id)bookId{

    if ([self.delegate respondsToSelector:@selector(startDownLoadAudio:)]) {
        [self.delegate startDownLoadAudio:bookId];
    }
    
}

- (NSString *)updateFinish{

    NSString * pageNumber = @"1";
    if ([self.delegate respondsToSelector:@selector(updateFinish)]) {
       pageNumber = [self.delegate updateFinish];
    }
    return pageNumber;
}

- (void)loginFail{
  
    if ([self.delegate  respondsToSelector:@selector(exitLogin)]) {
        [self.delegate exitLogin];
    }
  
}
@end
