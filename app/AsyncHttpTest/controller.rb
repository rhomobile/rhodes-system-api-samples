require 'rho/rhocontroller'

class AsyncHttpTestController < Rho::RhoController

  #GET /AsyncHttpTest
  def index
    @@get_result = ""
    Rho::AsyncHttp.get(
      :url => 'http://www.apache.org/licenses/LICENSE-2.0',
      #:authorization => {:type => :basic, :username => 'user', :password => 'none'},
      :callback => (url_for :action => :httpget_callback),
      :callback_param => "" )
    render :action => :wait
  end
  
  def get_res
    @@get_result    
  end

  def get_error
    @@error_params
  end
  
  def httpget_callback
    puts "httpget_callback: #{@params}"
    if @params['status'] != 'ok'
        @@error_params = @params
        WebView.navigate ( url_for :action => :show_error )        
    else
        @@get_result = @params['body']
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
    Rho::AsyncHttp.cancel( url_for( :action => :httpget_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end
  
end
