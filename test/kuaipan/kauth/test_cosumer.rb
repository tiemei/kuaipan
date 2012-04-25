require 'kuaipan'
require 'test/unit'

class ConsumerTest < Test::Unit::TestCase
  def test_all
    consumer = KAuth::Consumer.new '',''
    assert_nil consumer.oauth_token
  end
end
