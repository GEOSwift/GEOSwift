Pod::Spec.new do |s|
  s.name = 'GEOSwift'
  s.version = '10.3.0'
  s.swift_version = '5.5'
  s.cocoapods_version = '~> 1.10'
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
  s.platforms = {
    ios: '9.0',
    osx: '10.9',
    tvos: '9.0',
    watchos: '2.0',
  }
  s.source = {
    git: 'https://github.com/GEOSwift/GEOSwift.git',
    tag: s.version,
  }
  s.source_files = 'Sources/**/*.swift'
  s.dependency 'geos', '~> 8.1'
end
