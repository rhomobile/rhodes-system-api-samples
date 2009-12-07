require 'rho/rhocontroller'

class DynamicMenuController < Rho::RhoController

  # GET /DynamicMenu
  def index
    @menu = { "Go Home" => :home, "Refresh" => :refresh, "Options" => :options, 
                :separator => nil, "Log" => :log, "Go to Settings" => "/app/Settings" }
    render
  end
end
