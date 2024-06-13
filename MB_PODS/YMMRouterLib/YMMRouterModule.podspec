#
# Be sure to run `pod lib lint YMMRouterModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMMRouterModule'
  s.version          = '1.5.2'
  s.summary          = 'A short description of YMMRouterModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://code.amh-group.com/iOSYmm/YMMRouterLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '向平' => 'ping.xiang@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/YMMRouterLib.git', :tag => "YMMRouterModule_#{s.version.to_s}" }
  s.ios.deployment_target = '10.0'
  s.source_files = 'YMMRouterModule/Classes/**/*'
  s.private_header_files = 'YMMRouterModule/Classes/**/*.h'
  s.resource_bundles = {
    'YMMRouterModule' => ['YMMRouterModule/Assets/*.png', 'YMMRouterModule/Assets/*.plist']
  }
  s.dependency 'YMMModuleLib', '~> 0.4'
  s.dependency 'YMMRouterLib', '~> 0.44', '>= 0.44.1'
  s.dependency 'MBDoctorService', '~> 0.10'
  s.dependency 'Masonry', '~> 1.0'
  s.dependency 'MBCommonUILib', '~> 0.1'
  s.dependency 'MBProjectConfig', '~> 0.3'
  s.dependency 'MBUIKit', '~> 0.3'
  s.dependency 'YMMMainServices', '~> 0.7'
  s.dependency "MBShareWX", "~> 0.1"
  s.dependency "MBLogLib", "~> 0.1"
  s.dependency "MBFoundation", "~> 0.4"
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
