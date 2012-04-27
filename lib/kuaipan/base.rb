# conding: utf-8
require 'json'

module Kuaipan
  class Base
    attr_reader :oauth_token

    def initialize(consumer)
      @consumer = consumer
    end

    def account_info
      body =  @consumer.get_no_ssl('account_info')
      JSON.parse(body)
    end

    def metadata(path ,opts={})
      root = opts[:root] ? opts[:site].to_s : 'app_folder'
      body = @consumer.get_no_ssl("metadata/#{ root }/#{ path }",opts)
      JSON.parse(body)
    end

    def shares(path, opts={})
      root = opts[:root] ? opts[:site].to_s : 'app_folder'
      body = @consumer.get_no_ssl("shares/#{ root }/#{ path }",opts)
      JSON.parse(body)
    end

    def move(from_path, to_path, opts={})
      body = @consumer.get_no_ssl('fileops/move',
                                  {from_path: from_path,
                                   to_path: to_path,
                                   root: 'app_folder'}.merge(opts))
      p body
    end
    
    def copy(from_path, to_path, opts={})
      body = @consumer.get_no_ssl('fileops/copy',
                                  {from_path: from_path,
                                   to_path: to_path,
                                   root: 'app_folder'}.merge(opts))
      JSON.parse(body)
    end
    
    def download_file(path, opts={})
      body = @consumer.get_no_ssl('fileops/download_file',
                                  {root: 'app_folder',
                                   path: path,
                                   site: Config[:up_down_file_stie]}.merge(opts))
      p body
    end

    def thumbnail(width, height, path, opts={})
      body = @consumer.get_no_ssl('fileops/thumbnail',
                                  {width: width,
                                   height: height,
                                   path: path,
                                   root: 'app_folder',
                                   site: Config[:thum_doc_site]}.merge(opts))
      body
    end

    def upload_locate
      body = @consumer.get_no_ssl('/fileops/upload_locate', 
                                  {site: Config[:up_down_file_stie]})
      JSON.parse(body)
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
      body = @consumer.get_no_ssl('fileops/create_folder', 
                                  {root: 'app_folder',
                                   path: folder}.merge(opts))
      JSON.parse(body)
    end

    def delete(path, opts={})
      @consumer.get_no_ssl('fileops/delete', 
                           {root: 'app_folder',
                            path: path,
                            to_recycle: 'True'}.merge(opts))
    end

# .......
  end
end
