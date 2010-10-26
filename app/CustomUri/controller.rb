require 'rho/rhocontroller'

class CustomUriController < Rho::RhoController
  @layout = :simplelayout
 
  def send_sms
    WebView.navigate( 'sms:+1222333444' )
    
    render :action => :index
  end
 
end
