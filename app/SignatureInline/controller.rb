require 'rho/rhocontroller'

class SignatureInlineController < Rho::RhoController
  #@layout = :simplelayout
  @layout = 'SignatureInline/layout'
  
  def index
    puts "Signature Inline index controller"
    @signatures = SignatureInline.find(:all)
    Rho::SignatureCapture.visible(false, nil )

    render :back => '/app'  
  end

  def delete
    @signature = SignatureInline.find(@params['id'])
    @signature.destroy
    redirect :action => :index
  end

  def set_rect
     puts '############  setRect()'
     Rho::SignatureCapture.visible(true, :penColor => 0xFFFF0000, :penWidth=>5, :border => true, :bgColor => 0x4F00ff00, :left => @params['left'], :top => @params['top'], :width => @params['width'], :height => @params['height'] )
  end

  def signature_callback
     puts '############  signature_callback'
    if @params['status'] == 'ok'
       #tmp_uri = @params['signature_uri']
       #uri = tmp_uri.sub(Rho::Application.databaseBlobFolder(), "db/db-files")

      #create signature record in the DB
      signature = SignatureInline.new({'signature_uri'=> Rho::Application.relativeDatabaseBlobFilePath(@params['signature_uri']) })
      signature.save
      puts "new Signature object: " + signature.inspect
    end  
    Rho::SignatureCapture.visible(false, nil )
    WebView.navigate( url_for :action => :index )
    ""
  end

  def do_capture          
    Rho::SignatureCapture.capture(url_for( :action => :signature_callback))    
  end
  
  def do_clear          
    Rho::SignatureCapture.clear()    
  end

  def do_back          
    Rho::SignatureCapture.visible(false, nil )
    WebView.navigate( url_for :action => :index )
    ""
  end

  
end
