require 'rho/rhocontroller'

class SystemTestController < Rho::RhoController

  #GET /SystemTest
  def index
    puts "System index controller"

    #puts "#{Rho::WebView.nativeMenu}"	
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
    WebView.execute_js("test();")
    #render :action => :call_js_result
    redirect :action => :call_js_result
  end  

  def show_alert
    Alert.show_popup "Alert from AJAX call."
  end

  def set_cookie
    WebView.set_cookie("http://127.0.0.1", "test_key_1=test_value_1")
    WebView.set_cookie("http://127.0.0.1", "test_key_2=test_value_2")
    redirect :action => :show_cookie
  end

  def show_cookie
    WebView.execute_js("show_cookie();")
    redirect :action => :index
  end

  def start_music_app
    System.run_app('com.android.music', nil)
    redirect :action => :index
  end

  def get_start_test_app_ID
    if System::get_property('platform') == 'ANDROID'
        return 'com.rhomobile.store'
    elsif System::get_property('platform') == 'APPLE'
        return 'store'
    elsif System::get_property('platform') == 'Blackberry'
        return 'store'
    elsif System::get_property('platform') == 'WINDOWS_DESKTOP'
        return 'rhomobile/store/store.exe'
    else
        return 'rhomobile store/store.exe'
    end
  
  end

  def install_test_app
    url = 'http://localhost:42877/store-setup.exe'
    System.app_install url
    redirect :action => :index
  end
  
  def start_test_app
    System.run_app(get_start_test_app_ID, "security_token=123")    
    redirect :action => :index
  end

  def is_test_app_installed
    installed = System.app_installed?(get_start_test_app_ID())
    Alert.show_popup(installed ? "installed" : "not installed")
    redirect :action => :index
  end

  def uninstall_test_app
    System.app_uninstall(get_start_test_app_ID())
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
       fileNameW = File.join(Rho::RhoApplication::get_user_path(), 'tempfile.txt')
       f = File.new(fileNameW, 'w+')
       f.write('my own file !')
       f.close  
       render :action => :index
  end

  def show_own_file
      content = ''
      fileName = File.join(Rho::RhoApplication::get_user_path(), 'tempfile.txt')
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

  def set_badge_5
      System.set_application_icon_badge(5)
      render :action => :index
  end

  def set_badge_0
      System.set_application_icon_badge(0)
      render :action => :index
  end

end
