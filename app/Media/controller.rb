require 'rho/rhocontroller'

class MediaController < Rho::RhoController
  @layout = false
  
  def index
    render
  end
end
