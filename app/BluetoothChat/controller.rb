require 'rho/rhocontroller'
require 'rho/rhobluetooth'

 
class BluetoothChatController < Rho::RhoController
  @layout = 'BluetoothChat/layout'
  
  $device_name = nil
  $connected_device_name = nil
  $current_status = 'Not connected'
  $history = ''
  
  def index
    puts 'BluetoothChatController.index'
    $device_name = 'test'    
    #Rho::BluetoothManager.get_device_name()
    render
  end

  def on_send
    puts 'BluetoothChatController.on_send'
    message = @params['message']
    $history = $device_name+':'+ message + '\n'+$history
    Rho::BluetoothSession.write_string($connected_device_name, message)
    WebView.execute_js('setHistory("'+$history+'");')
    #WebView.navigate( url_for :action => :index )
    #redirect :action => :index
  end

  def example_send_byte_array
    ar = [21, 22, 23, 5, 777]
    Rho::BluetoothSession.write($connected_device_name, ar)
  end

  def on_connect_server
    puts 'BluetoothChatController.on_connect_server'
    if $connected_device_name == nil
       puts 'BluetoothChat::on_connect()'
       $current_status = 'Connecting ...'
       WebView.execute_js('setStatus("'+$current_status+'");')
       Rho::BluetoothManager.create_session(Rho::BluetoothManager::ROLE_SERVER, url_for(:action => :create_session_callback) )
       #WebView.navigate( url_for :action => :index )
       #redirect :action => :index
    else
        on_disconnect
    end
  end

  def on_connect_client
    puts 'BluetoothChatController.on_connect_client'
    if $connected_device_name == nil
       puts 'BluetoothChat::on_connect()'
       $current_status = 'Connecting ...'
       WebView.execute_js('setStatus("'+$current_status+'");')
       Rho::BluetoothManager.create_session(Rho::BluetoothManager::ROLE_CLIENT, url_for(:action => :create_session_callback) )
       #WebView.navigate( url_for :action => :index )
       #redirect :action => :index
    else
        on_disconnect
    end
  end


  def on_disconnect
    puts 'BluetoothChatController.on_disconnect'
    if $connected_device_name == nil
       Alert.show_popup "You are not connected now !"    
    else
       Rho::BluetoothSession.disconnect($connected_device_name)
       $connected_device_name = nil
       $current_status = 'Disconnected'
       WebView.execute_js('setStatus("'+$current_status+'");')
       WebView.execute_js('restoreButtonCaption();')
       #WebView.navigate( url_for :action => :index )
       #redirect :action => :index
     end    
  end

  def on_change_name
    if $connected_device_name != nil
       Alert.show_popup "You cannot change name while you connected !"
    else
       $device_name = @params['device_name']
       Rho::BluetoothManager.set_device_name($device_name)
       #WebView.navigate( url_for :action => :index )
       #redirect :action => :index
     end
  end

  def create_session_callback
    puts 'BluetoothChat::create_session_callback'
    puts 'status = ' + @params['status']
    $connected_device_name = @params['connected_device_name']
    puts 'connected_device_name = ' + $connected_device_name	
    if @params['status'] == Rho::BluetoothManager::OK
      $current_status = 'Connected to ['+$connected_device_name+']'
      Rho::BluetoothSession.set_callback($connected_device_name, url_for(:action => :session_callback))
      WebView.execute_js('setButtonCaption("Disconnect");')
    else 
       if @params['status'] == Rho::BluetoothManager::CANCEL
         $current_status = 'Cancelled by User'
       else
         $current_status = 'Error with Connection'
       end
    end
    WebView.execute_js('setStatus("'+$current_status+'");')
    #WebView.navigate( url_for :action => :index )
    #redirect :action => :index
  end

  def on_data_received
    puts 'BluetoothChat::on_data_received'
    while Rho::BluetoothSession.get_status($connected_device_name) > 0
       message = Rho::BluetoothSession.read_string($connected_device_name)
       $history = $connected_device_name+':'+ message + '\n'+$history
       WebView.execute_js('setHistory("'+$history+'");')
    end
  end

  def example_receive_byte_array
       ar = Rho::BluetoothSession.read($connected_device_name)
       puts ar
  end

  def session_callback
    puts 'BluetoothChat::session_callback'
    cdn = @params['connected_device_name']
    event_type = @params['event_type']
    puts 'connected_device_name = ' + cdn
    puts 'event_type = ' + event_type
    if event_type == Rho::BluetoothSession::SESSION_INPUT_DATA_RECEIVED
       # receive data
       on_data_received
    else
       if event_type == Rho::BluetoothSession::SESSION_DISCONNECT
          $connected_device_name = nil
          $current_status = 'Disconnected'
          WebView.execute_js('setStatus("'+$current_status+'");')
          WebView.execute_js('restoreButtonCaption();')
          #WebView.navigate( url_for :action => :index )
          #redirect :action => :index
       else
          $current_status = 'Error occured !'
          WebView.execute_js('setStatus("'+$current_status+'");')
          #WebView.navigate( url_for :action => :index )
          #redirect :action => :index
       end
    end
  end

end
