
Pod::Spec.new do |s|

  s.name         = "PPNetworkHelper"
  s.version      = "0.2.5"
  s.summary      = "对AFNetworking 3.x 与YYCache的二次封装,一句代码搞定数据请求与缓存,告别FMDB!"

  s.homepage     = "https://github.com/jkpang/PPNetworkHelper.git"
 
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "jkpang" => "jkpang@outlook.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/jkpang/PPNetworkHelper.git", :tag => s.version.to_s }

  s.source_files = "PPNetworkHelper/PPNetworkHelper/*.{h,m}"
  
  s.dependency 'AFNetworking'

  s.dependency 'YYCache'

  s.requires_arc = true

end
