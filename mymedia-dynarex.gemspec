Gem::Specification.new do |s|
  s.name = 'mymedia-dynarex'
  s.version = '0.1.1'
  s.summary = 'Publish Dynarex files using the MyMedia gem'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('mymedia', '~> 0.1', '>=0.1.1')
  s.signing_key = '../privatekeys/mymedia-dynarex.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/mymedia-dynarex'
end
