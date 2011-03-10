require 'rho/rhocontroller'

class RhoTimerTestController < Rho::RhoController

  #GET /RhoTimerTest
  def index
	
    render :back => '/app'  	
  end

  @@timer_result = ""  
  def get_timer_result
    @@timer_result
  end
  
  def start_timer
    Rho::Timer.start(5000, (url_for :action => :timer_callback), "test")
    
    redirect :action => :index
  end

  def stop_timer
    Rho::Timer.stop((url_for :action => :timer_callback));
    
    redirect :action => :index
  end

  def timer_callback
    puts "timer_callback: #{@params}"
    
    @@timer_result += "Timer works!<br/>"
    WebView.refresh
  end
end
