#
# Be sure to run `pod lib lint MBBridgeLibDebug.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBBridgeLibDebug'
  s.version          = '0.5.0'
  s.summary          = 'A short description of MBBridgeLibDebug.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/常贤明/YMMBridgeLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '常贤明' => 'xianming.chang@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/YMMBridgeLib.git', :tag => "MBBridgeLibDebug_#{s.version.to_s}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MBBridgeLibDebug/Classes/**/*'
  s.dependency 'YMMBridgeLib', '~> 1.8'
  s.dependency 'YMMModuleLib', '~> 0.19'
  s.dependency 'Masonry', '~> 1.1'
  s.dependency 'MBUIKit', '~> 0.8'
  s.dependency 'MBFoundation', '~> 0.4'
  s.dependency 'MBDebugService', '~> 0.5'
  s.dependency 'MBDebug/MonitorTools', "~> 3.2"
  s.dependency 'MBDoctorService', '~> 0.10'
  
  # s.resource_bundles = {
  #   'MBBridgeLibDebug' => ['MBBridgeLibDebug/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
