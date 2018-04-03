Pod::Spec.new do |s|
  s.name         = "TPGHorizontalMenu"
  s.version      = "1.1.4"
  s.summary      = "Horizontal menu navigation."
  s.description  = "Framework done to improve user experience when navigation through screens."
  s.homepage     = "https://github.com/3pillarlabs/ios-horizontalmenu"
  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "3Pillar Global"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/3pillarlabs/ios-horizontalmenu.git", :tag => "#{s.version}" }
  s.source_files = "Sources", "Sources/**/*.{h,m, swift}"
end
