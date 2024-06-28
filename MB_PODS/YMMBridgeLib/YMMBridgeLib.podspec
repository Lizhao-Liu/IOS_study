#
# Be sure to run `pod lib lint YMMBridgeLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMMBridgeLib'
  s.version          = '1.9.2'
  s.summary          = 'base bridge module.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
YMM common bridge lib module.
                       DESC

  s.homepage         = 'https://code.ymmoa.com/iOSYmm/YMMBridgeLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '陈小辉' => 'wyyincheng@163.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/YMMBridgeLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.swift_version = '5.0'
  
  s.source_files = 'YMMBridgeLib/Classes/**/*'
  s.public_header_files = 'YMMBridgeLib/Classes/**/*.h'
  
  # s.resource_bundles = {
  #   'YMMBridgeLib' => ['YMMBridgeLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'}
  s.user_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }


  
end
