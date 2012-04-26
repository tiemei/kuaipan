require 'json'

module Kuaipan
  class Base
    attr_reader :oauth_token

    def initialize(consumer)
      @consumer = consumer
    end

    def account_info
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+Config[:account_info_path], {:oauth_token => @consumer.oauth_token}
      JSON.parse body
    end
    def metadata(path ,opts={})
      root = opts[:root] ? opts[:site].to_s : 'app_folder'
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/'+'metadata/'+root+'/'+path,{
        :oauth_token => @consumer.oauth_token
      }.merge(opts)
      JSON.parse body
    end

    def shares(path, opts={})
      root = opts[:root] ? opts[:site].to_s : 'app_folder'
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/shares/'+root+'/'+path,{
        :oauth_token => @consumer.oauth_token
      }.merge(opts)
      JSON.parse body
    end

    def move(from_path, to_path, opts={})
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/fileops/move',{
        :oauth_token => @consumer.oauth_token,
        :from_path => from_path,
        :to_path => to_path,
        :root => 'app_folder'
      }.merge(opts)
      p body
    end
    
    def copy(from_path, to_path, opts={})
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/fileops/copy',{
        :oauth_token => @consumer.oauth_token,
        :from_path => from_path,
        :to_path => to_path,
        :root => 'app_folder'
      }.merge(opts)
      JSON.parse body
    end
    
    def download_file(path, opts={})
      body = @consumer.get_no_ssl '/'+Config[:oauth_token].to_i.to_s+'/fileops/download_file',{
        :oauth_token => @consumer.oauth_token,
        :root => 'app_folder',
        :path => path,
        :site => Config[:up_down_file_stie]
      }.merge(opts)
      p body
    end

    def thumbnail(width, height, path, opts={})
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/fileops/thumbnail',{
        :width => width,
        :height => height,
        :path => path,
        :root => 'app_folder',
        :site => Config[:thum_doc_site]
      }.merge(opts)
      body
    end

    def upload_locate
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/fileops/'+'upload_locate', {
        :oauth_token => @consumer.oauth_token,
        :site => Config[:up_down_file_stie]
      }
      JSON.parse body
    end

    def upload_file(file, opts={}) 
        folder = opts[:path]
        opts[:path] = opts[:path] ? opts[:path]+'/'+File.basename(file.path): File.basename(file.path)  
        opts[:root] =  'app_folder' unless opts[:root]
        create_folder((folder||=''), {:root => opts[:root]})
        body = @consumer.post Config[:oauth_version].to_i.to_s+'/fileops/'+'upload_file', file ,{
          :oauth_token => @consumer.oauth_token,
          :overwrite => 'True', 
          :site => upload_locate['url'],
        }.merge(opts)
        JSON.parse body
    end

    def create_folder(folder, opts={})
      folder = folder.encode('UTF-8')
      return nil if folder.size > 255
      body = @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/fileops/'+'create_folder', {
        :oauth_token =>@consumer.oauth_token,
        :root => 'app_folder',
        :path => folder
        }.merge(opts)
      JSON.parse body
    end

    def delete(path, opts={})
      @consumer.get_no_ssl '/'+Config[:oauth_version].to_i.to_s+'/fileops/'+'delete', {
        :oauth_token => @consumer.oauth_token,
        :root => 'app_folder',
        :path => path,
        :to_recycle => 'True'
      }.merge(opts)
    end

# .......
  end
end
