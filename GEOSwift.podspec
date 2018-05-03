Pod::Spec.new do |s|

  s.name         = "GEOSwift"
  s.version      = "2.2.0"
  s.summary      = "The Swift Geographic Engine."

  s.description  = <<-DESC
Easily handle a geographical object model (points, linestrings, polygons etc.) and related topographical operations (intersections, overlapping etc.).
A type-safe, MIT-licensed Swift interface to the OSGeo's GEOS library routines, nicely integrated with MapKit and Quicklook.
DESC

  s.homepage     = "https://github.com/GEOSwift/GEOSwift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrea Cremaschi" => "andreacremaschi@libero.it" }
  s.social_media_url   = "http://twitter.com/andreacremaschi"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/GEOSwift/GEOSwift.git", :tag => s.version }

  s.source_files = "GEOSwift/*.{swift,h}"
  s.dependency "geos", "3.5.0"

end
