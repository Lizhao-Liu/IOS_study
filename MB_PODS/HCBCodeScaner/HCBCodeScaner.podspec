#pod repo push HCBSpecs HCBCodeScaner.podspec --sources='git@git.56qq.com:iOS-Team/HCBSpecs.git,https://github.com/CocoaPods/Specs.git' --use-libraries --allow-warnings

# Be sure to run `pod lib lint HCBCodeScaner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HCBCodeScaner'
  s.version          = '2.2.1'
  s.summary          = '货车帮扫码组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://code.amh-group.com/iOS-Team/HCBCodeScaner'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ping.xiang' => 'ping.xiang@amh-group.com' }
  
  s.source           = { :git => 'git@code.amh-group.com:iOS-Team/HCBCodeScaner.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'HCBCodeScaner/Classes/**/*'

  s.frameworks   = "UIKit", "Foundation", "QuartzCore", "CoreGraphics", "CoreImage", "AVFoundation"

  s.pod_target_xcconfig = {
       'OTHER_LDFLAGS' => '-ObjC -all_load $(inherited)',
       'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64'
  }

  s.resource_bundles = {
    'HCBCodeScaner' => ['HCBCodeScaner/Assets/*.png']
  }  
  
  s.dependency 'MBProgressHUD', '~> 0.9'
  s.dependency 'MBUIKit', '~> 0.1'
  s.dependency 'YMMRouterLib', '~> 0.2'
  s.dependency 'MBDoctorService', '~> 0.1'
  s.dependency 'ScanKitFrameWork', '~> 1.1'
  s.dependency 'YMMModuleLib', '~> 0.19'

end
