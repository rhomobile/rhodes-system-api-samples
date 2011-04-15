require 'rho/rhocontroller'

class SystemTestController < Rho::RhoController

  #GET /SystemTest
  def index
	puts "System index controller"
	
    $sleeping = true unless $sleeping

	System.set_screen_rotation_notification( url_for(:action => :screen_rotation_callback), "")
	
    render :back => '/app'  	
  end

  def screen_rotation_callback
    puts "screen_rotation_callback : #{@params}"
    WebView::refresh
  end

  def disable_sleep
    $sleeping = !$sleeping
    System.set_sleeping($sleeping)
    render :action => :index
  end

  def enable_fullscreen
    WebView.full_screen_mode(1)
    render :action => :index
  end

  def disable_fullscreen
    WebView.full_screen_mode(0)
    render :action => :index
  end
  
  def app_exit
    System.exit
  end

  def read_log
    @log_text = Rho::RhoConfig.read_log(20000)
    render :action => :show_log
  end
    
  def call_js
    WebView.execute_js("test();", 0)
    
    redirect :action => :index
  end  

  def show_alert
	Alert.show_popup "Alert from AJAX call."
  end

  def start_music_app
    System.run_app('com.android.music', nil)
    redirect :action => :index
  end

  def start_test_app
    
if System::get_property('platform') == 'ANDROID'    
    System.run_app('com.rhomobile.store', "security_token=123")
elsif System::get_property('platform') == 'APPLE'    
    System.run_app('store', "security_token=123")
elsif System::get_property('platform') == 'Blackberry'    
    System.run_app('store', "security_token=123")
else
    System.run_app('rhomobile store/store.exe', "security_token=123")
end

    redirect :action => :index
  end

  def is_music_app_installed
    installed = System.app_installed?('com.android.music')
    Alert.show_popup(installed ? "installed" : "not installed")
    redirect :action => :index
  end

  def uninstall_music_app
    System.app_uninstall('com.android.music')
    redirect :action => :index
  end

  def start_skype_app
    System.run_app('skype', nil)
    redirect :action => :index
  end

  def is_skype_app_installed
    installed = System.app_installed?('skype')
    Alert.show_popup(installed ? "installed" : "not installed")
    redirect :action => :index
  end

  def install_apk
    url = 'https://rhohub-prod-ota.s3.amazonaws.com/129b1fd5930d4d40b906addd08d61058/simpleapp-rhodes_signed.apk'
    System.app_install url
    redirect :action => :index
  end


  def make_own_file
       fileNameW = File.join(Rho::RhoApplication::get_base_app_path(), 'tempfile.txt')
       f = File.new(fileNameW, 'w+')
       f.write('my own file !')
       f.close  
       render :action => :index
  end

  def show_own_file
      content = ''
      fileName = File.join(Rho::RhoApplication::get_base_app_path(), 'tempfile.txt')
      if File.exist?(fileName)
           File.open(fileName).each do |line|
               content = content + "\n" + line
           end
           Alert.show_popup(
                 :message=>"Own File is Exist. Content : "+"\n"+content,
                 :title=>"Own File",
                 :buttons => ["Ok"]
           )
      else
           Alert.show_popup(
                 :message=>"Own File is NOT Exist !",
                 :title=>"Own File",
                 :buttons => ["Ok"]
           )
      end
    render :action => :index
  end

end
