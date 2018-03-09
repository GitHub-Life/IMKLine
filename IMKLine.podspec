Pod::Spec.new do |s|
    s.name         = 'IMKLine'
    s.version      = '1.0.2'
    s.summary      = 'Swift K-Line Professional'
    s.homepage     = 'https://github.com/GitHub-Life/IMKLine'
    s.license      = 'MIT'
    s.authors      = {'iMoon' => 'wantao1993@vip.qq.com'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://github.com/GitHub-Life/IMKLine.git', :tag => s.version}
    s.source_files = 'IMKLine', 'IMKLine/**/*.swift'
    s.requires_arc = true
    s.dependency 'SnapKit'
end
