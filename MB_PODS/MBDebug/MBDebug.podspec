#
# Be sure to run `pod lib lint YMMPublishModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "MBDebug"
  s.version = "3.3.4"
  s.summary = "满帮调试面板"
  s.description = <<-DESC
满帮调试面板,包括：网络设置、加密开关、Crash日志等
DESC

  s.homepage = "http://code.ymmoa.com/iOSYmm/MBDebug.git"
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "ping.xiang" => "ping.xiang@amh-group.com" }
  s.source = { :git => "git@code.amh-group.com:iOSYmm/MBDebug.git", :tag => s.version.to_s }

  s.ios.deployment_target = "10.0"
  s.source_files = "MBDebug/Classes/**/*"
  s.resources = "MBDebug/Resources/*"
#  s.requires_arc = true
  s.default_subspecs = "Debug", "MonitorTools", "Performance", "Entry", "Monitor", "Base"
#

  s.subspec "Base" do |ss|
    ss.source_files = "MBDebug/Classes/Util/**/*"
    ss.dependency "MBUIKit", '~> 0.8'
    ss.dependency "MBDebugService", '~> 0.5'
    ss.dependency "YMMModuleLib", '~> 0.19'
    ss.dependency "MBFoundation", "~> 0.1"
    ss.dependency "MBLauncherLib", "~> 0.8"
    ss.dependency "Masonry", '~> 1.1'
  end

  s.subspec "Entry" do |ss|
    ss.source_files = "MBDebug/Classes/Entry/**/*"
    ss.dependency "MBDebug/Base"
    ss.dependency "MBUIKit", '~> 0.8'
    ss.dependency "MBDebugService", '~> 0.5'
    ss.dependency "YMMModuleLib", '~> 0.19'
    ss.dependency "MBFoundation", "~> 0.1"
    ss.dependency "MBLauncherLib", "~> 0.8"
    ss.dependency "Masonry", '~> 1.1'
  end
    
  s.subspec "Debug" do |ss|
    ss.source_files = "MBDebug/Classes/Debug/**/*"
    ss.dependency "YYText", '~> 1.0'
    ss.dependency "IQKeyboardManager", '~> 5.0'
    ss.dependency "MBCommonUILib", "~> 0.7"
    ss.dependency "MBDebug/Entry"
  end
  
  s.subspec "Monitor" do |ss|
    ss.source_files = "MBDebug/Classes/Monitor/**/*"
    ss.dependency "Masonry", '~> 1.1'
    ss.dependency "MBDebug/Entry"
    ss.dependency "MBCommonUILib",  '~> 0.7'
    ss.dependency "MBDoctorService", '~> 0.10'
  end
  
  s.subspec "MonitorTools" do |ss|
    ss.source_files = "MBDebug/Classes/MonitorTools/**/*"
    ss.dependency "Masonry", '~> 1.1'
    ss.dependency "MBUIKit", '~> 0.8'
    ss.dependency "MBDebug/Base"
    ss.dependency "MBFoundation", "~> 0.1"
    ss.dependency "MBCommonUILib",  '~> 0.7'
    ss.dependency "MBDoctorService", '~> 0.10'
  end
  
  s.subspec "Performance" do |ss|
    ss.source_files = "MBDebug/Classes/Performance/**/*"
    ss.dependency "MBDebug/Entry"
  end
    

end
