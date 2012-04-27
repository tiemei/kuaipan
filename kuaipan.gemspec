Gem::Specification.new do |s|
  s.name = 'kuaipan'
  s.version = '0.0.1.beta.11'
  s.date = '2012-04-27'
  s.summary = "Kuaipan openapi ruby-sdk"
  s.description = "Kuaipan openAPI! With it , you can develop apps which connect to kuaipan@kingsoft"
  s.authors = ["tiemei"]
  s.email = 'jiadongkai@gmail.com'
  s.files = [
    "lib/kuaipan.rb", 
    "lib/kuaipan/base.rb",
    "lib/kuaipan/config.rb",
    "lib/kuaipan/session.rb",
    "lib/kuaipan/kauth/consumer.rb",
    "Rakefile",
    "README.rdoc",
    "Gemfile",
    "Gemfile.lock",
    "kuaipan.gemspec",
    "test/test_client.rb",
    "test/kuaipan/test_base.rb",
    "test/kuaipan/test_config.rb",
    ]
  s.require_paths = ["lib"]
#s.executables << 'hola_tiemei'
  s.homepage = 'http://rubygems.org/gems/kuaipan'
end
