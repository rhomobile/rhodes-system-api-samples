require 'rho/rhocontroller'
 
class CustomUriController < Rho::RhoController
 
  def send_sms
    WebView.navigate( 'sms:+1222333444' )
    
    render :action => :index
  end
 
end