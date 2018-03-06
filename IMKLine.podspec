Pod::Spec.new do |s|
  s.name         = "IMKLine"
  s.version      = "0.8.0"
  s.summary      = "iOS-Swift-K线：K线主副图、趋势图、成交量、滚动、放大缩小、MACD、KDJ等"
  s.homepage     = "https://github.com/GitHub-Life/IMKLine"
  s.screenshots  = "https://raw.githubusercontent.com/GitHub-Life/IMKLine/imoon/picture/composite_demo.gif"
  s.license      = { :type => "MIT" }
  s.author       = { "iMoon" => "wantao1993@vip.qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/GitHub-Life/IMKLine.git", :commit => "10d2664" }
  s.source_files = "IMKLine/IMKLine/**/*.swift"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.dependency "SnapKit"

end
