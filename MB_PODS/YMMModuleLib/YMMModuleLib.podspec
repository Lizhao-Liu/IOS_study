#
# Be sure to run `pod lib lint YMMModuleLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "YMMModuleLib"
  s.version = "0.19.7"
  s.summary = "运满满模块化基础库"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description = <<-DESC
                    运满满模块化基础库
                       DESC

  s.homepage = "http://code.amh-group.com/iOSYmm/YMMModuleLib"
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "xiaohui.chen" => "xiaohui.chen@amh-group.com" }
  s.source = { :git => "git@code.amh-group.com:iOSYmm/YMMModuleLib.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = "10.0"
  s.swift_version = "5.0"
  s.requires_arc = true
  s.static_framework = true


  s.source_files = "YMMModuleLib/Classes/**/*"

  # s.resource_bundles = {
  #   'YMMModuleLib' => ['YMMModuleLib/Assets/*.png']
  # }
  s.public_header_files = "YMMModuleLib/Classes/**/*.h"
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency "YMMRouterLib", "~> 0.25"
  s.dependency "MBBuildPreLib", "~> 0.1"
  s.dependency 'MBFoundation', '~> 0.3'
  s.pod_target_xcconfig = { "VALID_ARCHS[sdk=iphonesimulator*]" => "x86_64" }
end
