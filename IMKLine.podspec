Pod::Spec.new do |s|
  s.name         = "IMKLine"
  s.version      = "0.8.0"
  s.summary      = "Swift K-Line【Professional】"
  s.homepage     = "https://github.com/GitHub-Life/IMKLine"
  s.screenshots  = "https://raw.githubusercontent.com/GitHub-Life/IMKLine/imoon/picture/composite_demo.gif"
  s.license      = "MIT"
  s.author       = { "iMoon" => "wantao1993@vip.qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/GitHub-Life/IMKLine.git", :tag => "v0.8.0" }
  s.source_files = "IMKLine/**/*.swift"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "SnapKit"

end
