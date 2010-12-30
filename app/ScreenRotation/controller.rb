require 'rho/rhocontroller'

class ScreenRotationController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    System::set_screen_rotation_notification(url_for(:action => :screenRotateCallback), "" )
    render :back => '/app'  
  end

  def screenRotateCallback
    Alert.show_popup ("Screen Rotated W["+@params['width']+"]xH["+@params['height']+"] Degrees["+@params['degrees']+"]")    
  end
end
