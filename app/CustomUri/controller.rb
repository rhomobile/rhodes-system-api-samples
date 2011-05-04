require 'rho/rhocontroller'

class CustomUriController < Rho::RhoController
  @layout = :simplelayout
 
  def index
    render :back => '/app'  
  end
  
  def send_sms
    WebView.navigate( 'sms:+1222333444' )
    
    render :action => :index
  end

  def send_call
    WebView.navigate( 'tel:+1222333444' )
    
    render :action => :index
  end
  
  def send_mail
    WebView.navigate( 'mailto:test@host.com' )
    
    render :action => :index
  end
    
  def open_external_url
    System.open_url('http://www.rhomobile.com')
    redirect :action => :index
  end

  def open_rhodes_pdf
    # make full file path
    rhodes_path = File.join(Rho::RhoApplication::get_base_app_path(), 'public', 'pdfs', 'Rhodes.pdf')
    System.open_url(rhodes_path)
    redirect :action => :index
  end

 
end
