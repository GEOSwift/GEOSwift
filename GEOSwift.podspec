Pod::Spec.new do |s|
  s.name = 'GEOSwift'
  s.version = '11.2.0'
  s.swift_version = '5.9'
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
  s.ios.deployment_target = '12.0'
  s.macos.deployment_target = '10.13'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '4.0'
  s.source = {
    git: 'https://github.com/GEOSwift/GEOSwift.git',
    tag: s.version,
  }
  s.source_files = 'Sources/**/*.swift'
  s.dependency 'geos', '~> 9.0'
end
