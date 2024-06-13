#
# Be sure to run `pod lib lint GasStationMerchantMainModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GasStationMerchantMainModule'
  s.version          = '0.1.0'
  s.summary          = '能源商户app main module'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
能源商户app业务module.
                       DESC

  s.homepage         = 'https://github.com/Lizhao/GasStationMerchantMainModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lizhao' => 'lizhao.liu@amh-group.com' }
  s.source           = { :git => 'https://github.com/Lizhao/GasStationMerchantMainModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'GasStationMerchantMainModule/Classes/**/*'
  
   s.resource_bundles = {
     'GasStationMerchantMainModule' => ['GasStationMerchantMainModule/Assets/**/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "YMMModuleLib", "~> 0.16"
  s.dependency "MBLauncherLib", "~> 0.6"
  s.dependency "YMMUserModuleService"
  s.dependency 'HCBLoginSDK', "~> 1.0"
  s.dependency 'JSONModel'
  s.dependency 'HCBNetwork'
  s.dependency 'HCBUserBasis',  "~> 2.1"
  s.dependency 'HCBAppBasis', "~> 4.4"
  s.dependency 'MBDoctorService'
  s.dependency 'MBProgressHUD'
  s.dependency 'MBUIKit'
  s.dependency 'MBProjectConfig'
  s.dependency 'MBAppBasisModule'
  s.dependency 'IQKeyboardManager'
  s.dependency 'YMMAuditService',  "~> 0.1"
  s.dependency 'Flutter'
  s.dependency 'YMMRouterLib'
  s.dependency 'JSONKit'
  s.dependency 'HCBWebConsole'
  s.dependency 'MBWalletModuleService'
  
end
