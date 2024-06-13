//
//  MBAdapterManager.swift
//  YMMModuleLib
//
//  Created by Lizhao on 2023/2/24.
//

import Foundation

@objc public protocol MBAdapterProtocol: YMMServiceProtocol {}

@objcMembers public final class MBAdapter: NSObject{
    
    public static let shared = MBAdapter()
    
    fileprivate var serviceManager = MBServiceCenter.init()
    
    private struct AssociatedKeys {
        static var target_key = "adapter_weak_target"
        static var adapter_key = "target_strong_adapters"
    }
    
    private var mutex : pthread_mutex_t = pthread_mutex_t();
    
    private override init() {
        super.init()
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attr)
        pthread_mutexattr_destroy(&attr)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
}

public extension MBAdapter {
    
    // 注册 adapter (SWIFT)（单个adapter协议）
    func register<Service>(service serviceType: Service.Type, used implClass: AnyClass) {
        guard implClass.conforms(to: MBAdapterProtocol.self) else {
            assertionFailure("\(implClass) service doesn't implement MBAdapterProtocol")
            return
        }
        guard implClass is Service else  {
            assertionFailure("\(implClass) must implement \(serviceType)")
            return
        }
        serviceManager.registerService(of: serviceType, withImplClass: implClass)
       }
    
    
    // 注册 adapter（多个adapter协议）
    @objc(registerAdaptersWithImplClass:)
    func registerAdapters(used implClass: AnyClass) {
        serviceManager.registerAllServices(of: MBAdapterProtocol.self, withImplClass: implClass)
    }
        
    
    // 发现 adapter (SWIFT)
    /// - Parameters:
    ///   - serviceType: adapter协议
    ///   - context: 模块上下文
    ///   - target: 主类（publisher）
    /// - Returns: adapter协议实例
    /// - Note: 方法内部实现 adapter（subscriber） 与 target主类（publisher） 绑定关联
    func adapter<Service>(of serviceType: Service.Type, from context:MBContextProtocol?, target:AnyObject) ->Service? {
        //递归锁保护线程安全
        pthread_mutex_trylock(&mutex)
        
        // step 1. 尝试从target主类关联对象中获取强关联的adapter
        let adapterName = NSStringFromProtocol(MBServiceCenter.serviceProtocol(of: serviceType)!)
        var adapterDict : NSMutableDictionary = NSMutableDictionary.init();
        if let associatedAdapters = objc_getAssociatedObject(target, &AssociatedKeys.adapter_key) as? NSMutableDictionary {
            if let adapter = associatedAdapters[adapterName] {
                pthread_mutex_unlock(&mutex)
                return adapter as? Service
            }
            adapterDict = associatedAdapters;
        }
        
        // step 2. 尝试从service center中获取注册到protocol的adapter实例类
        if let adapter = serviceManager.service(of: serviceType, fromContext: context) {
            adapterDict.setValue(adapter, forKey: adapterName)
            //将各适配器强绑定关联在主类上，这样能实现适配器的生命周期跟随主类自动释放，在使用适配器对象时让内存持续处于最优状态
            objc_setAssociatedObject(target, &AssociatedKeys.adapter_key, adapterDict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //将主类弱关联在适配器上，达到反向通信的效果
            let weakTargetProxy = MBAdapterTargetProxy.init(target: target) // 为了防止 subscriber 与 publisher 在 block 使用或者主类与适配器的关联情况下导致循环引用，适配器底层运用了 NSProxy 来实现
            objc_setAssociatedObject(adapter, &AssociatedKeys.target_key, weakTargetProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            pthread_mutex_unlock(&mutex)
            return adapter
        }
        
        // step 3. 未找到对应adapter，返回nil
        pthread_mutex_unlock(&mutex)
        return nil
    }
    
    
    // 获取adapter 的 主类 （弱依赖）
    func getWeakTarget(adapter: AnyObject) -> AnyObject? {
        //递归锁保护线程安全
        pthread_mutex_trylock(&mutex)
        if let target = objc_getAssociatedObject(adapter, &AssociatedKeys.target_key) as? AnyObject {
            pthread_mutex_unlock(&mutex)
            return target
        }
        pthread_mutex_unlock(&mutex)
        return nil
    }
}

@available(swift, obsoleted: 3.0, message: "Only used in Objective-C")
public extension MBAdapter {
    
    // 注册 adapter (OC)（单个adapter协议）
    @objc(registerAdapterOfProtocol:usedImplClass:)
    func register(adapterProtocol: Protocol, used implClass: AnyClass) {
        guard implClass.conforms(to: MBAdapterProtocol.self) else {
            assertionFailure("\(implClass) service doesn't implement MBAdapterProtocol")
            return
        }
        guard implClass.conforms(to: adapterProtocol.self) else {
            assertionFailure("\(implClass) must implement \(adapterProtocol.self)")
            return
        }
        serviceManager.registerService(of: adapterProtocol, withImplClass: implClass)
    }

    
    // 发现 adapter (OC)
    @objc(adapterOfProtocol:fromContext:withTarget:)
    /// - Parameters:
    ///   - serviceProtocol: adapter协议
    ///   - context: 模块上下文
    ///   - target: 主类（publisher）
    /// - Returns: adapter协议实例
    /// - Note: 方法内部实现 adapter（subscriber） 与 target主类（publisher） 绑定关联
    func adapter(of serviceProtocol:Protocol, from context:MBContextProtocol?, with target: AnyObject) ->YMMServiceProtocol? {
        // 设置递归锁保护线程安全
        pthread_mutex_trylock(&mutex)
        
        // step 1. 尝试从target主类关联对象中获取强关联的adapter
        let adapterName = NSStringFromProtocol(serviceProtocol)
        var adapterDict : NSMutableDictionary = NSMutableDictionary.init();
        if let associatedAdapters = objc_getAssociatedObject(target, &AssociatedKeys.adapter_key) as? NSMutableDictionary {
            if let adapter = associatedAdapters[adapterName] {
                pthread_mutex_unlock(&mutex)
                return adapter as? YMMServiceProtocol
            }
            adapterDict = associatedAdapters;
        }
        
        // step 2. 尝试从service center中获取注册到protocol的adapter实例类
        if let adapter = serviceManager.service(of: serviceProtocol, fromContext: context) {
            adapterDict.setValue(adapter, forKey: adapterName)
            //将各适配器强绑定关联在主类上，这样能实现适配器的生命周期跟随主类自动释放，在使用适配器对象时让内存持续处于最优状态
            objc_setAssociatedObject(target, &AssociatedKeys.adapter_key, adapterDict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //将主类弱关联在适配器上，达到反向通信的效果
            let weakTargetProxy = MBAdapterTargetProxy.init(target: target) //为了防止 subscriber 与 publisher 在 block 使用或者主类与适配器的关联情况下导致循环引用，适配器底层运用了 NSProxy 来实现
            objc_setAssociatedObject(adapter, &AssociatedKeys.target_key, weakTargetProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            pthread_mutex_unlock(&mutex)
            return adapter
        }
        
        // step 3. 未找到对应adapter，返回nil
        pthread_mutex_unlock(&mutex)
        return nil
    }
}

