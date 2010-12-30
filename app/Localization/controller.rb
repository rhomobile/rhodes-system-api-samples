require 'rho/rhocontroller'
require 'time'
require 'date'

class LocalizationController < Rho::RhoController

  #GET /Localization
  def index
  
    render :back => '/app'
  end
end
