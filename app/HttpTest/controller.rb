require 'rho/rhocontroller'
require 'net/http'

class HttpTestController < Rho::RhoController

  #GET /HttpTest
  def index
  
    @get_result = Net::HTTP.get 'www.apache.org', '/licenses/LICENSE-2.0'
  
    render
  end
end
