#
# Be sure to run `pod lib lint MBDebugService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBDebugService'
  s.version          = '0.5.4'
  s.summary          = 'A short description of MBDebugService.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'git@code.amh-group.com:iOSYmm/MBDebugService.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'billows' => 'billows.pengt@ymm56.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/MBDebugService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MBDebugService/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MBDebugService' => ['MBDebugService/Assets/*.png']
  # }

  s.public_header_files = 'MBDebugService/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'YMMModuleLib', '~> 0.6'
end
