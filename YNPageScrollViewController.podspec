#
# Be sure to run `pod lib lint YNPageScrollViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YNPageScrollViewController'
  s.version          = '1.0.0'
  s.summary          = '一个强大的PageScrollViewController滑动库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一个强大的PageScrollViewController滑动库。菜单多种样式选择，支持悬浮样式、导航条样式、顶部样式.旧版半塘首页Demo、简书个人文章Demo.
                       DESC

  s.homepage         = 'https://github.com/yongyuandouneng/YNPageScrollViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZYN' => '1003580893@qq.com' }
  s.source           = { :git => 'https://github.com/yongyuandouneng/YNPageScrollViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'YNPageScrollViewController/Libs/YNPageScrollViewController/*'
  
  # s.resource_bundles = {
  #   'YNPageScrollViewController' => ['YNPageScrollViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
