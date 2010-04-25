require 'rho/rhocontroller'

class DynamicMenuController < Rho::RhoController

  # GET /DynamicMenu
  def index
    @menu = { "Go Home" => :home, "Refresh" => :refresh, "Options" => :options, 
                :separator => nil, "Log" => :log, "Go to Settings" => "/app/Settings",
                "Full screen" => 'fullscreen' }
    render
  end
end
