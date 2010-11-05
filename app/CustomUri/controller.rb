require 'rho/rhocontroller'

class CustomUriController < Rho::RhoController
  @layout = :simplelayout
 
  def send_sms
    WebView.navigate( 'sms:+1222333444' )
    
    render :action => :index
  end

  def install_app
    if System::get_property('platform') == 'Blackberry'
        System.open_url('http://192.168.0.101:8080/ota-web/myapp.jad')    
    elsif System::get_property('platform') == 'ANDROID'        
        System.open_url('http://192.168.0.101:8080/myapp_signed.apk')
    elsif System::get_property('platform') == 'APPLE'
        System.open_url('itms-services://?action=download-manifest&url=http://192.168.0.101:8080/myapp.plist')
    else
        System.open_url('http://192.168.0.101:8080/myapp.cab')
    end    
    
    redirect :action => :index
  end
 
end
