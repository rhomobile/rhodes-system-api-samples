require 'rho/rhocontroller'

class SystemTestController < Rho::RhoController

  #GET /SystemTest
  def index
	puts "System index controller"
	System.set_screen_rotation_notification( url_for(:action => :screen_rotation_callback), "")
  end

  def screen_rotation_callback
    puts "screen_rotation_callback : #{@params}"
    WebView::refresh
  end

end
