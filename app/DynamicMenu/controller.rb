require 'rho/rhocontroller'

class DynamicMenuController < Rho::RhoController

  # GET /DynamicMenu
  def index
    render
  end
  
  def menu_one
    @menu = { "Go Home" => :home, "Refresh" => :refresh, "Options" => :options, 
                :separator => nil, "Log" => :log, "New Account" => "/app/Account/new" }
    render :action => :menu_one
  end
  
  def menu_two
    render :action => :menu_two
  end
  
  def menu_three
    render :action => :menu_three
  end
end
