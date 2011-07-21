require 'rho/rhocontroller'

class NativeBarTestController < Rho::RhoController

  def index
    render :back => '/app'
  end

  def save_location
    location = WebView.current_location
    puts "location: #{location}"
    @@this_page = location
  end

  def return_to_main
     set_toolbar
     #redirect :action => :index
  end

  def set_no_bar
    save_location
    NativeBar.create(Rho::RhoApplication::NOBAR_TYPE, [])
    $tabbar_active = false
    render :action => :index
  end

def set_toolbar
    save_location
    iconpath = ''
    if defined?( RHO_WP7 )
        iconpath = '/public/images/bar/gears.png'
    end
    toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/colored_btn.png', :colored_icon => true},
      {:action => :refresh },
      {:action => 'callback:' + url_for(:action => :callback), :label => 'Callback', :icon => iconpath},
      {:action => :options}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    $tabbar_active = false
    render :action => :index
  end

  def set_toolbar_new
    save_location
    if defined?( RHO_WP7 )
        iconpath = '/public/images/bar/gears.png'
    end
    toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/colored_btn.png', :colored_icon => true},
      {:action => :refresh },
      {:action => 'callback:' + url_for(:action => :callback), :label => 'Callback', :icon => iconpath},
      {:action => :options}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, :buttons => toolbar, :background_color => 0x00004F)
    $tabbar_active = false
    render :action => :index
  end


  def set_tabbar
    save_location
    tabbar = [
      {:label => 'Native bar', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    NativeBar.create(Rho::RhoApplication::TABBAR_TYPE, tabbar)
    #NativeBar.set_tab_badge(1,'12')
    # removed from API - use Rho::NativeTabBar API
    $tabbar_active = true
    NativeBar.switch_tab(0)
  end

  def set_tabbar_new
    save_location
    tabbar = [
      {:label => 'Native bar', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :selected_color => 0xFF0000},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true, :selected_color => 0xFFFF00},
      {:label => 'Main page 1',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true, :selected_color => 0xFFFF00, :disabled => true},
      {:label => 'Main page 2',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true, :selected_color => 0xFFFF00},
      {:label => 'Main page 3', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true, :selected_color => 0xFFFF00}
    ]
    bkg_color = 0x008FFF 
    if System::get_property('platform') == 'APPLE' 
        # TabBar on iPhone have nice view with dark bkg instead of light bkg on Android
        bkg_color = 0x000F4F
    end
    NativeBar.create(Rho::RhoApplication::TABBAR_TYPE, :tabs => tabbar, :background_color => bkg_color)
    $tabbar_active = true
    NativeBar.switch_tab(0)
  end

  def set_tabbar_many_items
    save_location
    tabbar = [
      {:label => 'Native bar', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Native bar A', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true},
      {:label => 'Main page B',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page C', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Native bar D', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true},
      {:label => 'Main page E',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page G', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    NativeBar.create(Rho::RhoApplication::TABBAR_TYPE, tabbar)
    #NativeBar.set_tab_badge(7,'12')
    # removed from API - use Rho::NativeTabBar API
    $tabbar_active = true
    NativeBar.switch_tab(0)
  end


  def show_main_page
    WebView.navigate '/app'
  end

  def set_iPad_tabbar
    save_location
    tabbar = [
      {:label => 'Native bar', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    NativeBar.create(Rho::RhoApplication::VTABBAR_TYPE, tabbar)
    $tabbar_active = true
    NativeBar.switch_tab(0)
  end

  def switch_to_tab_1
    NativeBar.switch_tab(1)
  end

  def switch_to_tab_2
    NativeBar.switch_tab(2)
  end

  def callback
    puts "+++--- callback"
    WebView.navigate '/app'
  end


  def nop
  end

  def switch_to_1
    #save_location
    toolbar = [
      {:action => 'callback:' + url_for(:action => :nop),    :icon => '/public/images/bar/switch/btn_1_c.png', :colored_icon => true},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_2),    :icon => '/public/images/bar/switch/btn_2.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_3),    :icon => '/public/images/bar/switch/btn_3.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_4),    :icon => '/public/images/bar/switch/btn_4.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_5),    :icon => '/public/images/bar/switch/btn_5.png'}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    #redirect :action => :switch1.erb
    render :action => :switch1
  end

  def switch_to_2
    #save_location
    toolbar = [
      {:action => url_for(:action => :switch_to_1),    :icon => '/public/images/bar/switch/btn_1.png'},
      {:action => :separator},
      {:action => 'callback:' + url_for(:action => :nop),    :icon => '/public/images/bar/switch/btn_2_c.png', :colored_icon => true},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_3),    :icon => '/public/images/bar/switch/btn_3.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_4),    :icon => '/public/images/bar/switch/btn_4.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_5),    :icon => '/public/images/bar/switch/btn_5.png'}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    #redirect :action => :switch2.erb
    render :action => :switch2
  end

  def switch_to_3
    #save_location
    toolbar = [
      {:action => url_for(:action => :switch_to_1),    :icon => '/public/images/bar/switch/btn_1.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_2),    :icon => '/public/images/bar/switch/btn_2.png'},
      {:action => :separator},
      {:action => 'callback:' + url_for(:action => :nop),    :icon => '/public/images/bar/switch/btn_3_c.png', :colored_icon => true},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_4),    :icon => '/public/images/bar/switch/btn_4.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_5),    :icon => '/public/images/bar/switch/btn_5.png'}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    #redirect :action => :switch3.erb
    render :action => :switch3
  end

  def switch_to_4
    #save_location
    toolbar = [
      {:action => url_for(:action => :switch_to_1),    :icon => '/public/images/bar/switch/btn_1.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_2),    :icon => '/public/images/bar/switch/btn_2.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_3),    :icon => '/public/images/bar/switch/btn_3.png'},
      {:action => :separator},
      {:action => 'callback:' + url_for(:action => :nop),    :icon => '/public/images/bar/switch/btn_4_c.png', :colored_icon => true},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_5),    :icon => '/public/images/bar/switch/btn_5.png'}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    #redirect :action => :switch4.erb
    render :action => :switch4
  end

  def switch_to_5
    #save_location
    toolbar = [
      {:action => url_for(:action => :switch_to_1),    :icon => '/public/images/bar/switch/btn_1.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_2),    :icon => '/public/images/bar/switch/btn_2.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_3),    :icon => '/public/images/bar/switch/btn_3.png'},
      {:action => :separator},
      {:action => url_for(:action => :switch_to_4),    :icon => '/public/images/bar/switch/btn_4.png'},
      {:action => :separator},
      {:action => 'callback:' + url_for(:action => :nop),    :icon => '/public/images/bar/switch/btn_5_c.png', :colored_icon => true}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    #redirect :action => :switch5.erb
    render :action => :switch5
  end


  def switch1
    render :action => :switch1
  end

  def switch2
    render :action => :switch2
  end
  def switch3
    render :action => :switch3
  end
  def switch4
    render :action => :switch4
  end
  def switch5
    render :action => :switch5
  end


end
