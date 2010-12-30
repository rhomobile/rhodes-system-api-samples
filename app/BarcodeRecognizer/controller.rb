require 'rho/rhocontroller'

class BarcodeRecognizerController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Barcode index controller"
    @barcodes = BarcodeRecognizer.find(:all)
    render :back => '/app'
  end

  def new
    Camera::take_picture(url_for :action => :camera_callback)
    redirect :action => :index
  end

  def edit
    Camera::choose_picture(url_for :action => :camera_callback)
    #redirect :action => :index
    ""
  end
  
  def delete
    @image = BarcodeRecognizer.find(@params['id'])
    @image.destroy
    redirect :action => :index
  end

  def rescan
    if @params['url'] != nil
      show_barcode_info (Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['url']))) 
    end
    redirect :action => :index
  end


  def camera_callback
    WebView.navigate( url_for :action => :index )
    show_barcode_info (Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['image_uri']))) 
    ""
  end


  def camera_callback_and_add
    if @params['status'] == 'ok'
      #create image record in the DB
      image = BarcodeRecognizer.new({'image_uri'=>@params['image_uri']})
      image.save
      puts "new Image object: " + image.inspect
    end  
    WebView.navigate( url_for :action => :index )
    #WebView::refresh
    #reply on the callback
    #render :action => :ok, :layout => false
    show_barcode_info (Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['image_uri']))) 
    ""
  end

  def scan1
    show_barcode_info (Barcode.barcode_recognize(File.join(Rho::RhoApplication::get_model_path('app','BarcodeRecognizer'), 'Barcode_UPC_01.png')))
    redirect :action => :index
  end

  def scan2
    show_barcode_info (Barcode.barcode_recognize(File.join(Rho::RhoApplication::get_model_path('app','BarcodeRecognizer'), 'Barcode_UPC_02.jpg')))
    redirect :action => :index
  end

  def show_barcode_info(recognized_code)
    Alert.show_popup  ('Barcode['+recognized_code+']')  
  end

end
