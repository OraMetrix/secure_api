lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'secure_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'secure_api'
  spec.version       = SecureApi::VERSION
  spec.authors       = ['DentsplySirona']
  spec.email         = ['BerlinDEU-SWDev@dentsplysirona.com']
  spec.description   = 'Creates and verifies a time sensitive url safe token'
  spec.summary       = 'Creates and verifies a time sensitive url safe token'
  spec.homepage      = ''
  spec.license       = 'For DentsplySirona use only'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 7.2'

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'minitest', '>= 5.1'
  spec.add_development_dependency 'minitest-mock'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake'
end
