# conding: utf-8
require 'kuaipan'
require 'test/unit'

class ClientTest < Test::Unit::TestCase
  include Kuaipan::OpenAPI

  def test_open_api
    ct, cs = 'xcWcZhCNKFJz1H8p', '8RvkM0aGYiQF5kJF'
    input_config ct, cs
    k_session = g_session 
    authorize_url = k_session[:authorize_url]
    p 'please input this url to your browser,then copy authorization code here:'
    p authorize_url
    oauth_verifier = gets
    k_session.set_atoken oauth_verifier
    

    # get account info
    assert_not_nil k_session.account_info['user_id']

    # 1 create folder
    # 2 get metadata of folder
    # 3 create repeated folder 
    # 4 delete folder
    folder = '/tiemei_kuaipan_test/test'
    begin
      assert_equal 'ok', k_session.create_folder(folder)['msg']
      assert_not_nil k_session.metadata('tiemei_kuaipan_test')['root']
      assert_equal 'ok', k_session.create_folder(folder)['msg']
    ensure
      k_session.delete('/tiemei_kuaipan_test')
    end


    # upload one file to a folder
    # delete folder
    # download file
    # delete file
    folder = 'kuaipan_testfolder'
    file_name = '.kuaipan_test_file_123'
    rename = 'renameFile'
    copyname = 'copyfil.txt'
    dir = 'demo_tiemei'
    file = File.open("#{ file_name }",'w+b')do |f|
      f.write('test content!You can delete it')
      f.flush
    end
    file = File.open("#{ file_name }", 'rb')
    begin 
      assert_not_nil k_session.upload_file(file, {:path => "/#{ folder }"})['file_id']
      p k_session.shares("#{ folder }/#{ file_name }").to_s
      k_session.move("#{ folder }/#{ file_name }", 
                     "#{ folder }/#{ rename }")
      assert_not_nil k_session.copy("#{ folder }/#{ rename }", 
                                    "#{ folder }/#{ copyname }")['file_id']
      k_session.download_file("#{ folder }/#{ copyname }")do |res|
        Dir.mkdir(dir) unless Dir.exist?(dir)
        file = File.open("#{ dir }/#{ copyname }", 'wb')do |f|
          f.write(res.body)
          f.flush
        end
      end
      # documentView
      k_session.documentView('txt', "#{ folder }/#{ copyname }")do |res|
        p res.body
      end
        
    ensure
      k_session.delete(folder)
      File.delete(file)
    end

    # get thumbnail
    k_session.thumbnail(100, 100, '08.jpg')do |res|
      Dir.mkdir(dir) unless Dir.exist?(dir)
      file = File.open("#{ dir }/#{ '08.jpg' }", 'wb')do |f|
        f.write(res.body)
        f.flush
      end
    end


  end
end
