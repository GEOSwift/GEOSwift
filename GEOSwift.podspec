Pod::Spec.new do |s|

  s.name         = "GEOS.swift"
  s.version      = "0.1"
  s.summary      = "The Swift Geographic Engine."

  s.description  = <<-DESC
Easily handle a geographical object model (points, linestrings, polygons etc.) and related topographical operations (intersections, overlapping etc.). 
A type-safe, MIT-licensed Swift interface to the OSGeo's GEOS library routines, nicely integrated with MapKit and Quicklook.
DESC

  s.homepage     = "https://github.com/andreacremaschi/GEOS.swift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrea Cremaschi" => "andreacremaschi@libero.it" }
  s.social_media_url   = "http://twitter.com/andreacremaschi"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/andreacremaschi/GEOS.swift.git", :tag => "0.1" }
  s.source_files = "GEOSwift"
  s.dependency "geos", "~> 3.4.2"

end
