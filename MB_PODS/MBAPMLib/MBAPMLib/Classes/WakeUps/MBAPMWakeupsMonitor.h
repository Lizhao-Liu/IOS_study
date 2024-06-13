//
//  MBAPMWakeupsMonitor.h
//  AAChartKit
//
//  Created by Lizhao on 2024/1/8.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"
#import "MBAPMWakeupsMonitorConfig.h"
#import "MBAPMWakeupsPageMonitor.h"
#import "MBAPMWakeupsExceptionMonitor.h"
@import MBDoctorService;

NS_ASSUME_NONNULL_BEGIN

/**
 - 背景
 Wakeups是“资源异常”下的一个子类，指的是频繁唤醒线程，消耗CPU资源并增加功耗，在超过阈值并处于FATAL CONDITION的条件下会触发闪退，通常见于线程间频繁交互（涉及系统底层方法交互）的场景。
 
 此监控的目的为
 1. 验证检验app由于wakeups异常导致被系统强杀引起的闪退
 2. wakeups 异常监控，上报wakeups突增、连续高位、均值异常相关信息
 
 
【检验闪退】
 1）App 本地缓存维护wakeups异常，用于表示当前app发生wakeups异常的相关信息。设置逻辑如下:
    1.1）在检测到app wakeups异常后，将当前app发生的wakeups异常保存到本地；
    1.2）接着使用 dispatch_after 方法在 5s 后清零计数，如果 App 活不过 5 秒缓存就不会被清除，下次启动就可以读取到；
    1.3）在 app 接收到 UIApplicationWillTerminateNotification 时机清除 wakeups异常缓存，排除 App 是被手动 kill 来减少误报。
 2）在app启动后，判断 App 之前是否发生过连续wakeups异常。判断逻辑如下:
    2.1）先取出缓存中的wakeups异常缓存；
    2.2）如果存在，表明 App 之前发生wakeups异常后被kill，触发埋点上报并重置缓存。
 
 
【异常上报】
 1. 概念区分
 Wakeups连续高位异常：指连续一段时间内，新增wakeups次数持续处于一个异常高的水平。
 Wakeups突增异常： 表示在某个时间段内，系统的唤醒次数突然急剧增加。这种情况可能是由于某个操作或事件导致的，比如点击等。
 Wakeups检测周期内平均值超过系统阈值异常： 指一段监控周期内的wakeups平均唤醒次数超过了系统预设的阈值。
 
 2. 判定方式
     1) wakeups 均值异常 ：
         时机： 300秒内 wakeups 增量均值超过150次（仿苹果系统底层wakeups监控实现，参考资料： https://developer.apple.com/forums/thread/124180 ）
         上报数据：当前监控周期wakeups增长计数总数、每秒增长平均值、监控时长、严重异常分段信息等
     2) wakeups 突增异常 ：
         时机：当前秒 wakeups 增量超过450次(可配置) && 相较上一秒涨幅较大 (600以下涨幅达到120%，600以上涨幅达到110%)
         上报数据：
           如果为单次突增，则上报当前秒 wakeups 增量、临近行为事件类型、临近行为事件特征；
           如果为连续上涨突增，则上报当前连续突增阶段的wakeups 增量s、临近行为事件类型、临近行为事件特征；
     3) wakeups 连续高位异常 ：
         时机：wakeups增量在阈值600(可配置) 以上
         上报数据：高位阶段 wakeups 增量每秒平均值
 
 3. 数据采集方式
    开启全局计时器，每秒钟通过系统方法获取当前进程的wakeups总量，计算差值采集当前秒wakeups增量。 (进入后台关闭计时器)
 
【wakeups 页面监控】
    监控方式：监听页面viewWillAppear 和 disappear 生命周期方法，记录当前页面的wakeups每秒增量平均值并上报。
    上报数据：页面wakeups增长计数总数、每秒增长平均值、每秒增长峰值、停留时长、开始/结束时间等 (进入后台wakeups增量会被忽略)
 */


@interface MBAPMWakeupsMonitor : MBAPMPlugin

@property (nonatomic, strong) MBAPMWakeupsPageMonitor *pageMonitor;
@property (nonatomic, strong) MBAPMWakeupsExceptionMonitor *exceptionMonitor;

@end

NS_ASSUME_NONNULL_END
