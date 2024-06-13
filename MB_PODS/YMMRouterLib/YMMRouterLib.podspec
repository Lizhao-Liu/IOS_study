#
# Be sure to run `pod lib lint YMMRouterLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMMRouterLib'
  s.version          = '0.45.2-beta3'
  s.summary          = 'A short description of YMMRouterLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://code.amh-group.com/iOSYmm/YMMRouterLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '向平' => 'ping.xiang@amh-group.com' }
  s.source           = { :git => 'git@code.amh-group.com:iOSYmm/YMMRouterLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  
  s.default_subspec = 'RouterMatch', 'RouterIntent', 'Navigator'
  s.subspec 'RouterMatch' do |ss|
    ss.source_files = 'YMMRouterLib/Classes/**/*'
    ss.private_header_files = 'YMMRouterLib/Classes/YMMRouterHandlerFilter.h'
    ss.exclude_files = 'YMMRouterLib/Classes/RouterIntent/**/*', 'YMMRouterLib/Classes/Navigator/**/*'
  end
  
  s.subspec 'RouterIntent' do |ss|
    ss.source_files = 'YMMRouterLib/Classes/RouterIntent/**/*'
  end
  s.subspec 'Navigator' do |ss|
    ss.source_files = 'YMMRouterLib/Classes/Navigator/**/*'
    ss.private_header_files = 'YMMRouterLib/Classes/Navigator/MBNavManager_Private.h', 'YMMRouterLib/Classes/Navigator/MBNavRouterInterceptor.h', 'YMMRouterLib/Classes/Navigator/MBNavTransitionBuilder_Private.h', 'YMMRouterLib/Classes/Navigator/MBNavContainerTransition.h', 'YMMRouterLib/Classes/Navigator/MBNavContainerTransitionBuilder.h'
    ss.dependency "MBUIKit", '~> 0.9', '>= 0.9.2'
  end
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
