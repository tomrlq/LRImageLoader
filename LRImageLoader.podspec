
Pod::Spec.new do |s|

  s.name         = "LRImageLoader"
  s.version      = "0.2.3"
  s.summary      = "An image loading and caching library"
  s.description  = <<-DESC
  LRImageLoader is an image loading and caching library
                   DESC
  s.homepage     = "https://github.com/tomrlq/LRImageLoader"
  s.license      = "MIT"
  s.author             = { "Ruan Lingqi" => "tomrlq@foxmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tomrlq/LRImageLoader.git", :tag => "#{s.version}" }
  s.source_files  = "LRImageLoader/LRImageLoader/LRImageLoader.h"
  s.public_header_files = "LRImageLoader/LRImageLoader/LRImageLoader.h"
  s.requires_arc = true

  s.subspec 'Core' do |ss|
    ss.source_files = 'LRImageLoader/LRImageLoader/*.{h,m}'
    ss.exclude_files = 'LRImageLoader/LRImageLoader/LRImageLoader.h'
  end

end
