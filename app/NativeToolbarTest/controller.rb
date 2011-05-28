require 'rho/rhocontroller'
require 'rho/rhotoolbar'

class NativeToolbarTestController < Rho::RhoController

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
    #NativeBar.create(Rho::RhoApplication::NOBAR_TYPE, [])
    Rho::NativeToolbar.remove
    $tabbar_active = false
    render :action => :index
  end

def set_toolbar
    save_location
if !defined?( RHO_WP7 )      
    toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/colored_btn.png', :colored_icon => true},
      {:action => :refresh },
      {:action => 'callback:' + url_for(:action => :callback), :label => 'Callback'},
      {:action => :options}
    ]
else
    iconpath = '/public/images/bar/gears.png'
    toolbar = [
      {:action => :back,    :icon => '/public/images/bar/back_btn.png'},
      {:action => :forward, :icon => '/public/images/bar/forward_btn.png'},
      {:action => :separator},
      {:action => :home,    :icon => '/public/images/bar/colored_btn.png', :colored_icon => true},
      {:action => :refresh },
      {:action => 'callback:' + url_for(:action => :callback), :label => 'Callback' , :icon => iconpath },
      {:action => :options}
    ]
end    
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
    $tabbar_active = false
    render :action => :index
  end

  def set_toolbar_new
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
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, :buttons => toolbar, :background_color => 0x00004F)
    Rho::NativeToolbar.create(:buttons => toolbar, :background_color => 0x00004F)
    $tabbar_active = false
    render :action => :index
  end




  def show_main_page
    WebView.navigate '/app'
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
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
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
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
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
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
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
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
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
    #NativeBar.create(Rho::RhoApplication::TOOLBAR_TYPE, toolbar)
    Rho::NativeToolbar.create(toolbar)
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
