require 'rho/rhocontroller'

class RhoTestController < Rho::RhoController

  #GET /RhoTest
  def index
  end
  
  def render_string
    render :string => "<html><body>render :string called!<body/></html>"
  end

  def render_file
    render :file => "RhoTest/file_test"
  end
  
end
