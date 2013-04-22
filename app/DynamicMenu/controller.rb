require 'rho/rhocontroller'

class DynamicMenuController < Rho::RhoController

  @@callback_result = ""
  # GET /DynamicMenu
  def index
    @menu = { "Go Home" => :home, "Refresh" => :refresh, "Options" => :options, 
                :separator => nil, "Log" => :log, "Go to Settings" => "/app/Settings",
                "Call callback" => 'callback:' + url_for(:action => :callback),
                "Full screen" => 'fullscreen',
                "Call js callback" => 'javascript:callback_func();' }

    render :back => '/app'
  end
  
  def callback
    puts "+++--- callback"
    @@callback_result = "Callback called!"
    WebView.navigate '/app/DynamicMenu'
  end
  
  def get_callback_result
    res = @@callback_result
    @@callback_result = ""
    res
  end

  def back_with_close
    render :action => :page_close, :back => :close
  end

  def back_with_back
    @menu = { "Back" => :back,
        "Main Menu" => :home
    }

    render :action => :page_back
  end

  def popup_callback
    id = @params['button_id']
    title = @params['button_title']
    puts "popup_callback: id: '#{id}', title: '#{title}'"
    
    WebView.navigate url_for(:action => :index) if title.downcase() == 'yes'
  end
  
  def callback_alert
    puts "+++--- callback_alert"
    
    Alert.show_popup( :title => "", :message => "Do you want to leave?", :icon => :question,
      :buttons => ["Yes", "No"], :callback => url_for(:action => :popup_callback) )
    
  end
  
  def back_with_alert
    render :action => :page_alert, :back => 'callback:' + url_for(:action => :callback_alert)
  end
  
end
