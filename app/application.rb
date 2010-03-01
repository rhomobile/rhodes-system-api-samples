require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  
  def initialize
    super
    @default_menu = { "Home" => :home, 
                      "Refresh" => :refresh, 
                      "Sync" => :sync, 
                      "Options" => :options, 
                      "Log" => :log, 
                      :separator => nil, 
                      "Close" => :close } 
    
  end
  
  def on_activate_app
    #start geolocation
    #GeoLocation.known_position?
    GeoLocation.set_notification("/app/Settings/geo_callback", "")
    
  end

end
