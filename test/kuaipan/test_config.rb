require 'kuaipan'
require 'test/unit'

class ConfigTest < Test::Unit::TestCase
  def test_attrs
    ctoken,csecret,p = '123', '321!', {:http_method => 'POST'}
    Kuaipan::Config.opts ctoken, csecret, p
    assert_equal ctoken, Kuaipan::Config.ctoken
    assert_equal csecret, Kuaipan::Config.csecret
    assert_equal 'POST', Kuaipan::Config.options[:http_method]
    assert_equal ctoken, Kuaipan::Config.options[:oauth_consumer_key]
    assert_equal ctoken, Kuaipan::Config[:oauth_consumer_key]
  end
end
