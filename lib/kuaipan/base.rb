require 'json'

module Kuaipan
  class Base
    attr_reader :oauth_token

    def initialize(consumer)
      @consumer = consumer
    end

    def usr_info 
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+Config[:account_info_path], {:oauth_token => @consumer.oauth_token}
      p body.to_s
      JSON.parse body
    end
    def metadata

    end
    def upload_locate
      
    end
# .......
  end
end
