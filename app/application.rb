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
    $mt_string = ""
    #Rho::RHO.get_instance().load_all_sync_sources()
if System.get_property('platform') != 'WP8'   
    SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')    
end
  end
  
  def on_activate_app
    $mt_string += "Activation callback called<br/>"
    #start geolocation
    #GeoLocation.known_position?
    #GeoLocation.set_notification("/app/Settings/geo_callback", "")
    
    System.set_push_notification("/app/Settings/push_callback", "")
  end

  def on_deactivate_app
    $mt_string += "Deactivation callback called<br/>"
  end

end

at_exit do
	puts "at_exit"
end
