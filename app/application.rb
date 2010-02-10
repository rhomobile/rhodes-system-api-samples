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
    
    #start geolocation
    GeoLocation.known_position?
                      
  end
end
