require 'rho/rhocontroller'
require 'rho/rhonativeviewmanager'
require 'rho/rhotoolbar'
require 'rho/rhotabbar'


class NativeViewController < Rho::RhoController

  $native_view = nil

  def save_location
    location = WebView.current_location
    puts "location: #{location}"
    @@this_page = location
  end

  def index
    puts "Native View index controller"
    render :back => '/app'
  end
  
  def goto_html
    puts "Native View controller -> goto HTML"
    if $native_view != nil
       $native_view.destroy
       $native_view = nil
    end
    WebView.navigate( url_for :action => :index )
  end 

  def goto_red
    puts "Native View controller -> goto Red"
    if $native_view != nil
       puts "Native View controller -> goto Red     (use @native_view)"
       $native_view.navigate('red')
       redirect :action => :index
    else
       puts "Native View controller -> goto Red     (use WebView.navigate)"
        WebView.navigate 'rainbow_view:red'
    end
  end

  def open_native_view_with_helper
    puts "Native View controller -> open_native_view_with_helper"
    url = url_for_nativeview :name => 'rainbow_view', :param => 'red'
    WebView.navigate url
  end

  def goto_green
    puts "Native View controller -> goto Green"
    if $native_view != nil
       $native_view.navigate('green')
       redirect :action => :index
    else
        WebView.navigate 'rainbow_view:green'
    end
  end

  def goto_blue
    puts "Native View controller -> goto Blue"
    if $native_view != nil
       $native_view.navigate('blue')
       redirect :action => :index
    else
        WebView.navigate 'rainbow_view:blue'
    end
  end

  def open_native_view
    puts "Native View controller -> open_native_view"
    Rainbow.open_native_view
    redirect :action => :index
  end

  def open_native_view_fullscreen
    puts "Native View controller -> open_native_view_fullcreen"
    $native_view = Rho::NativeViewManager.create_native_view('rainbow_view',  Rho::NativeViewManager::OPEN_IN_MODAL_FULL_SCREEN_WINDOW, nil)
    redirect :action => :index
  end

  def open_native_view_by_ruby
    puts "Native View controller -> open_native_view_by_ruby"
    $native_view = Rho::NativeViewManager.create_native_view('rainbow_view',  0, nil)
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
    Rho::NativeTabbar.create(tabbar)
    Rho::NativeTabbar.switch_tab(0)
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
    Rho::NativeToolbar.create(toolbar)
    render :action => :index
   end

  def goto_nobar
   save_location
    Rho::NativeToolbar.remove
    render :action => :index   
  end
end
