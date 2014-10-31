Gem::Specification.new do |s|
  s.name        = 'tutum'
  s.version     = '0.2'
  s.date        = '2014-08-06'
  s.summary     = "Ruby interface for the tutum PaaS API."
  s.description = "Provides HTTP functionality wrapped in a nice ruby interface."
  s.authors     = ["Martyn Garcia", "Mikkel Garcia"]
  s.email       = 'martyn@255bits.com'
  s.files       = Dir.glob("lib/*.rb")
  s.homepage    = 'https://github.com/255BITS/ruby-tutum'
  s.license     = 'MIT'
  s.add_runtime_dependency 'httparty', '~> 0.13.1'
end
