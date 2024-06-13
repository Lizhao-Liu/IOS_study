#
# Be sure to run `pod lib lint MBAPMServiceLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBAPMServiceLib'
  s.version          = '0.13.3'
  s.summary          = 'A short description of MBAPMServiceLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://code.amh-group.com/iOSYmm/MBAPMLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiangping' => 'ping.xiang@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/MBAPMLib.git', :tag => "MBAPMServiceLib_#{s.version.to_s}"}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64','CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'}
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'}
  
  s.source_files = 'MBAPMServiceLib/Classes/**/*'
  # s.compiler_flags = '$(inherited)'
  # s.resource_bundles = {
  #   'MBAPMServiceLib' => ['MBAPMServiceLib/Assets/*.png']
  # }

  #s.public_header_files = 'MBAPMServiceLib/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'YMMModuleLib', '~> 0.5'
end
