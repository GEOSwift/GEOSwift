Pod::Spec.new do |s|

  s.name         = "Humboldt"
  s.version      = "0.0.1"
  s.summary      = "Topography made simple, in Swift"

  s.description  = <<-DESC
                   A longer description of Humboldt in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/andreacremaschi/Humboldt"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrea Cremaschi" => "andreacremaschi@libero.it" }
  s.social_media_url   = "http://twitter.com/andreacremaschi"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/andreacremaschi/Humboldt.git" }
  s.source_files  = "Humboldt"
  s.dependency "geos" #, "~> 3.4.2"

end
