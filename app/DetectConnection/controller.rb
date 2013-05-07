require 'rho/rhocontroller'

class DetectConnectionController < Rho::RhoController
  @layout = :simplelayout
  $connection_status = 'unknown'
    
    $callback = lambda { |e|
        $connection_status = e['connectionInformation']
        if ( e['failureMessage'] ) then
            $connection_status += ':' + e['failureMessage']
        end
    }

  def start_connection_detection
      Rho::Network.detectConnection( { }, url_for( :action => :detectionCallback))
      redirect :action => :index
  end
    
  def stop_connection_detection
      Rho::Network.stopDetectingConnection(url_for( :action => :detectionCallback))
      $connection_status = 'unknown'
      redirect :action => :index
  end


  def index
    render :back => '/app'  
  end

  def detectionCallback
      puts "detectionCallback: #{@params.inspect}"
      $connection_status = @params['connectionInformation']
      if ( @params['failureMessage'] ) then
          $connection_status += ':' + @params['failureMessage']
      end
      WebView.refresh
  end
end
