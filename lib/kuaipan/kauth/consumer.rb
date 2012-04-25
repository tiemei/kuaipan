require 'json'
require 'rest_client'
# std-lib
require 'base64'
require 'openssl'
require 'rest_client'
require 'net/http'

module KAuth
  class Consumer
    attr_reader :oauth_token
    def initialize(ctoken, csecret, opts={})
      @oauth_consumer_secret = csecret
      @base_url = opts.delete :site
      @rtoken_path = opts.delete :rtoken_path
      @atoken_path = opts.delete :atoken_path
      @options={
        :oauth_signature_method => 'HMAC-SHA1',
        :oauth_version => '1.0',
        :oauth_consumer_key => ctoken,
      }.merge(opts)
    end

    def get_request_token(oauth_callback=nil)
      @oauth_callback = oauth_callback
      p '-----------> get rtokne'
      body = ''
      if oauth_callback
        body = get_ssl @rtoken_path, :oauth_callback=>oauth_callback
      else 
        body = get_ssl @rtoken_path
      end
      hash = JSON.parse body
      hash.each do |pair|
        instance_variable_set '@'+pair[0], pair[1]
      end
      hash['oauth_token']
    end

    def set_atoken(oauth_verifier)
      body = get_ssl @atoken_path, {:oauth_token => @oauth_token,
        :oauth_verifier => oauth_verifier
        }
      hash = JSON.parse body
      hash.each do |pair|
        instance_variable_set '@'+pair[0], pair[1]
      end
    end
      
    def get_ssl(path, opts={})
      get('https://', path, opts)
    end

    def get_no_ssl(path, opts={})
      get('http://', path, opts)
    end
    def post(pre, path, file, opts={})
      url = pre+@base_url+path
      params = get_params 'POST', url, opts 
      uri = URI.encode_www_form params
      RestClient.post(uri.to_s, :my_file => file)
    end
    def get(pre, path, opts={})
      url = pre+@base_url + path
      params = get_params 'GET', url, opts
      uri = URI(url)
      uri.query = URI.encode_www_form params
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = uri.scheme == 'https'
      http.ca_file = "/etc/ssl/certs/ca-bundle.trust.crt"
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      p response.body
      body = response.body if response.is_a?(Net::HTTPSuccess)
    end

    # otps-params besides oauth_params
    def get_params(http_method, url, opts={})
      params = get_base_params.merge(opts)     
      params[:oauth_signature] = get_oath_signature Consumer.get_base_string(params, url, http_method)
      params
    end
    private 
      def self.get_base_string(params, url, http_method)
        param_str_arr = []
        params.sort.each do |pair|
          param_str_arr << urlencode(pair[0].to_s)+"="+urlencode(pair[1].to_s)  end
        p "#{http_method}&#{urlencode url}&#{urlencode param_str_arr.join('&')}"
      end
      def get_base_params
        {
          :oauth_nonce => "xcWcZhCNKFJ#{Random.new().rand(1000)}",
          :oauth_timestamp => "#{Time.new.to_i}"
        }.merge(@options)
      end
    
      # 生成签名算法
      def get_oath_signature(base_str)
        key = @oauth_consumer_secret+'&'
        key += @oauth_token_secret if base_str.include? 'oauth_token'
        Base64.encode64("#{OpenSSL::HMAC.digest('sha1',key, base_str)}").chomp
      end

      def self.urlencode(str)
        # 下面两种方式均可
        #str.gsub(/([^A-Za-z0-9\-._~])/)do |s|
          #a = []
          #s.bytes.to_a.each{|i|  a << ("%%%02X" % i)}
          #a.join
        #end
        URI.escape(str, /([^A-Za-z0-9\-._~])/)
      end
  end
end
