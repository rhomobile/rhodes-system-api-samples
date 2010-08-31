require 'rho/rhocontroller'

class NativeViewController < Rho::RhoController

  def save_location
    location = WebView.current_location
    puts "location: #{location}"
    @@this_page = location
  end

  def index
    puts "Native View index controller"
    render
  end
  
  def goto_html
    puts "Native View controller -> goto HTML"
    WebView.navigate( url_for :action => :index )
  end 

  def goto_red
    puts "Native View controller -> goto Red"
    WebView.navigate 'rainbow_view:red'
  end

  def goto_green
    puts "Native View controller -> goto Green"
    WebView.navigate 'rainbow_view:green'
  end

  def goto_blue
    puts "Native View controller -> goto Blue"
    WebView.navigate 'rainbow_view:blue'
  end

  def open_native_view
    puts "Native View controller -> open_native_view"
    Rainbow.open_native_view
    redirect :action => :index
  end

  def close_native_view
    puts "Native View controller -> close_native_view"
    Rainbow.close_native_view
    redirect :action => :index
  end

  def play_native_view
    puts "Native View controller -> close_native_view"
    Rainbow.execute_command_in_native_view 'play'
    redirect :action => :index
  end
  def stop_native_view
    puts "Native View controller -> close_native_view"
    Rainbow.execute_command_in_native_view 'stop'
    redirect :action => :index
  end
  def red_native_view
    puts "Native View controller -> close_native_view"
    Rainbow.execute_command_in_native_view 'red'
    redirect :action => :index
  end
  def green_native_view
    puts "Native View controller -> close_native_view"
    Rainbow.execute_command_in_native_view 'green'
    redirect :action => :index
  end
  def blue_native_view
    puts "Native View controller -> close_native_view"
    Rainbow.execute_command_in_native_view 'blue'
    redirect :action => :index
  end


  def goto_tabs
    save_location
    tabbar = [
      {:label => 'Native View', :action => '/app/NativeView', :icon => '/public/images/bar/gears.png',    :reload => false},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload =>false}
    ]
    NativeBar.create(Rho::RhoApplication::TABBAR_TYPE, tabbar)
    NativeBar.switch_tab(0)
 end

  def goto_single
   save_location
    toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/home_btn.png'},
      {:action => :refresh },
      {:action => 'callback:' + url_for(:action => :callback), :label => 'Callback' },
      {:action => :options}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    render :action => :index
   end

  def goto_nobar
   save_location
    NativeBar.create(Rho::RhoApplication::NOBAR_TYPE, [])
    render :action => :index   
  end
end
