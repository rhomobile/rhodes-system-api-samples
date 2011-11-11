require 'rho/rhocontroller'
require 'time'
require 'date'

class LocalizationController < Rho::RhoController

  #GET /Localization
  def index
  
    render :back => '/app'
  end
  
  def change_locale_to_spanish
  
    System::set_locale("es")
    redirect :action => :index  
  end

  def change_locale_to_english
  
    System::set_locale("en")
    redirect :action => :index  
  end
  
end
