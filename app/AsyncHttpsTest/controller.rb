require 'rho/rhocontroller'

class AsyncHttpsTestController < Rho::RhoController

  #GET /AsyncHttpsTest
  def index

    @@get_result = ""
    AsyncHttp.get(
      #:url => 'http://wiki.rhomobile.com/index.php/Rhodes',
      :url => 'https://gmail.google.com/mail/?param1=1&param2=2',
      :headers => {'Cookie2' => 'test'},
      :callback => (url_for :action => :httpget_callback),
      :callback_param => "" )
      
    render :action => :wait
  end
  
  def get_res
    @@get_result    
  end
  
  def httpget_callback
    puts "httpget_callback: #{@params}"

    @@get_result = @params['body']
    
    WebView.navigate ( url_for :action => :show_result )
  end

  def show_result
    render :action => :index, :back => '/app'
  end
    
  def cancel_httpcall
    AsyncHttp.cancel( url_for( :action => :httpget_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end
  
end
