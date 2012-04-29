# conding: utf-8
module Kuaipan
  class Base
    attr_reader :oauth_token

    def initialize(consumer)
      @consumer = consumer
    end

    def account_info
      res =  @consumer.get_no_ssl('account_info')
      parse_response(res)
    end

    def metadata(path ,opts={})
      root = opts[:root] ? opts[:root].to_s : 'app_folder'
      res = @consumer.get_no_ssl("metadata/#{ root }/#{ path }",opts)
      parse_response(res)
    end

    def shares(path, opts={})
      root = opts[:root] ? opts[:root].to_s : 'app_folder'
      res = @consumer.get_no_ssl("shares/#{ root }/#{ path }",opts)
      parse_response(res)
    end

    def move(from_path, to_path, opts={})
      res = @consumer.get_no_ssl('fileops/move',
                                  {from_path: from_path,
                                   to_path: to_path,
                                   root: 'app_folder'}.merge(opts))
      parse_response(res)
    end
    
    def copy(from_path, to_path, opts={})
      res = @consumer.get_no_ssl('fileops/copy',
                                  {from_path: from_path,
                                   to_path: to_path,
                                   root: 'app_folder'}.merge(opts))
      parse_response(res)
    end
    
    def download_file(path, opts={}, &block)
      res = @consumer.get_no_ssl('fileops/download_file',
                                  {root: 'app_folder',
                                   path: path,
                                   site: Config[:up_down_file_stie]}.merge(opts))
      parse_response(res, &block)
    end

    def thumbnail(width, height, path, opts={}, &block)
      res = @consumer.get_no_ssl('fileops/thumbnail',
                                  {width: width,
                                   height: height,
                                   path: path,
                                   root: 'app_folder',
                                   site: Config[:thum_doc_site]}.merge(opts))
      parse_response(res, &block)
    end
    

    def documentView(type, path, opts={},  &block)
      raise NoTypeError.new("No type:#{ type }") if Config[:types].index(type.to_s) == nil
      raise NoViewError("No view:#{ opts[:view] }") if (opts[:views] and (Config[:view].index(opts[:view].to_s) == nil))
      res = @consumer.get_no_ssl('fileops/documentView',
                                 {view: 'normal',
                                  zip: 0,
                                  root: 'app_folder',
                                  path: path,
                                  type: type,
                                  site: Config[:thum_doc_site]
                                 }.merge(opts))
      parse_response(res, &block)
    end

    def upload_locate
      res = @consumer.get_no_ssl('/fileops/upload_locate', 
                                  {site: Config[:up_down_file_stie]})
      parse_response(res)
    end


    def upload_file(file, opts={}) 
      folder = opts[:path]
      opts[:path] = opts[:path] ? "#{ opts[:path] }/#{ File.basename(file.path) }"
                                : File.basename(file.path)  
      opts[:root] =  'app_folder' unless opts[:root]
      create_folder((folder ||= ''), :root => opts[:root])
      body = @consumer.post('fileops/upload_file', 
                            file,
                            {overwrite: 'True', 
                             site: upload_locate['url'],}.merge(opts))
      JSON.parse(body)
    end

    def create_folder(folder, opts={})
      folder = folder.encode('UTF-8')
      return nil if folder.size > 255
      res = @consumer.get_no_ssl('fileops/create_folder', 
                                  {root: 'app_folder',
                                   path: folder}.merge(opts))
      parse_response(res)
    end

    def delete(path, opts={})
      res = @consumer.get_no_ssl('fileops/delete', 
                           {root: 'app_folder',
                            path: path,
                            to_recycle: 'True'}.merge(opts))
      parse_response(res)
    end
      
# .......
    
    private 
      def parse_response(res, &block)
        if res.is_a?(Net::HTTPSuccess)
          if block
            block.call(res)
          else
            JSON.parse(res.body)
          end
        else
          KpErrors.raise_errors(res)
        end
      end
  end
end
