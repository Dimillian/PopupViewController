#
#  Be sure to run `pod spec lint PopupViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "PopupViewController"
  s.version      = "0.0.4"
  s.summary      = "Drop in replacement of UIAlertController with customization options"
  s.description  = <<-DESC
  Drop in replacement of UIAlertController with customization options"
                   DESC
  s.homepage     = "https://github.com/Dimillian/PopupViewController/"

  s.license      = "MIT"
  s.author             = { "Thomas Ricouard" => "ricouard77@gmail.com" }
  s.social_media_url   = "http://twitter.com/dimillian"

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/Dimillian/PopupViewController.git", :tag => "#{s.version}" }
  s.source_files  = "PopupViewController/PopupViewController/*.swift"

  s.dependency "Cartography", "~> 0.6"

end
