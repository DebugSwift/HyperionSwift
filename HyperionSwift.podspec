Pod::Spec.new do |s|
    s.name             = 'HyperionSwift'
    s.version          = '0.0.1'
    s.summary          = 'A robust toolkit for simplifying and enhancing the debugging process in Swift applications.'
    s.description      = <<-DESC
      HyperionSwift make your debugging process more efficient and effective.
    DESC
    s.homepage         = 'https://github.com/HyperionSwift/HyperionSwift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Matheus Gois' => 'matheusgoislimasilva@gmail.com' }
    s.source           = { :git => 'https://github.com/HyperionSwift/HyperionSwift.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.7'
  
    s.source_files = 'HyperionSwift/Sources/**/*'
    s.resource_bundles = {
      'HyperionSwift' => [
        'HyperionSwift/Resources/*.lproj/*.strings',
      ]
    }
  end