# conding: utf-8
module Kuaipan
  class Session
    extend Forwardable
    attr_reader :authorize_url,:base
    def_delegators  :base, :account_info, :upload_file, 
                    :create_folder, :delete, :metadata, 
                    :copy, :download_file, :thumbnail, 
                    :shares, :move
    def_delegators :authorize_url, :[]
    
    def initialize(opt={})
      oauth_callback = opt.delete(:oauth_callback)
      @consumer = KAuth::Consumer.new(Config[:oauth_consumer_key], 
                                      Config[:oauth_consumer_secret], 
                                      Config.options_base)
      # get rtoken
      rtoken = @consumer.get_request_token(oauth_callback)
      @base = Base.new(@consumer)
      # set authorize_url
      @authorize_url = {authorize_url: Config[:authorize_url] + '&oauth_token='+rtoken}
    end

    def set_atoken(oauth_verifier)
      # set accesstoken
      @consumer.set_atoken oauth_verifier
    end
  end
end
