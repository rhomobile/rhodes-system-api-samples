require 'rho/rhocontroller'

class NativeViewController < Rho::RhoController


  def index
    puts "Native View index controller"
    render
  end
  
  def goto_html
    WebView.navigate( url_for :action => :index )
  end 

  def goto_red
    WebView.navigate 'rainbow_view:red'
  end

  def goto_green
    WebView.navigate 'rainbow_view:green'
  end

  def goto_blue
    WebView.navigate 'rainbow_view:blue'
  end

end
