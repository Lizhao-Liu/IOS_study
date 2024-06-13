# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name = "MBAPMDebug"
  s.version = "0.4.13"
  s.summary = "Debug module for MBAPMLib."

  s.description = <<-DESC
This libirary is designed for checking app performance log and statistic data.
                       DESC

  s.homepage = "http://code.amh-group.com/iOSYmm/MBAPMLib"
  s.author = { "xiangping" => "ping.xiang@amh-group.com" }
  s.source = { :git => "git@code.amh-group.com:iOSYmm/MBAPMLib.git", :tag => "MBAPMDebug_#{s.version.to_s}" }

  s.ios.deployment_target = "10.0"
  s.swift_version = "5.0"
  s.static_framework = true
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.public_header_files = ["MBAPMDebug/Classes/**/*.h"]
  s.private_header_files = ['MBAPMDebug/Classes/MBAPMDebug-Bridging-Header.h']
  s.source_files = "MBAPMDebug/Classes/**/*.{h,m,mm,swift}"
  s.dependency "MBAPMLib", "~> 0.5"
  s.dependency "MBAPMLib/Tools", "~> 0.18"
  s.dependency "MBAPMServiceLib", "~> 0.5"
  s.dependency 'MBDebugService', '~> 0.5'
  s.dependency "YMMModuleLib", "~> 0.1"
  s.dependency "MBLauncherLib", "~> 0.8"
  s.dependency "DoraemonKit", "~> 3.0"
  s.dependency "MBFoundation", "~> 0.4"
  s.dependency "MBLauncherLib", "~> 0.1"
  s.dependency 'MBDebug/MonitorTools', "~> 3.3"
  s.dependency 'MBLogLibDebug', '~> 0.2'
  s.dependency 'MBConfigCenterService', '~> 0.3'
  s.dependency 'MBStorageLib', '~> 0.8'
  s.dependency 'MBUIKit', '~> 0.9'
  s.dependency 'YMMRouterLib', '~> 0.39'
  
end
