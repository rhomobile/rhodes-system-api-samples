require 'rho/rhocontroller'
require 'json'

class AjaxTestController < Rho::RhoController

  #GET /AjaxTest
  def index
    render :back => '/app'
  end
  
  def get_result
    render :string => '{"a": 1, "b": 2, "c": 3}'
  end

end
