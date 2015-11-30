/**
 * 手势签名：可变的笔刷宽度
 * 笔刷的宽度应该基于签名的速度而变化，这样的签名看起来才自然。
 * UIPanGestureRecognizer 有一个 velocityInView 方法可以返回当前触摸点的速度。
 * 感谢原文作者的分享https://github.com/jharwig/PPSSignatureView
 * 参考：http://blog.csdn.net/yiyaaixuexi/article/details/8848449
 */

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface TYGSignatureView : GLKView

@property (assign, nonatomic) UIColor *strokeColor;//画笔颜色
@property (assign, nonatomic) BOOL hasSignature;//是否正在书写
@property (strong, nonatomic) UIImage *signatureImage;//获取画板内容图片

/**
 *  擦除(清空画板)
 */
- (void)erase;

@end
