//
//  ViewController.m
//  Live_LFLiveKit_RTMP
//
//  Created by 聂宽 on 2019/2/16.
//  Copyright © 2019 聂宽. All rights reserved.
//

#import "ViewController.h"
#import <LFLiveKit.h>

@interface ViewController ()<LFLiveSessionDelegate>
// 创建直播会话
@property (nonatomic, strong) LFLiveSession *liveSession;
// 记录直播状态
@property (nonatomic, assign) BOOL isLive;
@end

@implementation ViewController
- (LFLiveSession*)liveSession {
    if (!_liveSession) {
        _liveSession = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        // 预览视图
        _liveSession.preView = self.view;
        // 设置为后置摄像头
        _liveSession.captureDevicePosition = AVCaptureDevicePositionBack;
        // 开启美颜
        _liveSession.beautyFace = YES;
        _liveSession.delegate = self;
    }
    return _liveSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.liveSession setRunning:YES];
}
- (IBAction)startBtn:(UIButton *)sender {
    if (self.isLive) {
        [self stopLive];
        self.isLive = NO;
        [sender setTitle:@"开始直播" forState:UIControlStateNormal];
    }else
    {
        [self startLive];
        self.isLive = YES;
        [sender setTitle:@"结束直播" forState:UIControlStateNormal];
    }
}

// 开始直播
- (void)startLive {
    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    streamInfo.url = @"rtmp://10.10.3.8:1935/hls/live1";
    [self.liveSession startLive:streamInfo];
}

// 结束直播
- (void)stopLive {
    [self.liveSession stopLive];
}

#pragma mark - LFLiveSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state
{
    
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo
{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode
{
    
}
@end
