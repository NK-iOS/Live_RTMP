# Live_RTMP
### 1、利用cocoapods加载LFLiveKit
```
source 'https://github.com/CocoaPods/Specs.git'

target ‘Live_LFLiveKit_RTMP’ do
pod 'LFLiveKit'
end
```

### 2、创建直播会话
```
// 创建直播会话
@property (nonatomic, strong) LFLiveSession *liveSession;
```
相关属性的设置，LFLiveKit已经包含了GPUImage，可以进行美颜相关操作
```
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
```
### 3、Nginx服务器配置
[参考链接](https://www.cnblogs.com/tandaxia/p/8810648.html)
* 安装nginx:
在终端执行
```
brew install nginx-full --with-rtmp-module 
```
如果报错的话，要先执行[参考链接](https://blog.csdn.net/fengsh998/article/details/79942775)：
```
brew tap denji/nginx
```

* 配置Nginx，支持http协议拉流：
在终端执行
```
open -t /usr/local/etc/nginx/nginx.conf
```
添加配置信息
```
location /hls {
#Serve HLS config
types {
application/vnd.apple.mpegurl    m3u8;
video/mp2t ts;
}
root /usr/local/var/www;
add_header Cache-Control    no-cache;
}
```
![屏幕快照 2019-02-16 下午5.29.47.png](https://upload-images.jianshu.io/upload_images/1721864-e676f88e0f675e99.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* 配置Nginx，支持rtmp协议推流:
在终端执行
```
open -t /usr/local/etc/nginx/nginx.conf
```
添加配置信息
```
rtmp {
server {
listen 1935;
ping 30s;
notify_method get;

application myapp {
live on;
record off;
max_connections 1024;
}

#增加对HLS支持开始
application hls {
live on;
hls on;
hls_path /usr/local/var/www/hls;
hls_fragment 5s;
}
#增加对HLS支持结束
}
}
```
![屏幕快照 2019-02-16 下午7.07.16.png](https://upload-images.jianshu.io/upload_images/1721864-a187209f9c1559d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 启动Nginx
在终端执行
```
nginx -s reload
```
[nginx: [error] open() "/usr/local/var/run/nginx.pid" failed (2: No such file or directory)](https://blog.csdn.net/wn1245343496/article/details/77974756)
### 4、开始直播
rtmp协议
```
// 开始直播
- (void)startLive {
LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
streamInfo.url = @"rtmp://172.16.237.61:1935/hls/live1";
[self.liveSession startLive:streamInfo];
}
```
![WechatIMG132.jpeg](https://upload-images.jianshu.io/upload_images/1721864-e651c3ab790c0593.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 5、拉流
在浏览器输入：http://localhost:8080/hls/live1.m3u8
![屏幕快照 2019-02-16 下午7.04.06.png](https://upload-images.jianshu.io/upload_images/1721864-9df76991a9c9b392.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 6、结束直播
```
// 结束直播
- (void)stopLive {
[self.liveSession stopLive];
}
```
##采集图像格式、声音格式：
**摄像头采集图像并用VideoToolbox编码成H.264码流**
**麦克风采集声音并用AudioToolbox编码成AAC码流**
