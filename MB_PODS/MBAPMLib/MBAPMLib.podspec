# frozen_string_literal: true
 
Pod::Spec.new do |s|
  s.name             = 'MBAPMLib'
  s.version          = '0.21.1-beta5'
  s.summary          = 'MBAPMLib'
  s.description      = <<~DESC
    this lib contains MBAPMLib
  DESC

 s.homepage         = 'http://code.amh-group.com/iOSYmm/MBAPMLib'
 # s.license          = { :type => 'MIT', :file => 'LICENSE' }
 s.author           = { '向平' => 'ping.xiang@amh-group.com' }
 s.source           = {
   git: 'git@code.amh-group.com:iOSYmm/MBAPMLib.git',
   tag: s.version.to_s
 }
 s.ios.deployment_target = '10.0'
 s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
 s.xcconfig = {
   'OTHER_CFLAGS' => '-fmodules -fcxx-modules $(inherited)'
 }
 s.default_subspec = 'Core', 'RouterIntercept', 'NetworkIntercept'
 s.subspec 'Core' do |ss|
     ss.source_files = 'MBAPMLib/Classes/**/*.{h,m,mm}'
     ss.public_header_files = 'MBAPMLib/Classes/Core/MBAPMLib.h',
     'MBAPMLib/Classes/Core/MBAPMMonitor.h',
     'MBAPMLib/Classes/Core/Metric/**/*.h',
     'MBAPMLib/Classes/Core/DataExport/MBAPMDataCache.h',
     'MBAPMLib/Classes/Core/DataExport/Statistic/MBAPMPageRenderMetricStatistic.h',
     'MBAPMLib/Classes/Crash/Handler/MBAPMExceptionStackParser.h',
     'MBAPMLib/Classes/AppLaunch/MBAPMAppLaunchTimeModel.h',
     'MBAPMLib/Classes/Cpu/Utils/MBAPMCPUUtil.h',
     'MBAPMLib/Classes/Core/Plugin/MBAPMPluginConfig.h',
     'MBAPMLib/Classes/Render/MBAPMCurrentPageInfo.h',
     'MBAPMLib/Classes/Storage/MBAPMStorageMonitorConfig.h',
     'MBAPMLib/Classes/WakeUps/MBAPMWakeupsMonitorConfig.h'

     ss.exclude_files = 'MBAPMLib/Classes/Tools/**/*.{h,m,mm}',
     'MBAPMLib/Classes/Crash/ZombieSniffer/**/*.{h,m,mm}',
     'MBAPMLib/Classes/Intercept/**/*.{h,m,mm}'
     ss.vendored_frameworks = ['MBAPMLib/Classes/Crash/Frameworks/*.framework']
     ss.dependency 'YYModel', '~> 1.0'
     ss.dependency 'MBDoctorService', '~> 0.1'
     #ss.dependency 'MBDoctor', '~> 0.1'
     ss.dependency 'RSSwizzle', '~> 0.1'
     ss.dependency 'MBAPMServiceLib', '~> 0.13', '>= 0.13.1'
     ss.dependency 'MBStorageLibService', '~> 0.1'
     ss.dependency 'MBStorageLib', '~>0.7'
     ss.dependency 'MBAPMLib/Tools'
     ss.dependency 'MBAPMLib/ZombieSniffer'
     ss.dependency 'YMMModuleLib', '~> 0.6'
