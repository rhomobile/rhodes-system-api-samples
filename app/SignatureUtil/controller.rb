require 'rho/rhocontroller'

class SignatureUtilController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Signature index controller"
    @signatures = SignatureUtil.find(:all)
    render :back => '/app'  
  end

  def new
    imgFormat = System::get_property('platform') == 'WINDOWS' ?  "bmp" : "jpg"
    
    Rho::SignatureCapture.take(url_for( :action => :signature_callback), { :imageFormat => imgFormat, :penColor => 0xff0000, :penWidth=>5, :border => true, :bgColor => 0x00ff00,
        :fileName => File.join( Rho::Application.databaseBlobFolder(), "/Image_" + Time.now.to_i.to_s() ) })
        
    redirect :action => :index
  end

  def delete
    @signature = SignatureUtil.find(@params['id'])
    @signature.destroy
    redirect :action => :index
  end

  def signature_callback
    puts "@params : #{@params}"
    if @params['status'] == 'ok'
      #create signature record in the DB
      signature = SignatureUtil.new({'signature_uri'=> Rho::Application.relativeDatabaseBlobFilePath(@params['signature_uri'])})
      signature.save
      puts "new Signature object: " + signature.inspect
    end  
    WebView.navigate( url_for :action => :index )
    #WebView::refresh
    #reply on the callback
    #render :action => :ok, :layout => false
    ""
  end

  def inline_capture
    Rho::SignatureCapture.visible(true, :penColor => 0xff0000, :penWidth=>1, :border => true, :bgColor => 0x00ff00,
        :fileName => File.join( Rho::Application.databaseBlobFolder(), "/Image_" + Time.now.to_i.to_s() ) )
  end

  def do_capture          
    Rho::SignatureCapture.capture(url_for( :action => :signature_callback))    
  end
  
  def clear_capture          
    Rho::SignatureCapture.clear()    
  end
  
end
