require 'rho/rhocontroller'

class ScreenRotationController < Rho::RhoController
  @layout = :simplelayout
  $callback_state = 'screen rotation callback is not setted'  

  def set_callback
    System::set_screen_rotation_notification(url_for(:action => :screenRotateCallback), "" )
    $callback_state = 'screen rotation callback is setted'  
    redirect :action => :index
  end

  def unset_callback
    System::set_screen_rotation_notification( nil, nil )
    $callback_state = 'screen rotation callback is not setted'  
    redirect :action => :index
  end


  def index
    render :back => '/app'  
  end

  def screenRotateCallback
    Alert.show_popup ("Screen Rotated W["+@params['width']+"]xH["+@params['height']+"] Degrees["+@params['degrees']+"]")    
  end
end
