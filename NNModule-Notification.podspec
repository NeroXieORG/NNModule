#
# Be sure to run `pod lib lint WKWebViewJSBridge.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NNModule-Notification'
  s.version          = '1.0.0'
  s.summary          = 'NNModule extension on notifications.'
  s.homepage         = 'https://github.com/YiHuaXie/NNModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YiHuaXie' => 'xyh30902@163.com' }
  s.source           = { :git => 'https://github.com/YiHuaXie/NNModule.git', :tag => s.version.to_s }

  s.source_files     = ['NNModule/StickyNotification/*', 'NNModule/EventTransfer/*']

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
end
