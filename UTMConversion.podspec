Pod::Spec.new do |s|
  s.name = 'UTMConversion'
  s.version = '1.2.0'
  s.swift_version = '5.0'
  s.cocoapods_version = '>= 1.4.0'
  s.summary = 'Convert between latitude/longitude and the UTM coordinate system.'
  s.description  = <<~DESC
    Convert between latitude/longitude and the UTM (Universal Transverse Mercator) coordinate systems.
    The conversion happens between a custom struct UTMCoordinate and CoreLocation's CLLocationCoordinate2D and CLLocation.
  DESC
  s.homepage = 'https://github.com/wtw-software/UTMConversion'
  s.license = {
    type: 'MIT',
    file: 'LICENSE'
  }
  s.authors = {
    'Peter Ringset' => 'peter.ringset@eggsdesign.com'
  }
  s.ios.deployment_target = '8.0'
  s.source = {
    git: 'https://github.com/wtw-software/UTMConversion',
    tag: s.version
  }
  s.source_files = 'UTMConversion/*.{swift,h}'
end
