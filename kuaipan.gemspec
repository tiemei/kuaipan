Gem::Specification.new do |s|
  s.name = 'kuaipan'
  s.version = '0.0.1.beta.1'
  s.date = '2012-04-26'
  s.summary = "Kuaipan openapi ruby-sdk"
  s.description = "With it , you can develop apps which connect to kuaipan@kingsofg"
  s.authors = ["tiemei"]
  s.email = 'jiadongkai@gmail.com'
  s.files = [
    "lib/kuaipan.rb", 
    "lib/kuaipan/base.rb",
    "lib/kuaipan/config.rb",
    "lib/kuaipan/session.rb",
    "lib/kuaipan/kauth/consumer.rb",
    "Rakefile",
    "README.md",
    "Gemfile",
    "Gemfile.lock",
    "kuaipan.gemspec",
    "test/test_client.rb",
    "test/kuaipan/test_base.rb",
    "test/kuaipan/test_config.rb",
    "test/kuaipan/test_oauth.rb"
    ]
  s.require_paths = ["lib"]
#s.executables << 'hola_tiemei'
  s.homepage = 'http://rubygems.org/gems/kuaipan'
end
