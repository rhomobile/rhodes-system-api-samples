require 'rho/rhocontroller'

class AsyncUploadFileController < Rho::RhoController

  #GET /AsyncUploadFile
  def index

    @@file_name = File.join(Rho::RhoApplication::get_base_app_path(), 'rhoconfig.txt')
    Rho::AsyncHttp.upload_file(
      :url => 'http://dev.rhosync.rhohub.com/apps/SystemApiSamples/sources/client_log?client_id=19bdcf15-aca2-4e5a-9676-3c297c09bb11&device_pin=&log_name=',
      :filename => @@file_name,
      :headers => {},
      :callback => (url_for :action => :httpupload_callback),
      :callback_param => "" )
      
    render :action => :wait
  end
  
  def get_res
    @@get_result    
  end
  
  def httpupload_callback
    puts "httpupload_callback: #{@params}"

    if @params['status'] != 'ok'
        @@get_result = "Failed to upload. File: " + @@file_name + "Http error:" + @params['http_error'] + "; Rho Error: " + Rho::RhoError.new(@params['error_code'].to_i).message
    else
        @@get_result = "Success. File: " + @@file_name;
    end
        
    WebView.navigate ( url_for :action => :show_result )
  end

  def show_result
    render :action => :index, :back => '/app'
  end
    
  def cancel_httpcall
    AsyncHttp.cancel( url_for( :action => :httpupload_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end
  
end
