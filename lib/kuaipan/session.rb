# conding: utf-8
module Kuaipan
  class Session
    extend Forwardable
    attr_reader :authorize_url,:base, :consumer
    def_delegators :base, :account_info, :upload_file, 
                   :create_folder, :delete, :metadata, 
                   :copy, :download_file, :thumbnail, 
                   :shares, :move, :document_view
    def_delegators :authorize_url, :[]
    
    def initialize(opt={})
      oauth_callback = opt.delete(:oauth_callback)
      @consumer = KAuth::Consumer.new(Config[:oauth_consumer_key], 
                                      Config[:oauth_consumer_secret], 
                                      Config.options_base)
      # get rtoken
      begin
        rtoken = @consumer.get_request_token(oauth_callback)
        @base = Base.new(@consumer)
        # set authorize_url
        @authorize_url = {authorize_url: "#{ Config[:authorize_url] }&oauth_token=#{ rtoken }"}
      rescue KAuth::KAuthError => myKauthError
        KpErrors.raise_errors(myKauthError.res)
      end
    end

    def set_atoken(oauth_verifier)
      # set accesstoken
      begin
        @consumer.set_atoken(oauth_verifier)
        {oauth_token: @consumer.oauth_token,
         oauth_token_secret: @consumer.oauth_token_secret,
         user_id: @consumer.user_id}
      rescue KAuth::KAuthError => myKauthError
        KpErrors.raise_errors(myKauthError.res)
      end
    end
    
    def get_oauth_result
      {oauth_token: @consumer.oauth_token,
       oauth_token_secret: @consumer.oauth_token_secret,
       user_id: @consumer.user_id}
    end
    
    def self.skip_oauth_session(oauth_token, oauth_token_secret, user_id, opts={})
      session = Session.new(opts)
      session.consumer.oauth_token = oauth_token
      session.consumer.oauth_token_secret = oauth_token_secret
      session.consumer.user_id = user_id
      session
    end
  end
end
