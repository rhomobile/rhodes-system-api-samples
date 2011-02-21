require 'rho/rhocontroller'
require 'rho/rhotabbar'

class NativeTabbarTestController < Rho::RhoController
  @layout = 'NativeTabbarTest/layout'

  def index
    render :back => '/app'
  end

  def save_location
    location = WebView.current_location
    puts "location: #{location}"
    @@this_page = location
  end

  def set_no_bar
    save_location
    Rho::NativeTabbar.remove
    $tabbar_active = false
    render :action => :index
  end

  def set_tabbar
    save_location
    tabbar = [
      {:label => 'Native Tabbar', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :web_bkg_color => 0x7F7F7F},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    Rho::NativeTabbar.create(tabbar)
    Rho::NativeTabbar.set_tab_badge( 1, '12')
    $tabbar_active = true
    #Rho::NativeTabbar.switch_tab(0)
  end

  def switch_to_tabs
    puts 'switch_to_tabs start'
    save_location
    tabbar = [
      {:label => 'Native Tabbar', :icon => '/public/images/bar/gears.png', :use_current_view_for_tab => true},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    Rho::NativeTabbar.create(tabbar)
    $tabbar_active = true
    puts 'switch_to_tabs finish'
  end

  def set_tabbar_new
    save_location
    tabbar = [
      {:label => 'Native Tabbar', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :selected_color => 0xFF0000, :web_bkg_color => 0x7F7F7F},
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
    Rho::NativeTabbar.create(:tabs => tabbar, :background_color => bkg_color)
    $tabbar_active = true
    Rho::NativeTabbar.switch_tab(0)
  end

  def set_tabbar_new2
    save_location
    tabbar = [
      {:label => 'Native Tabbar', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :web_bkg_color => 0x7F7F7F},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true},
      {:label => 'Main page 1',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true, :disabled => true},
      {:label => 'Main page 2',  :action => '/app',               :icon => '/public/images/bar/colored_btn.png', :reload => true},
      {:label => 'Main page 3', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    Rho::NativeTabbar.create( tabbar)
    $tabbar_active = true
    Rho::NativeTabbar.switch_tab(0)
  end



  def set_tabbar_many_items
    save_location
    tabbar = [
      {:label => 'Native Tabbar', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :web_bkg_color => 0x7F7F7F},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Native Tabbar A', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :web_bkg_color => 0x7F7F7F},
      {:label => 'Main page B',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page C', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Native Tabbar D', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :web_bkg_color => 0x7F7F7F},
      {:label => 'Main page E',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page G', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    Rho::NativeTabbar.create(tabbar)
    Rho::NativeTabbar.set_tab_badge(7, '12')
    $tabbar_active = true
    Rho::NativeTabbar.switch_tab(0)
  end


  def show_main_page
    WebView.navigate '/app'
  end

  def set_iPad_tabbar
    save_location
    tabbar = [
      {:label => 'Native Tabbar', :action => '/app/NativeTabbarTest', :icon => '/public/images/bar/gears.png',    :reload => true, :web_bkg_color => 0x7F7F7F},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true},
      {:label => 'Main page 2', :action => 'callback:' + url_for(:action => :show_main_page), :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    Rho::NativeTabbar.create_vertical(tabbar)
    $tabbar_active = true
    Rho::NativeTabbar.switch_tab(0)
  end

  def switch_to_tab_1
    Rho::NativeTabbar.switch_tab(1)
  end

  def switch_to_tab_2
    Rho::NativeTabbar.switch_tab(2)
  end

  def callback
    puts "+++--- callback"
    WebView.navigate '/app'
  end


  def nop
  end


end
