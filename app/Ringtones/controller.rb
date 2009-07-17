require 'rho/rhocontroller'

class RingtonesController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    @ringtones = RingtoneManager::get_all_ringtones
    render
  end

  def play
    puts "Play ringtone"

    $selected = @params['name']
    RingtoneManager::play @params['file']
    render :action => :playing, layout => false
  end

  def stop
    puts "Stop playing"

    RingtoneManager::stop
    redirect :action => :index
  end

end
