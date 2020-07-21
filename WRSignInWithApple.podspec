#
# Be sure to run `pod lib lint WRSignInWithApple.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WRSignInWithApple'
  s.version          = '0.9.0'
  s.summary          = 'Sign in with Apple实现。并将userId缓存到钥匙串中。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Sign in with Apple实现。并将userId缓存到钥匙串中。需要在 AppDelegate 中实现 Setup(_ appId: String? = nil) 方法'

  s.homepage         = 'https://github.com/GodFighter/WRSignInWithApple'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GodFighter' => '{xianghui_ios@163.com}' }
  s.source           = { :git => 'https://github.com/GodFighter/WRSignInWithApple.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'WRSignInWithApple/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WRSignInWithApple' => ['WRSignInWithApple/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'AuthenticationServices'
   s.dependency 'WRKeychain', '1.0.0'
end
