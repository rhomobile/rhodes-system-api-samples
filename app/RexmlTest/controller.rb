require 'rho/rhocontroller'

class RexmlTestController < Rho::RhoController

  #GET /RexmlTest
  def index

  end
  
  def filetest
    file_name = File.join(Rho::RhoApplication::get_model_path('app','RexmlTest'), 'test.xml')
    puts "file_name : #{file_name}"
    
    file = File.new(file_name)
    begin
        require 'rexml/document'
    
        doc = REXML::Document.new(file)
        puts doc
        
        @@get_result = "Success"
    rescue Exception => e
        puts "Error: #{e}"
        @@get_result = "Error: #{e}"
    end
  end

  def webservicetest
    Rho::AsyncHttp.get(
      :url => 'http://api.search.yahoo.com/WebSearchService/V1/webSearch?appid=YahooDemo&query=madonna&results=2',
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
        puts "@@get_result : #{@@get_result}"

        begin
            require 'rexml/document'
        
            doc = REXML::Document.new(@@get_result)
            puts "doc : #{doc}"
        rescue Exception => e
            puts "Error: #{e}"
            @@get_result = "Error: #{e}"
        end
            
        WebView.navigate ( url_for :action => :show_result )
    end

  end

  def show_result
    render :action => :webservicetest, :back => '/app/RexmlTest'
  end

  def show_error
    render :action => :error, :back => '/app/RexmlTest'
  end
    
  def cancel_httpcall
    AsyncHttp.cancel( url_for( :action => :httpget_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :webservicetest, :back => '/app/RexmlTest'
  end
  
end
