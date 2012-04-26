module Kuaipan
  module Config
    class << self
      extend Forwardable
      def_delegators :options, :[]
      attr_accessor :options
      def opts(consumer_key, consumer_secret, p={})
        Config.options = {
          :oauth_consumer_secret => consumer_secret,
          :oauth_consumer_key => consumer_key,
          :root => 'app_folder',
          :oauth_signature_method => 'HMAC-SHA1',
          :oauth_version => '1.0',

          :site => 'openapi.kuaipan.cn',
          :thum_doc_site => 'conv.kuaipan.cn',
          :up_down_file_stie => 'api-content.dfs.kuaipan.cn',
          :rtoken_path => '/open/requestToken',
          :atoken_path => '/open/accessToken',
          :authorize_url => 'https://www.kuaipan.cn/api.php?ac=open&op=authorise',

          :account_info_path => '/account_info',
          :metadata_path => '/metadata',
          :shares_path => '/shares'
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
