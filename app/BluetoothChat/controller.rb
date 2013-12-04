require 'rho/rhocontroller'
require 'rho/rhobluetooth'

 
class BluetoothChatController < Rho::RhoController
  @layout = 'BluetoothChat/layout'
  
  $device_name = nil
  $connected_device_name = nil
  $current_status = 'Not connected'
  $history = '---'
  $is_blackberry = (System::get_property('platform') == 'Blackberry')
  $is_custom_connecting_in_progress = false
  $server_name = '' 
  
  def index
    puts 'BluetoothChatController.index'
    $device_name = Rho::BluetoothManager.get_device_name()
    puts "$device_name=" + $device_name.to_s
    render
  end

  def execute_js(js)
    if $is_blackberry
      #puts 'execute_js('+js+')'
    else
      WebView.execute_js(js)
    end
  end

  def on_send
    puts 'BluetoothChatController.on_send'
    message = @params['message']
    puts 'history ' + $history.to_s
    $history = message + '\n'+$history
    Rho::BluetoothSession.write_string($connected_device_name, message)
    execute_js('setHistory("'+$history+'");')
    if $is_blackberry
      #redirect :action => :index
      WebView.navigate( url_for :action => :index )
      ""
    end
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
       execute_js('setStatus("'+$current_status+'");')
       Rho::BluetoothManager.create_session(Rho::BluetoothManager::ROLE_SERVER, url_for(:action => :create_session_callback) )
       if $is_blackberry
         #redirect :action => :index
         WebView.navigate( url_for :action => :index )
         ""
       end
    else
        on_disconnect
    end
  end

  def on_connect_client
    puts 'BluetoothChatController.on_connect_client'
    if $connected_device_name == nil
       puts 'BluetoothChat::on_connect()'
       $current_status = 'Connecting ...'
       execute_js('setStatus("'+$current_status+'");')
       Rho::BluetoothManager.create_session(Rho::BluetoothManager::ROLE_CLIENT, url_for(:action => :create_session_callback) )
       if $is_blackberry
         #redirect :action => :index
         WebView.navigate( url_for :action => :index )
         ""
       end
    else
        on_disconnect
    end
  end

  def on_connect_custom_server
    puts 'BluetoothChatController.on_connect_custom_server'
    if ($connected_device_name == nil) && (!$is_custom_connecting_in_progress)
       puts 'BluetoothChat::on_connect()'
       $current_status = 'Connecting ...'
       execute_js('setStatus("'+$current_status+'");')
       $is_custom_connecting_in_progress = true
       Rho::BluetoothManager.create_server_and_wait_for_connection(url_for(:action => :create_session_callback))
       execute_js('setCustomButtonCaption("Cancel");')
    else
        if ($connected_device_name == nil)
               Rho::BluetoothManager.stop_current_connection_process
               $connected_device_name = nil
               $current_status = 'Cancelled'
               execute_js('setStatus("'+$current_status+'");')
               execute_js('restoreCustomButtonCaption();')
               $is_custom_connecting_in_progress = false
        else
               on_disconnect
        end
    end
  end

  def on_connect_custom_client
    puts 'BluetoothChatController.on_connect_custom_client'
    if ($connected_device_name == nil) && (!$is_custom_connecting_in_progress)
       puts 'BluetoothChat::on_connect()'
       $current_status = 'Connecting ...'
       execute_js('setStatus("'+$current_status+'");')
       $is_custom_connecting_in_progress = true
       Rho::BluetoothManager.create_client_connection_to_device($server_name, url_for(:action => :create_session_callback))
       execute_js('setCustomButtonCaption("Cancel");')
    else
        if ($connected_device_name == nil)
               Rho::BluetoothManager.stop_current_connection_process
               $connected_device_name = nil
               $current_status = 'Cancelled'
               execute_js('setStatus("'+$current_status+'");')
               execute_js('restoreCustomButtonCaption();')
               $is_custom_connecting_in_progress = false
        else
               on_disconnect
        end
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
       execute_js('setStatus("'+$current_status+'");')
       execute_js('restoreButtonCaption();')
       execute_js('restoreCustomButtonCaption();')
       if $is_blackberry
         #redirect :action => :index
         WebView.navigate( url_for :action => :index )
         ""
       end
     end    
  end

  def on_change_name
    if $connected_device_name != nil
       Alert.show_popup "You cannot change name while you connected !"
    else
       $device_name = @params['device_name']
       Rho::BluetoothManager.set_device_name($device_name)
     end
  end

  def on_change_server_name
    puts "on_change_server_name with " + @params['device_name'].to_s
    $server_name = @params['device_name']
  end

  def create_session_callback
    puts 'BluetoothChat::create_session_callback'
    puts 'status = ' + @params['status']
    $connected_device_name = @params['connected_device_name']
    puts 'connected_device_name = ' + $connected_device_name	
    if @params['status'] == Rho::BluetoothManager::OK
      $current_status = 'Connected to ['+$connected_device_name+']'
      if System::get_property('platform') == 'APPLE' ||
         System::get_property('platform') == 'ANDROID' ||
         System::get_property('platform') == 'WINDOWS' 

          $server_name = $connected_device_name
          execute_js('setServerName("'+$server_name+'");') 
      end
      Rho::BluetoothSession.set_callback($connected_device_name, url_for(:action => :session_callback))
      #Rho::BluetoothSession.write_string($connected_device_name, 'Hello another Bluetooth device !')	
      if ($is_custom_connecting_in_progress)
             execute_js('setCustomButtonCaption("Disconnect");')
      else  
             execute_js('setButtonCaption("Disconnect");')
      end
    else 
       if @params['status'] == Rho::BluetoothManager::CANCEL
         $current_status = 'Cancelled by User'
       else
         $current_status = 'Error with Connection'
       end
    end
    execute_js('setStatus("'+$current_status+'");')
    if $is_blackberry
      #redirect :action => :index
      WebView.navigate( url_for :action => :index )
      ""
    end
    $is_custom_connecting_in_progress = false
  end

  def on_data_received
    puts 'BluetoothChat::on_data_received START'
    while Rho::BluetoothSession.get_status($connected_device_name) > 0
       message = Rho::BluetoothSession.read_string($connected_device_name)
       puts 'BluetoothChat::on_data_received MESSAGE='+message	
       $history = $connected_device_name+':'+ message + '\n'+$history
       execute_js('setHistory("'+$history+'");')
    end
    puts 'BluetoothChat::on_data_received FINISH'
    if $is_blackberry
      #redirect :action => :index
      WebView.navigate( url_for :action => :index )
      ""
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
          execute_js('setStatus("'+$current_status+'");')
          execute_js('restoreButtonCaption();')
          execute_js('restoreCustomButtonCaption();')
          if $is_blackberry
            #redirect :action => :index
            WebView.navigate( url_for :action => :index )
            ""
          end
       else
          $current_status = 'Error occured !'
          $connected_device_name = nil
          execute_js('setStatus("'+$current_status+'");')
          execute_js('restoreButtonCaption();')
          execute_js('restoreCustomButtonCaption();')
          if $is_blackberry
            #redirect :action => :index
            WebView.navigate( url_for :action => :index )
            ""
          end
       end
    end
  end

  def on_close
    puts 'BluetoothChat::on_close()'
    Rho::BluetoothManager.off_bluetooth()
  end

end
