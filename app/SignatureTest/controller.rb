require 'rho/rhocontroller'

class SignatureTestController < Rho::RhoController

  #GET /RhoTest
  def index
    render :action=>:index, :layout=>false
  end
  
end
