Pod::Spec.new do |s|

  s.name         = "GEOS.swift"
  s.version      = "0.0.1"
  s.summary      = "The Open Source Geographic Engine, in Swift."

  s.description  = <<-DESC
                  Handle all kind of geographic objects (points, linestrings, polygons etc.) and all related topographic operations (intersections, overlapping etc.). GEOS.swift is basically a MIT-licensed Swift interface to the OSGeo's GEOS library routines*, plus some convenience features for iOS developers.
                   DESC

  s.homepage     = "https://github.com/andreacremaschi/GEOS.swift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrea Cremaschi" => "andreacremaschi@libero.it" }
  s.social_media_url   = "http://twitter.com/andreacremaschi"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/andreacremaschi/GEOS.swift.git" }
  s.source_files  = "Humboldt"
  s.dependency "geos" #, "~> 3.4.2"

end
