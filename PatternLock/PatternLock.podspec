#
# Be sure to run `pod lib lint PatternLock.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PatternLock'
  s.version          = '0.1.0'
  s.summary          = 'A library to support android-like pattern lock in iOS projects'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 A library to support android-like pattern lock in iOS projects. It supports 2 modes create pattern mode and validate pattern mode
                       DESC

  s.homepage         = 'https://github.com/jubinjacob19/PatternLock'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jubinjacob19' => 'jubinjacob19@gmail.com' }
  s.source           = { :git => 'https://github.com/jubinjacob19/PatternLock.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PatternLock/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PatternLock' => ['PatternLock/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
