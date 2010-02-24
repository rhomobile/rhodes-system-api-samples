require 'rho/rhocontroller'

class AsyncHttpsTestController < Rho::RhoController

  #GET /AsyncHttpsTest
  def index

    @@get_result = ""
    Rho::AsyncHttp.get(
      :url => 'https://www.paypal.com/',
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
        http_error = @params['http_error'].to_i if @params['http_error']
        if http_error == 301 || http_error == 302 #redirect
            
            Rho::AsyncHttp.get(
              :url => @params['headers']['Location'],
              :callback => (url_for :action => :httpget_callback),
              :callback_param => "" )
            
        else
            @@error_params = @params
            WebView.navigate ( url_for :action => :show_error )        
        end    
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
    AsyncHttp.cancel( url_for( :action => :httpget_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end
  
end
