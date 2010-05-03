require 'rho/rhocontroller'

class AsyncHttpsTestController < Rho::RhoController

  #GET /AsyncHttpsTest
  def index

    @@get_result = ""
    Rho::AsyncHttp.get(
      #:url => 'https://www.paypal.com/',
      :url => 'https://mail.google.com/',
      :callback => (url_for :action => :httpget_callback),
      :callback_param => "" )
=begin      
    file = IO.read(File.join(Rho::RhoApplication::get_model_path('app','AsyncHttpsTest'), 'body.xml'))
    Rho::AsyncHttp.post(
		  :headers => {'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => "http://agentfirstws.firstam.com/Login"},
		  :url => "https://test2.myagent1st.com/private/AgentFirstWS/AgentFirstWS.asmx",
		  :body => file,
		  :callback => (url_for :action => :httpget_callback),
		  :callback_param => "login=slagent&password=thepassword" ,
		  :ssl_verify_peer => 'false')
=end      
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
              :url => @params['headers']['location'],
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
    Rho::AsyncHttp.cancel( url_for( :action => :httpget_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end
  
end
