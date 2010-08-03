require 'rho/rhocontroller'

class SignatureUtilController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Signature index controller"
    @signatures = SignatureUtil.find(:all)
    render
  end

  def new
    SignatureTool::take_signature(url_for( :action => :signature_callback), 'jpg')
    redirect :action => :index
  end

  
  def delete
    @signature = SignatureUtil.find(@params['id'])
    @signature.destroy
    redirect :action => :index
  end

  def signature_callback
    if @params['status'] == 'ok'
      #create signature record in the DB
      signature = SignatureUtil.new({'signature_uri'=>@params['signature_uri']})
      signature.save
      puts "new Signature object: " + signature.inspect
    end  
    WebView.navigate( url_for :action => :index )
    #WebView::refresh
    #reply on the callback
    #render :action => :ok, :layout => false
    ""
  end
      
end
