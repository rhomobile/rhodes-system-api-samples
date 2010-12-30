require 'rho/rhocontroller'

class RingtonesController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    Rho::RingtoneManager.stop
    @ringtones = Rho::RingtoneManager.get_all_ringtones
    @ringtones = [] if @ringtones.nil?
    render :back => '/app'  
  end

  def play
    puts "Play ringtone"

    $selected = @params['name']
    Rho::RingtoneManager.play @params['file']
    render :action => :playing, :layout => false, :back => url_for( :action => :index )
  end

  def stop
    puts "Stop playing"

    Rho::RingtoneManager.stop
    redirect :action => :index, :back => url_for( :action => :index )
  end

end
