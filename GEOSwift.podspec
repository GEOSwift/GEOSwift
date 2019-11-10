Pod::Spec.new do |s|
  s.name = 'GEOSwift'
  s.version = '6.0.0'
  s.swift_version = '5.1'
  s.cocoapods_version = '>= 1.4.0'
  s.summary = 'The Swift Geometry Engine.'
  s.description  = <<~DESC
    Easily handle a geometric object model (points, linestrings, polygons etc.) and related
    topological operations (intersections, overlapping etc.). A type-safe, MIT-licensed Swift
    interface to the OSGeo's GEOS library routines.
  DESC
  s.homepage = 'https://github.com/GEOSwift/GEOSwift'
  s.license = {
    type: 'MIT',
    file: 'LICENSE'
  }
  s.authors = 'Andrea Cremaschi', 'Andrew Hershberger', 'Virgilio Favero Neto'
  s.platforms = { ios: "8.0", osx: "10.9", tvos: "9.0" }
  s.source = {
    git: 'https://github.com/GEOSwift/GEOSwift.git',
    tag: s.version
  }
  s.source_files = 'GEOSwift/**/*.{swift,h}'
  s.dependency 'geos', '~> 4.1'
end