#     ss.dependency 'MBNativeBridgeAdapter', '~> 1.0.0'
     ss.dependency 'MBDoctorService', '~> 0.10'
     ss.dependency 'MBUIKit', '~> 0.17', '>= 0.17.2'
     ss.dependency 'SDWebImage', '~> 5.15'
     ss.dependency 'MBProjectConfig', '~> 0.15'
     ss.dependency 'MBBuildPreLib', '~> 0.1'
     ss.dependency "MBFoundation", '~> 0.4'
     ss.dependency "MMKV", '~> 1.2'
     ss.dependency 'TypedJSON', '~> 1.2'
     ss.dependency "FBRetainCycleDetector", '~> 0.1', :configurations => ['Debug']
     ss.dependency "MBMapLibModuleService", '~> 0.1'
     ss.dependency "MBConfigCenterService", '~> 0.1'
     ss.dependency "MBLauncherLib", '~> 0.11'
     ss.dependency 'YMMNetwork', '~> 1.0'

 end
 
 s.subspec 'RouterIntercept' do |ss|
   ss.source_files = 'MBAPMLib/Classes/Intercept/Router/**/*.{h,m,mm}'
   ss.private_header_files = 'MBAPMLib/Classes/Intercept/Router/**/*.h'
   ss.dependency 'YMMRouterLib', '~> 0.34'
   ss.dependency 'MBAPMLib/Core'
 end
 
 s.subspec 'NetworkIntercept' do |ss|
   ss.source_files = 'MBAPMLib/Classes/Intercept/Network/**/*.{h,m,mm}'
   ss.dependency 'MBNetworkLib', '~> 1.1'
   ss.dependency 'MBAPMLib/Core'
 end

 
 s.subspec 'ZombieSniffer' do |ss|
   ss.source_files = 'MBAPMLib/Classes/Crash/ZombieSniffer/**/*.{h,m,mm}'
   ss.requires_arc = false
   ss.public_header_files = 'MBAPMLib/Classes/Crash/ZombieSniffer/MBAPMZombieSniffer.h',
                            'MBAPMLib/Classes/Crash/ZombieSniffer/MBAPMZombieConfig.h', 'MBAPMLib/Classes/Crash/ZombieSniffer/MBAPMConfiguration+Zombie.h'
  end
 
 s.subspec 'Tools' do |ss|
     ss.source_files = 'MBAPMLib/Classes/Tools/**/*.{h,m,mm}'
     ss.public_header_files = 'MBAPMLib/Classes/Tools/TimeTrack/MBAPMEventTimeTrackMgr.h', 
         'MBAPMLib/Classes/Tools/TimeTrack/MBAPMEventTimeTrackMgrPro.h', 'MBAPMLib/Classes/Tools/Utils/CallStack/MBAPMBacktraceLogger.h',
         'MBAPMLib/Classes/Tools/Utils/CallStack/MBAPMBacktraceLogger.h',
         'MBAPMLib/Classes/Tools/Utils/CallStack/MBAPMUUIDUtil.h',
         'MBAPMLib/Classes/Tools/Utils/DeviceInfo/MBDeviceInfo.h',
         'MBAPMLib/Classes/Tools/Model/MBThreadStackModel.h',
         'MBAPMLib/Classes/Tools/Matrix/MBMatrixLagDetectorReportModel.h',
         'MBAPMLib/Classes/Tools/Utils/Storage/MBAPMStorageUtil.h',
         'MBAPMLib/Classes/Tools/Utils/Memory/MBAPMMemoryUtil.h',
         'MBAPMLib/Classes/Tools/DataGather/MBAPMSystemDataGather.h',
         'MBAPMLib/Classes/Tools/DataGather/MBAPMSystemDataCache.h',
         'MBAPMLib/Classes/Tools/DataGather/MBAPMDataCacheQueue.h',
         'MBAPMLib/Classes/Tools/FPS/MBAPMFPSUtil.h'
     ss.dependency 'MBLogLib', '~> 0.1'
     ss.dependency 'MBAPMServiceLib', '~> 0.13', '>= 0.13.1'
     ss.dependency 'Matrix', '~> 1.0', '>= 1.0.8.4'
     ss.dependency 'MBFileTransferLib', '~> 0.3'
     ss.dependency 'MBBuildPreLib', '~> 0.1'
     ss.dependency "MMKV", '~> 1.2'
     ss.dependency 'YYModel', '~> 1.0'
end

end
