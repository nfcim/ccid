#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ccid.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ccid'
  s.version          = '0.1.1'
  s.summary          = 'Flutter CCID Plugin.'
  s.description      = <<-DESC
A Flutter plugin for CCID support on iOS.
                       DESC
  s.homepage         = 'http://nfc.im'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'nfcim' => 'info@nfc.im' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
