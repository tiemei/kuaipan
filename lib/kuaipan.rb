# conding: utf-8
require 'forwardable'
require 'json'
require 'net/http'

require 'kuaipan/config'
require 'kuaipan/session'
require 'kuaipan/base'
require 'kuaipan/errors'

# kauth-kuaipan oauth implement by myself
require 'kuaipan/kauth/consumer'

module Kuaipan
  module OpenAPI

    def input_config(consumer_token, consumer_secret, p={})
      Kuaipan::Config.opts(consumer_token, consumer_secret, p)
    end

    def g_session(opt={})
      Kuaipan::Session.new(opt)
    end
  end


  class InnerLogicalError     < KpErrors; end # 202
  class BadRequest            < KpErrors; end # 400
  class Unauthorized          < KpErrors; end # 401
  class Forbidden             < KpErrors; end # 403
  class NotFound              < KpErrors; end # 404
  class NotAcceptable         < KpErrors; end # 406
  class RequestEntityTooLarge < KpErrors; end # 413
  class InternalServerError   < KpErrors; end # 500
  class OverSpace             < KpErrors; end # 507
  class ServerError           < KpErrors; end # 500..505
  class UnknownError          < KpErrors; end # other
  class NoTypeError           < KpErrors; end # documentView no type
  class NoViewError           < KpErrors; end # documentView no view
end
