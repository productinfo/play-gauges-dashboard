#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "GaugesDashboard"
  s.version          = '0.1.1'
  s.summary          = "A gauges dashboard demo"
  s.description      = <<-DESC
                       A gauges dashboard for the featured gallery
                       DESC
  s.homepage         = "http://www.shinobicontrols.com"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "Alison Clarke" => "aclarke@scottlogic.co.uk" }
  s.source           = { :git => "https://bitbucket.org/shinobicontrols/play-gauges-dashboard.git", 
                         :tag => s.version.to_s,
                         :submodules => true 
                       }
  s.social_media_url = 'https://twitter.com/shinobicontrols'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'GaugesDashboard/GaugesDashboard/**/*.{h,m}'
  s.dependency 'ShinobiPlayUtils'
  s.resources = ['GaugesDashboard/**/*.storyboard', 'GaugesDashboard/**/*.xib', 'GaugesDashboard/**/*.xcassets', 'GaugesDashboard/**/GaugesDashboardRoomData.plist']
  s.frameworks = 'QuartzCore', 'ShinobiGauges'
  s.xcconfig     = { 'FRAMEWORK_SEARCH_PATHS' => '"$(DEVELOPER_FRAMEWORKS_DIR)" "$(PROJECT_DIR)/../"' }
end
