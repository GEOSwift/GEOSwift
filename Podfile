platform :ios, '8.0'

use_frameworks!

target 'GEOSwift' do
  pod 'geos', '3.7.1'
end

target 'GEOSwiftTests' do
  pod 'geos', '3.7.1'
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
