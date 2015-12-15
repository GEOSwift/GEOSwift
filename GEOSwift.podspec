Pod::Spec.new do |s|

  s.name         = "GEOSwift"
  s.version      = "0.3.1"
  s.summary      = "The Swift Geographic Engine."

  s.description  = <<-DESC
Easily handle a geographical object model (points, linestrings, polygons etc.) and related topographical operations (intersections, overlapping etc.). 
A type-safe, MIT-licensed Swift interface to the OSGeo's GEOS library routines, nicely integrated with MapKit and Quicklook.
DESC

  s.homepage     = "https://github.com/andreacremaschi/GEOSwift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrea Cremaschi" => "andreacremaschi@libero.it" }
  s.social_media_url   = "http://twitter.com/andreacremaschi"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/andreacremaschi/GEOSwift.git", :tag => "0.3.1" }
  
  s.subspec 'Core' do |cs|
    cs.source_files = "GEOSwift/*"
    cs.dependency "geos", "3.5.0"
  end

  # Mapbox support is disabled: MapboxGL is distributed as a static framework and Cocoapods 0.37 doesn't allow to add a static framework as a dependency,
  # failing with this error: "The 'Pods' target has transitive dependencies that include static binaries".
  # This is due to the fact that if a static library gets linked against multiple dynamic frameworks, 
  # we would end up getting duplicate symbols in each of those frameworks.
  # This will be restored when Mapbox will provide a dynamic version of the framework
  # s.subspec 'MapboxGL' do |cs|
  #   cs.source_files = "GEOSwift/MapboxGL"
  #   cs.dependency "GEOSwift/Core"
  #   cs.dependency "Mapbox-iOS-SDK"
  # end

  s.default_subspec = 'Core'

end
