require 'rho/rhocontroller'

class RhoTestController < Rho::RhoController

  #GET /RhoTest
  def index
    render :back => '/app'  
  end
  
  def render_string
    render :string => "<html><body>render :string called!<body/></html>"
  end

  def render_file
    render :file => "RhoTest/file_test"
  end

  def navigate_fragment
    WebView.navigate(url_for(:action => :frag_test, :fragment => "moreButton"))
    render :index
  end

  def raise_400
    raise ::Rhom::RecordNotFound
  end

  def raise_500
    raise ArgumentError, "test error" 
  end
  
end
