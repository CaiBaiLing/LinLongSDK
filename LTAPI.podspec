#
# Be sure to run `pod lib lint LTAPI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LTAPI'
  s.version          = '2.4.19'
  s.summary          = 'A short description of LTAPI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Jock-Z/TudouSDK.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xchhIos' => 'maohx@86lang.com' }
  s.source           = { :git => 'https://github.com/Jock-Z/TudouSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'LTAPI/Classes/**/*'#组件文件路径
  s.resource_bundles = {
      'LTSDK' => ['LTAPI/Assets/*.{png,html}']
  }
  #s.info_plist = {
   #   'CFBundleIdentifier' => 'com.jiujiuxchh.live.LTAPI',
    #  'MY_VAR' => 'SOME_VALUE'
  #}
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.prefix_header_contents = '#import "Masonry.h"','#import "OpenUDID.h"'
  s.public_header_files = 'LTAPI/Classes/API/PublicHeard/*.h'
  #s.frameworks = 'StoreKit', 'SystemConfiguration','UIKit'
  #s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'OpenUDID', '~> 1.0.0'
  s.dependency 'Masonry','~>1.1.0'
  
end
