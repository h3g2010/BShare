Pod::Spec.new do |s|
  s.name         = "BShare"
  s.version      = "0.1"
  s.summary      = "Lavatech common libs, this lib just use for our internal projects."
  s.homepage     = "http://github.com/baboy/BShare"
  s.author       = { "baboy" => "baboyzyh@gmail.com" }
  s.source       = { :git => "https://github.com/baboy/BShare.git", :tag => "0.1" }
  s.platform     = :ios

  s.source_files = 'BShare/Classes/*.{h,m}'

  s.subspec 'base' do |base|
	base.source_files = 'BShare/Classes/base'
  end
  s.subspec 'modules' do |mod|
	mod.source_files = 'BShare/Classes/modules'
	mod.subspec 'share' do |share|
		share.source_files = 'BShare/Classes/modules/share'
	end
  end

  s.frameworks = 'UIKit', 'QuartzCore', 'CFNetwork', 'AVFoundation', 'CoreFoundation', 'CoreGraphics', 'Security', 'AudioToolbox', 'MediaPlayer', 'MobileCoreServices', 'SystemConfiguration', 'CoreMedia', 'Mapkit', 'CoreLocation', 'MessageUI', 'ImageIO'

  s.libraries   = 'sqlite3.0', 'xml2', 'icucore', 'z'

end
