require 'rho/rhocontroller'

class DynamicMenuController < Rho::RhoController

  @@callback_result = ""
  # GET /DynamicMenu
  def index
    @menu = { "Go Home" => :home, "Refresh" => :refresh, "Options" => :options, 
                :separator => nil, "Log" => :log, "Go to Settings" => "/app/Settings",
                "Call callback" => 'callback:' + url_for(:action => :callback),
                "Full screen" => 'fullscreen' }

    render
  end
  
  def callback
    puts "+++--- callback"
    @@callback_result = "Callback called!"
    WebView.navigate '/app/DynamicMenu'
  end
  
  def get_callback_result
    res = @@callback_result
    @@callback_result = ""
    res
  end
  
end
