Pod::Spec.new do |s|
  s.name             = 'MBTMSModule'
  s.version          = '0.3.0'
  s.summary          = 'A short description of MBTMSModule.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://code.amh-group.com/MBFrontend/iOS/MBTMSModule.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhanghaitao' => 'haitao.zhang2@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:MBFrontend/iOS/MBTMSModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.swift_version    = '5.0'
  s.source_files = 'TMSBaseModule/Classes/**/*.{h,m,mm,swift}'
  s.public_header_files = 'TMSBaseModule/Classes/**/*.h'
  s.resource_bundles = {
      'TMSBaseModule' => ['TMSBaseModule/Assets/*.xcassets']
  }
  
  s.dependency 'YMMModuleLib', "~> 0.19"
  s.dependency 'MBUIKit', "~> 0.14"
  s.dependency 'MBBuildPreLib', "~> 0.1"
  s.dependency 'MBLogLib', "~> 0.6"
  s.dependency 'MBStorageLib', "~> 0.8"
  s.dependency 'MBProjectConfig', "~> 0.17"
  s.dependency 'MBFoundation', "~> 0.6"
  s.dependency 'SDCycleScrollView', "~> 1.78"
  s.dependency 'YMMRouterLib', "~> 0.43"
  s.dependency 'MBLauncherLib', "~> 0.12"
  s.dependency 'SDWebImage', "~> 5.15"
  s.dependency 'MBCommonUILib', "~> 0.9"
  s.dependency 'YMMBridgeLib', "~> 1.9"
  s.dependency 'YMMMainServices', "~> 0.10"
  s.dependency 'MBVersionModule', "~> 1.4"
  s.dependency 'MBDoctorService', "~> 0.11"
  s.dependency 'MBWechatOpenSDK', "~> 0.1"
  s.dependency 'HCBAppBasis', "~> 4.5"
  s.dependency 'MBConfigCenter', "~> 1.9"
  s.dependency 'MBLocationLib', "~> 1.2"
  s.dependency 'MBStorageLibService', "~> 0.5"
  s.dependency 'MBXarLib', "~> 0.2"
  s.dependency 'SSZipArchive', "~> 2.2"
  s.dependency 'MBPermission', '~> 2.0'
  s.dependency 'MBMessageCenterLib', "~> 0.3"
  s.dependency 'YMMBridgeModuleService', "~> 0.2"
  s.dependency 'MBTigaModuleService', "~> 0.2"
  s.dependency 'MBNetworkLib', "~> 1.1"
  s.dependency 'MBMainContainerLib', "~> 0.2"
  s.dependency 'MBShareLib', "~> 0.2"
  s.dependency 'MBAppBasisModule', "~> 0.6"

  

end
