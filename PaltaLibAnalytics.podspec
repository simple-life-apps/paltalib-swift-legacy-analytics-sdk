Pod::Spec.new do |spec|
  spec.name                  = 'PaltaLibAnalytics'
  spec.version               = "2.6.0"
  spec.license               = 'MIT'
  spec.summary               = 'PaltaLib iOS SDK - Analytics'
  spec.homepage              = 'https://github.com/Palta-Data-Platform/paltalib-swift-legacy-analytics-sdk'
  spec.author                = { "Palta" => "dev@palta.com" }
  spec.source                = { :git => 'https://github.com/Palta-Data-Platform/paltalib-swift-legacy-analytics-sdk.git', :tag => "#{spec.version}" }
  spec.requires_arc          = true
  spec.static_framework      = true
  spec.ios.deployment_target = '11.0'
  spec.swift_versions        = '5.3'

  spec.source_files = 'Sources/Analytics/**/*.swift'

  spec.dependency 'PaltaCore', '>= 3.0.2'
  spec.dependency 'Amplitude', '>= 8.16.4'
end

