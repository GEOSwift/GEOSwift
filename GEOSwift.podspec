Pod::Spec.new do |s|
  s.name = 'GEOSwift'
  s.version = '4.1.0'
  s.swift_version = '5.0'
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
  s.exclude_files = 'GEOSwift/Bridge.swift'
  s.dependency 'geos', '4.0.1'
end
