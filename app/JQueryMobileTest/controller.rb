require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'
require 'helpers/browser_helper'

class JQueryMobileTestController < Rho::RhoController
  @layout = 'JQueryMobileTest/layout'
  include BrowserHelper
  @@msg = ""

  def index
    render :back => '/app'
  end

  def get_msg
	@@msg
  end

  def do_submit
    @@msg = @params
    redirect :action => :index
  end

end
