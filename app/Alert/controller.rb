require 'rho/rhocontroller'

class AlertController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    @flash = "Index page"
    render
  end

  def show_popup
    @flash = "Show popup page"
    Alert.show_popup "Some message!"
    render :action => :index
  end
  
  def vibrate
    @flash = "Vibrate page"
    Alert.vibrate
    render :action => :index
  end
  
  def vibrate_for_10sec
    @flash = "Vibrate for 10 sec page"    
    Alert.vibrate 10000
    render :action => :index
  end
    
  def play_file
    @flash = "Play file page"    
    Alert.play_file @params['file_name'], @params['media_type']
    render :action => :index    
  end
  
  def play_file_1
    @flash = "Play file page"    
    Alert.play_file @params['file_name']
    render :action => :index    
  end  

  def stop_playing
    Rho::RingtoneManager.stop
    render :action => :index
  end
  
end
