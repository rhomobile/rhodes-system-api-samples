require 'rho/rhocontroller'

class RhoTimerTestController < Rho::RhoController

  #GET /RhoTimerTest
  def index
    render :back => '/app'  	
  end

  def get_timer_result
    if (!$rho_test_timer_result)
      $rho_test_timer_result = ""  
    end
    $rho_test_timer_result
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

    $rho_test_timer_result += "Timer works!<br/>"
    WebView.refresh
  end
end
