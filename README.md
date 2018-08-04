### 使用 AVAudioRecorder 录制音频

我们可以在 Mac 机器和 iOS 设备上适应这个类(AVAudioRecorder)来从内置的麦克风录制音频,也可以从外部音频设备进行录制,如数字音频接口或 USB 麦克风等.

#### 1.创建 AVAudioRecorder

创建该实例时需要为其提供数据的一些信息,分别是:

- 本地文件的 URL
	-  用来表示音频流写入文件的本地文件 URL
- NSDictionary 对象
	- 用来配置录音会话键值信息
- NSError 指针
	- 用来捕捉初始化阶段各种错误

为了成功创建`AVRecorder`    实例,建议调用其`prepareToRecord`方法,它会在 URL 参数指定的位置创建一个文件,将录制启动时的延时降到最小.

##### 1.1 音频格式

`AVFormatIDKey`键 定义了写入内容的音频格式.下面常量都是音频格式支持的值:

```objc
// 1.会将未压缩的音频里写入到文件中,保真度最高,但是文件也最大.
kAudioFormatLinearPCM

// 2.选择 kAudioFormatMPEG4AAC 或 kAudioFormatAppleIMA4 压缩格式会显著缩小文件,还能保证高质量的音频内容
kAudioFormatMPEG4AAC
kAudioFormatAppleLossless

// 3.---
kAudioFormatAppleIMA4
kAudioFormatiLBC
kAudioFormatULaw
```

##### 1.2 采样率

`AVSampleRateKey`用来定义录音器的采样率.
	采样率定义了对输入的模拟音频信号每一秒内的采样数.在录制音频的质量及最终文件大小方面,采样率扮演着至关重要的角色.
	
- 使用`低采样率`,比如 `8kHz`,会导致粗粒度、AM 广播类型的录制效果,不过文件会比较小.
- 使用`CD 质量的采样率`,比如`44.1kHz`,会得到非常高质量的内容,不过文件会比较大.
- 开发者应该选择尽量使用`标准的采样率`,比如`8000`、`16000`、`22050`、`44100`.最终结果由我们的耳朵判断.

##### 1.3 通道数

`AVNumberOfChannelsKey`用来定义记录音频内容的通道数.

- 指定`默认1`,意味着使用单声道录制.
- 设置为`2`,意味着使用立体声录制.
- 除非使用外部硬件进行录制,否则通常应该创建单声道录音.

##### 1.4 指定格式的键


#### 2.配置音频会话

该Demo核心功能是录音和播放已录制的音频.所以不能使用默认的分类(AVAudioSessionCategorySoloAmbient).因为它不支持音频输入.
因为即录音又要对外播放,合适的分类应该是`AVAudioSessionCategoryPlayAndRecord`. 配置信息如下:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
        NSLog(@"Category Error: %@",[error localizedDescription]);
    }
    if (![session setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@",[error localizedDescription]);
    }
    
    return YES;
}
```


- info.plist 中请求权限

```objc
// 请求麦克风录制音频权限
Privacy - Microphone Usage Description
```

#### 3.核心方法

- 配置录音器
	- 我们将录音记录在 tmp 目录中一个名为`memo.caf`的文件.在录制音频的过程中,`Core Audio Format(CAF)`通常是最好的容器格式,因为它和内容无关并可以保存`Core Audio`支持的任何音频格式.

```objc
- (instancetype)init {
    if (self = [super init]) {
        
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *filePath = [tmpDir stringByAppendingPathComponent:@"memo.caf"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        NSDictionary *settings = @{
        			// 1.音频格式
                                   AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                // 2.采样率
                                   AVSampleRateKey : @44100.0f,
                                // 3.单声道录制
                                   AVNumberOfChannelsKey : @1,
                                // 4.位元深度
                                   AVEncoderBitDepthHintKey : @16,							
                                // 5.采样率转换的音频质量
                                   AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                   };
        
        NSError *error;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
        
        if (self.audioRecorder) {
            self.audioRecorder.delegate = self;
            [self.audioRecorder prepareToRecord];
        } else {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        
    }
    return self;
}
```

- 录制

```objc
- (BOOL)record {
    return [self.audioRecorder record];
}
```

- 暂停录制

```objc
- (void)pause {
    [self.audioRecorder pause];
}
```

- 结束录制

```objc
- (void)stopWithCompletionHandler:(TYRecordingStopCompletionHandler)handler {
    self.stopCompletionHander = handler;
    [self.audioRecorder stop];
}
```

- 保存音频文件

```objc
- (void)saveRecordingWithName:(NSString *)name completionHandler:(TYRecordingSaveCompletionHandler)handler {
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *filename = [NSString stringWithFormat:@"%@-%f.caf", name, timestamp];
    NSString *docsDir = [self documentsDirectory];
    NSString *destPath = [docsDir stringByAppendingPathComponent:filename];
    NSURL *srcURL = self.audioRecorder.url;
    NSURL *destURL = [NSURL fileURLWithPath:destPath];
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
    
    if (success) {
        handler(YES, [TYMemo memoWithTitle:name url:destURL]);
        [self.audioRecorder prepareToRecord];
    } else {
        handler(NO, error);
    }
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
```
