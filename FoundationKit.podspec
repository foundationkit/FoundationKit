Pod::Spec.new do |s|
  s.name     = 'FoundationKit'
  s.version  = '0.5'
  s.license  = 'MIT'
  s.summary  = 'Everything that really should be in CoreFoundation, but is not.'
  s.homepage = 'http://foundationk.it'
  s.authors  = { 'Erik Aigner' 		   => 'erik@chocomoko.com',
                 'Martin Schürrer'     => 'martin@schuerrer.org',
                 'Peter Steinberger'   => 'foundationkit@petersteinberger.com',
                 'Matthias Tretter'    => 'myell0w@me.com' }
  s.source   = { :git => 'https://github.com/foundationkit/FoundationKit.git', :tag => '0.5' }
  s.description = 'Consider FoundationKit Foundations big brother. We add lots of useful '   \
                  'categories, helpers, classes and macros. '                                \
                  'FoundationKit is built With ARC for both for iOS 4.0+ and Mac OS 10.6+. ' \
                  'If you start a new app today, it is the perfect time to begin with it.'
  s.source_files = 'Sources', 'Sources/**/*.{h,m}'
  s.frameworks = 'CoreGraphics', 'Foundation'
  s.requires_arc = true
end
