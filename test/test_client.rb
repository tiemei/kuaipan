require 'kuaipan'
require 'test/unit'

class ClientTest < Test::Unit::TestCase
  include Kuaipan::OpenAPI

  def test_open_api
    #ct, cs = 'xcWcZhCNKFJz1H8p', '8RvkM0aGYiQF5kJF'
    #input_config ct, cs
    #k_session = g_session 
    #authorize_url = k_session[:authorize_url]
    #p 'please input this url to your browser,then copy access_numer here:'
    #p authorize_url
    #oauth_verifier = gets
    #k_session.set_atoken oauth_verifier
    

    ## test base.rb
    #assert_not_nil k_session.account_info['user_id']

    #folder = '/tiemei_kuaipan_test'
    #assert_equal 'ok', k_session.create_folder(folder)['msg']
    #assert_not_nil k_session.metadata('tiemei_kuaipan_test')['root']
    #k_session.delete folder


    #file = File.open('Gemfile','rb')
    #k_session.upload_file(file, {:path => 'test'})['msg']
    #assert_not_nil k_session.shares('test/Gemfile')['url']

    #k_session.move 'test/Gemfile','renameFile'
    #assert_not_nil k_session.copy('renameFile', 'test/renameFile')['file_id']

    #body = k_session.thumbnail 200, 200, '08.jpg'
    #file = File.new('08.jpg','w+b')
    #file.write body
    #file.flush



    
  end

end
