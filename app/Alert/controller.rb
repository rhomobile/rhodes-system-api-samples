require 'rho/rhocontroller'

class AlertController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    render
  end

  def show_popup
    Alert.show_popup "Some message!"
    render :action => :index
  end
  
  def vibrate
    Alert.vibrate
    render :action => :index
  end
  
  def vibrate_for_10sec
    Alert.vibrate 10000
    render :action => :index
  end
    
  def play_file
    Alert.play_file @params['file_name'], @params['media_type']
    render :action => :index    
  end
  
end
