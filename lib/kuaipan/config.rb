module Kuaipan
  module Config
    class << self
      extend Forwardable
      def_delegators :options, :[]
      attr_accessor :ctoken, :csecret, :options
      def opts(consumer_token, consumer_secret, p={})
        Config.ctoken, Config.csecret = consumer_token, consumer_secret
        Config.options = {
        :oauth_signature_method => 'HMAC-SHA1',
        :oauth_version => '1.0',
        :oauth_consumer_key => consumer_token,
        :site => 'openapi.kuaipan.cn',
        :rtoken_path => '/open/requestToken',
        :atoken_path => '/open/accessToken',
        :authorize_url => 'https://www.kuaipan.cn/api.php?ac=open&op=authorise',
        :account_info_path => '/account_info',
        :upload_locate_path => '/fileops/upload_locate'
        }.merge(p)
      end
      def options_base
        {
          :oauth_signature_method => Config.options[:oauth_signature_method],
          :oauth_version => Config.options[:oauth_version],
          :oauth_consumer_key => Config.options[:oauth_consumer_key],
          :rtoken_path => Config.options[:rtoken_path],
          :atoken_path => Config.options[:atoken_path],
          :site => Config.options[:site]
        }
      end
    end
  end
end
