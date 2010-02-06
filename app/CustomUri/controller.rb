require 'rho/rhocontroller'

class CustomUriController < Rho::RhoController
  @layout = :simplelayout
  @mailto = ''
  @tel = ''
  
  def index
    render
  end

  def mailto
    @mailto = "mailto:#{@params['mailto']}"
    puts "Open uri: #{@mailto}"
    WebView.navigate(@mailto)
    ""
  end

  def tel
    @tel = "tel:#{@params['tel']}"
    puts "Open URI: #{@tel}"
    WebView.navigate(@tel)
    ""
  end

end
