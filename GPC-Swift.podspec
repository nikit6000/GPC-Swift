
Pod::Spec.new do |s|
  s.name             = 'GPC-Swift'
  s.version          = '0.1.0'
  s.summary          = 'Swift wrapper for GeneralPolygonClipper'

  s.description      = 'Swift wrapper for GeneralPolygonClipper'

  s.homepage         = 'https://github.com/Nikita/GPC-Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nikita' => 'tarhov.nik@gmail.com' }
  s.source           = { :git => 'https://github.com/nikit6000/GPC-Swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'GPC-Swift/Classes/**/*'
end
