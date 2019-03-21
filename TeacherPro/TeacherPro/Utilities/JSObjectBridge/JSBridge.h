//
//  JSBridge.h
//  CPYJSCoreDemo
//
//  Created by ciel on 2016/9/29.
//  Copyright © 2016年 CPY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSBridgeProtocol <JSExport>

/**
 token
 */
- (id)findToken;
/**
 保存选择的作业
 */
- (void)saveWork:(id)sender;
/**
 
 */
- (NSString *)getHtmlWorkData;
/**
 删除选择作业
 */
- (void)removeHtmlData;

/**
  添加选择的单元
 */
- (void)saveUnit:(id)sender;

/**
  获取选择的单元
 */

- (id)getHtmlUnitData;
/**
 删除选择单元
 */
- (void)removeHtmlUnitData;

/**
 播放音频
 */
- (void)startPlayerUrl:(id)urlStr;

/**
 停止播放音频
 */
- (void)stopPlayer;

/**
  暂停
 */
- (void)suspendedPlayer;
/**
 恢复播放
 */

- (void)restorePlayer;
/**
 获取音频播放地址
 */
- (id)getPlayerAudioURL;

//开始下载音频
- (void)startDownLoadAudio:(id)bookId;

- (NSString *)updateFinish;



//退出登录
- (void)loginFail;
@end

@protocol JSBridgePlayerPlayerDelegate <NSObject>

@optional
- (NSString *)updateFinish;
- (void)stopPlayer;
- (void)suspendedPlayer;
- (void)startPlayerUrl:(id)urlStr;
/**
 获取音频播放地址
 */
- (id)getPlayerAudioURL;

-(void)restorePlayer;
//下载音频
- (void)startDownLoadAudio:(id)bookId;

//退出登录
- (void)exitLogin;
@end
@interface JSBridge : NSObject<JSBridgeProtocol>
@property(nonatomic, weak) id<JSBridgePlayerPlayerDelegate>delegate;
@end
