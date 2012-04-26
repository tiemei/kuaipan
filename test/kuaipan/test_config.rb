require 'kuaipan'
require 'test/unit'

class ConfigTest < Test::Unit::TestCase
  def test_attrs
    ckey,csecret,p = '123', '321!', {:root => 'kuaipan'}
    Kuaipan::Config.opts ckey, csecret, p
    assert_equal csecret, Kuaipan::Config[:oauth_consumer_secret]
    assert_equal ckey, Kuaipan::Config[:oauth_consumer_key]
    assert_equal 'kuaipan', Kuaipan::Config[:root]
  end
end
