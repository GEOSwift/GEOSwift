Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "GEOSwift"
s.summary = "A geoJSON parser library"
s.requires_arc = true

# 2
s.version = "1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Claudio Barbera" => "barbera.claudio@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/cbarbera80/GEOSwift"



# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/cbarbera80/GEOSwift", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"
s.dependency 'geos'
s.dependency 'CocoaLumberjack'
s.dependency 'Mapbox-iOS-SDK'

# 8
s.source_files = "GEOSwift/**/*.{swift}"

# 9
s.resources = "GEOSwift/**/*.{png,jpeg,jpg,storyboard,xib}"
end
