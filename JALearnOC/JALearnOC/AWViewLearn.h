//
//  AWViewLearn.h
//  JALearnOC
//
//  Created by jason on 20/4/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWViewLearn : NSObject

#warning 一、UIView与CALayer

//UIView为CALayer提供内容，以及负责处理触摸等事件，参与响应链

//CALayer负责显示内容contents


#warning 二、事件传递与视图响应链
//点击屏幕——UIApplication——UIWindow——hitTest:withEvent——pointInside:withEvent


#warning 三、图像显示原理
//1. CPU:输出位图
//2. GPU:图层渲染，纹理合成
//3. 把结果放到帧缓冲区(frame buffer)中
//4. 再由视频控制器根据vsync信号在指定时间之前去提取帧缓冲区的屏幕显示内容
//5. 显示到屏幕上

#warning 四、UI卡顿掉帧原因
//如果CPU和GPU加起来的处理时间超过了16.7ms，就会造成掉帧甚至卡顿。

#warning 五、滑动优化方案
/*
CPU：把以下操作放在子线程中
1.对象创建、调整、销毁
2.预排版（布局计算、文本计算、缓存高度等等）
3.预渲染（文本等异步绘制，图片解码等）
GPU:
纹理渲染，视图混合
一般遇到性能问题时，考虑以下问题：
是否受到CPU或者GPU的限制？
是否有不必要的CPU渲染？
是否有太多的离屏渲染操作？
是否有太多的图层混合操作？
是否有奇怪的图片格式或者尺寸？
是否涉及到昂贵的view或者效果？
view的层次结构是否合理？
*/

#warning 六、UI绘制原理
//1.[UIView setNeedsDisplay]
//2.[view.layer setNeedsDisplay]
//3.[CALayer display]
//layer.delegate respondsTo @selector(displayLayer)
//yes异步绘制入 no 系统绘制流程
//4。 结束

#warning 七、离屏渲染
//On-Screen Rendering:当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行
//Off-Screen Rendering:离屏渲染，分为CPU离屏渲染和GPU离屏渲染两种形式。GPU离屏渲染指的是GPU在当前屏幕缓冲区外新开辟一个缓冲区进行渲染操作
//应当尽量避免的则是GPU离屏渲染

//GPU离屏渲染何时会触发呢？
//圆角（当和maskToBounds一起使用时）、图层蒙版、阴影，设置


@end

NS_ASSUME_NONNULL_END
