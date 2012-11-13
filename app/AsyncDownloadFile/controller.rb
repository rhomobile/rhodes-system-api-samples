require 'rho/rhocontroller'

class AsyncDownloadFileController < Rho::RhoController

  #GET /AsyncDownloadFile
  def index

    @@file_name = File.join(Rho::RhoApplication::get_base_app_path(), 'test.jpg')

    Rho::AsyncHttp.download_file(
      :url => 'http://www.rhomobile.com/wp-content/themes/rhomobile_theme/images/misc/ruby_app.jpg',
      :filename => @@file_name,
      :headers => {},
      :callback => (url_for :action => :httpdownload_callback),
      :callback_param => "" )
      
    render :action => :wait
  end
  
  def get_res
    @@file_name    
  end

  def get_error
    @@error_params
  end
  
  def httpdownload_callback
    puts "httpdownload_callback: #{@params}"

    if @params['status'] != 'ok'
        @@error_params = @params
        WebView.navigate ( url_for :action => :show_error )        
    else
        WebView.navigate ( url_for :action => :show_result )
    end

  end

  def show_result
    render :action => :index, :back => '/app'
  end

  def show_error
    render :action => :error, :back => '/app'
  end
    
  def cancel_httpcall
    puts "cancel_httpcall"
    Rho::AsyncHttp.cancel()# url_for( :action => :httpdownload_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end
  
end
