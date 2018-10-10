Pod::Spec.new do |s|
  s.name = 'GEOSwift'
  s.version = '3.0.1'
  s.swift_version = '4.2'
  s.cocoapods_version = '>= 1.4.0'
  s.summary = 'The Swift Geographic Engine.'
  s.description  = <<~DESC
    Easily handle a geographical object model (points, linestrings, polygons etc.) and related
    topographical operations (intersections, overlapping etc.). A type-safe, MIT-licensed Swift
    interface to the OSGeo's GEOS library routines, nicely integrated with MapKit and Quicklook.
  DESC
  s.homepage = 'https://github.com/GEOSwift/GEOSwift'
  s.license = {
    type: 'MIT',
    file: 'LICENSE'
  }
  s.authors = {
    'Andrea Cremaschi' => 'andreacremaschi@libero.it'
  }
  s.ios.deployment_target = '8.0'
  s.source = {
    git: 'https://github.com/GEOSwift/GEOSwift.git',
    tag: s.version
  }
  s.source_files = 'GEOSwift/*.{swift,h}'
  s.dependency 'geos', '3.7.0'
end
