# conding: utf-8
module Kuaipan
  class KpErrors < StandardError
    def initialize(data)
      @data = data
      super
    end

    def self.raise_errors(res)
      data = parse(res)
      case res.code.to_i
      when 202
        raise InnerLogicalError.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 400
        raise BadRequest.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 401
        raise Unauthorized.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 403
        raise Forbidden.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 404
        raise NotFound.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 406
        raise NotAcceptable.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 413
        raise RequestEntityTooLarge.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 500
        raise InternalServerError.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 507
        raise OverSpace.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      when 500..505
        raise ServerError.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      else
        raise UnknownError.new(data['msg']), "(#{ res.code }): #{ res.message } - #{ data['msg'] }"
      end
    end
    
    private
      def self.parse(res)
        if res.body
          JSON.parse(res.body)
        else
          {'msg' => ''}
        end
      end
  end
end
