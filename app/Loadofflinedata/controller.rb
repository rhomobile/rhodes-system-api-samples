require 'rho/rhocontroller'
require 'rho/rhoutils'

class LoadofflinedataController < Rho::RhoController
  def index

    puts "Start loading data"
    Rho::RhoUtils.load_offline_data_ex(['object_values'], 'Loadofflinedata', 100000)
    
    render
  end

end
