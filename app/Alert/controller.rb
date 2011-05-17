require 'rho/rhocontroller'

class AlertController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    @flash = "Alerts"
    render :back => '/app'
  end

  def show_popup
    @flash = "Show popup page"
    Alert.show_popup "Some message!Long Message.Very Long Meeesage"
    render :action => :index, :back => '/app'
  end

  def show_popup1
    @flash = "Show popup page"
    
    Alert.show_popup(
        :message=>"The new password can't be empty.\n",
        :title=>"",
        :buttons => ["Ok"]
     )
    
    render :action => :index, :back => '/app'
  end

  def show_popup2
    @flash = "Show popup page"
    
    Alert.show_popup(
        :message=>"The new password can't be empty.\n",
        :title=>"MyTest",
        :buttons => ["Ok", "Cancel"],
        :callback => url_for(:action => :popup_callback)
     )
    render :action => :index, :back => '/app'
  end
  
  def show_popup_complex
    @flash = "Show popup page"
    
    Alert.show_popup :title => "This is popup", :message => "Some message!", :icon => :info,
      :buttons => ["Yes", "No", {:id => 'cancel', :title => "Cancel"}],
      :callback => url_for(:action => :popup_callback)
      
    render :action => :index, :back => '/app'
  end

  def show_popup3
    @flash = "Show popup page"
    Alert.show_popup :title => "Wait...", :message => "Wait ..."
    Rho::Timer.start 5000, url_for(:action => :wait_callback), ""
    render :action => :index, :back => '/app'
  end

  def wait_callback
    Alert.hide_popup
    WebView.navigate url_for(:action => :index)
  end

  def popup_callback
    puts "popup_callback: #{@params}"
    WebView.navigate url_for(:action => :index)
  end
  
  def vibrate
    @flash = "Vibrate page"
    Alert.vibrate
    render :action => :index, :back => '/app'
  end
  
  def vibrate_for_10sec
    @flash = "Vibrate for 10 sec page"    
    Alert.vibrate 10000
    render :action => :index, :back => '/app'
  end
    
  def play_file
    @flash = "Play file page"    
    Alert.play_file @params['file_name'], @params['media_type']
    render :action => :index, :back => '/app'
  end
  
  def play_file_1
    @flash = "Play file page"    
    Alert.play_file @params['file_name']
    render :action => :index, :back => '/app'
  end  

  def stop_playing
    Rho::RingtoneManager.stop
    render :action => :index, :back => '/app'
  end
  
end
