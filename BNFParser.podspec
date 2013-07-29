#
# Be sure to run `pod spec lint BNFParser.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "BNFParser"
  s.version      = "1.0"
  s.summary      = "BNFParser is a grammar parsing and validation framework based on the Backus-Naur Form pattern."
  s.homepage     = "https://github.com/mfriesen/BNFParser"
  s.author       = { "Mike Friesen" => "mfriesen@gmail.com" }
  s.source       = { :git => "https://github.com/mfriesen/BNFParser.git", :tag => "1.0" }
  s.platform     = :osx, '10.8'
  s.source_files = 'BNFParser', 'BNFParser/**/*.{h,m}'
  s.resources  = "*.bnf"
  s.requires_arc = false
end