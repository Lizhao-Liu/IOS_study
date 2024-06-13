#
# Be sure to run `pod lib lint YMMRouterModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBRouterDebug'
  s.version          = '1.3.0'
  s.summary          = '路由调试库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  路由调试工具，负责测试路由是否能够正常跳转以及上报当前所有注册的路由信息
                       DESC

  s.homepage         = 'https://code.ymmoa.com/iOSYmm/YMMRouterLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '向平' => 'ping.xiang@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/YMMRouterLib', :tag => "MBRouterDebug_#{s.version.to_s}" }
  s.ios.deployment_target = '10.0'
  s.source_files = 'MBRouterDebug/Classes/*.{h,m,mm}'
  s.resource_bundles = {
    'MBRouterDebug' => ['MBRouterDebug/Assets/*.plist']
  }
  s.dependency 'YMMModuleLib', '~> 0.3'
  s.dependency 'YMMRouterLib', '~> 0.39'
  s.dependency 'YMMRouterModule', '~> 1.0'
  s.dependency 'MBCommonUILib', '~> 0.2'
  s.dependency 'MBBuildPreLib', '~> 0.1'
  s.dependency 'MBUIKit', '~> 0.8'
  s.dependency 'MBProjectConfig', '~> 0.15'
  s.dependency 'MBFoundation', '~> 0.4'
  s.dependency 'MBLogLib', '~> 0.2'
  s.dependency 'MBDebugService', '~> 0.5'
  s.dependency 'MBDebug/MonitorTools', "~> 3.2"
  s.dependency 'MBDoctorService', '~> 0.10'
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
