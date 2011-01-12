require 'rho/rhocontroller'

class ESRIController < Rho::RhoController
  @layout = 'ESRI/layout'
  
  def index
    render
  end
  
end
