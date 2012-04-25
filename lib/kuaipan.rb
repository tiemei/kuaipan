require 'forwardable'

require 'kuaipan/config'
require 'kuaipan/session'
require 'kuaipan/base'


# kauth-kuaipan oauth implement by myself
require 'kuaipan/kauth/consumer'

module Kuaipan
  module OpenAPI
    def input_config(consumer_token, consumer_secret, p={})
      Kuaipan::Config.opts consumer_token, consumer_secret, p
    end
    def g_session(opt={})
      Kuaipan::Session.new opt
    end
  end
end
