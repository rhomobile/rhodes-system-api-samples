require 'rho/rhocontroller'

class ZoomTestController < Rho::RhoController
    def index
        render :layout => 'zoom_layout', :back => '/app'
    end
end