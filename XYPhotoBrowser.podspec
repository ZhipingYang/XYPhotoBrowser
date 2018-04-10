#
# Be sure to run `pod lib lint XYPhotoBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XYPhotoBrowser'
  s.version          = '0.1.0'
  s.summary          = '照片库浏览库，主要用于新闻资讯图片浏览'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhipingyang/XYPhotoBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XcodeYang' => 'xcodeyang@gmail.com' }
  s.source           = { :git => 'https://github.com/zhipingyang/XYPhotoBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = [
   "CLPhotoBrowserClass/**/*.{h,m}",
  ]
  s.public_header_files = [
  "CLPhotoBrowserClass/**/*.h",
  ]
  s.resources = [
  "CLPhotoBrowserClass/constant/*.bundle"
  ]
  
  s.frameworks = 'UIKit', 'Photos', 'AVFoundation', 'AssetsLibrary', 'AVKit'

end
