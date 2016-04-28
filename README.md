# SuperDemo
##功能说明
这是本人平时工作所用的一些开发技巧及第三方包的DEMO！    
如果有需要学习iOS的同学或者是说不想自己一点点去集成的同学，拿去看一下，相信会有所帮助的！    
代码的封装在目录：SuperDemo/Utility/TYG_Utility/    
   
注：    
1.采用CocoaPods集成第三方开源库，如果不知道什么是CocoaPods请自行百度！    
2.终端运行“pod install”    
3.请点击SuperDemo.xcworkspace 启动工程    

##截图
![demo1](https://github.com/bingxue314159/SuperDemo/raw/master/Screen/SuperDemo.gif "菜单")  

##已知问题
###1.冲突
ASValueTrackingSlider与ASProgressPopUpView为同一作者，但在两个工程中用了同样的静态常量，把其中一个工程里的常量名更改一下就可以通过编译了   
此问题已联系作者，已在'ASValueTrackingSlider', '~> 0.11.2' 版本解决    
```objc
const float ARROW_LENGTH = 8.0;   
const float POPUPVIEW_WIDTH_PAD = 1.15;    
const float POPUPVIEW_HEIGHT_PAD = 1.1;    
NSString *const FillColorAnimation = @"fillColor";    
```

###2.卡顿
因在AppDelegate中加入了内存循环引用监测工具[FBMemoryProfiler](https://github.com/facebook/FBMemoryProfiler)，会导致APP运行起来会较明显的有卡顿或者迟缓现象，若出现此问题，可移除内存监测的代码
```objc
    _memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[CacheCleanerPlugin new],
                                                                  [RetainCycleLoggerPlugin new]]
                               retainCycleDetectorConfiguration:nil];    
    [_memoryProfiler enable];    
```
    
FBMemoryProfiler用法    
中文版：[iOS上自动检测内存泄露](http://www.cocoachina.com/ios/20160419/15954.html)
英文版:[Automatic memory leak detection on iOS](https://code.facebook.com/posts/583946315094347/automatic-memory-leak-detection-on-ios/)

##签名
![demo1](https://github.com/bingxue314159/SuperDemo/raw/master/Screen/程序,你快下来吧.gif "签名")    