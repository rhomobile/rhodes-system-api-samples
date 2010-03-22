require 'rho/rhocontroller'

class NativeBarTestController < Rho::RhoController

  @@this_page = '/app/NativeBarTest'

  def set_no_bar
    NativeBar.create(Rho::RhoApplication::NOBAR_TYPE, [])
    WebView.navigate @@this_page
  end

  def set_toolbar
    toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/home_btn.png'},
      {:action => :refresh},
      {:action => :options}
    ]
    NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    WebView.navigate @@this_page
  end

  def set_tabbar
    tabbar = [
      {:label => 'Native bar', :action => '/app/NativeBarTest', :icon => '/public/images/bar/gears.png',    :reload => true},
      {:label => 'Main page',  :action => '/app',               :icon => '/public/images/bar/home_btn.png', :reload => true}
    ]
    NativeBar.create(Rho::RhoApplication::TABBAR_TYPE, tabbar)
    NativeBar.switch_tab(0)
    WebView.navigate(@@this_page, 0)
  end

end
