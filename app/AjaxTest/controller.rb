require 'rho/rhocontroller'
require 'json'

class AjaxTestController < Rho::RhoController

  #GET /AjaxTest
  def index
    render :back => '/app'
  end
  
  def get_result
    render :string => '--> this is an AJAX result <--'
  end

end
