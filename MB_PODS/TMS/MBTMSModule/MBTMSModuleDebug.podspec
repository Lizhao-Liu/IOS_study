Pod::Spec.new do |s|
  s.name             = 'MBTMSModuleDebug'
  s.version          = '0.1.0'
  s.summary          = 'A debug tool of MBTMSModule.'
  s.description      = <<-DESC
A debug tool of MBTMSModule.
                       DESC

  s.homepage         = 'https://code.amh-group.com/MBFrontend/iOS/MBTMSModule.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhanghaitao' => 'haitao.zhang2@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:MBFrontend/iOS/MBTMSModule.git', :tag => "MBTMSModuleDebug_#{s.version.to_s}" }

  s.ios.deployment_target = '10.0'

  s.swift_version    = '5.0'
  s.source_files = 'MBTMSModuleDebug/Classes/**/*.{h,m,mm,swift}'
  s.public_header_files = 'MBTMSModuleDebug/Classes/**/*.h'
  
  s.dependency 'YMMModuleLib', '~> 0.3'
  s.dependency 'YMMRouterLib', '~> 0.25'
  s.dependency 'MBDebugService', '~> 0.1'
  s.dependency 'YMMBridgeLib', '~> 1.0'
  s.dependency 'MBTMSModule'
  

end
