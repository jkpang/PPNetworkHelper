
Pod::Spec.new do |s|

  s.name         = "PPNetworkHelper"
  s.version      = "0.8.1"
  s.summary      = "AFNetworking 3.x 与YYCache封装,一句代码搞定数据请求与缓存,告别FMDB!控制台直接打印json中文字符,调试更方便"

  s.homepage     = "https://github.com/jkpang/PPNetworkHelper.git"
 
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "jkpang" => "jkpang@outlook.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/jkpang/PPNetworkHelper.git", :tag => s.version.to_s }

  s.source_files = "PPNetworkHelper/PPNetworkHelper/*.{h,m}"
  
  s.dependency 'AFNetworking', '~> 3.2.0'

  s.dependency 'YYCache', '~> 1.0.4'

  s.requires_arc = true

end
