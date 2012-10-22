require 'rho/rhocontroller'
require 'json'

class JsonTestController < Rho::RhoController

  #GET /JsonTest
  def index
    render :back => '/app'
  end
  
  def filetest
    
    #begin
        file_name = File.join(Rho::RhoApplication::get_model_path('app','JsonTest'), 'test.json')
        puts "file_name : #{file_name}"

        content = File.read(file_name)
        puts "content : #{content}"
      
        parsed = Rho::JSON.parse(content)
        puts "parsed : #{parsed}"

        gen = ::JSON.generate(parsed)
        puts "gen : #{gen}"
        
        @@get_result = "Success!"
    #rescue Exception => e
    #    puts "Error: #{e}"
    #    @@get_result = "Uncomment in build.yml:<br/> extensions: [\"json\"]<br/>"
    #    @@get_result += "Error: #{e}"
    #end
        
  end

  def webservicetest
    Rho::AsyncHttp.get(
      :url => 'http://rhostore.herokuapp.com/products.json',
      :callback => (url_for :action => :httpget_callback),
      :callback_param => "" )
      
    render :action => :wait
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

        WebView.navigate ( url_for :action => :show_result )
    end

  end

  def get_res
    @@get_result    
  end

  def show_result
    render :action => :webservicetest, :back => '/app/JsonTest'
  end

  def show_error
    render :action => :error, :back => '/app/JsonTest'
  end
    
  def cancel_httpcall
    Rho::AsyncHttp.cancel( url_for( :action => :httpget_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :webservicetest, :back => '/app/JsonTest'
  end

end
