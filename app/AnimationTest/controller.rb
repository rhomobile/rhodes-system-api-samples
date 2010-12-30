require 'rho/rhocontroller'

class AnimationTestController < Rho::RhoController
  @layout = :animation_layout
  
  def index
    render :layout => :animation_layout, :back => '/app'
  end

end
