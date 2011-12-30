require 'rho/rhocontroller'

class BarcodeRecognizerMotoController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Moto Barcode index controller"
    
    if System::get_property('platform') == 'ANDROID'
      @scanners = [{'id'=>'SCN1', 'name'=>'Camera'}]
    else
      @scanners = Barcode.enumerate()
    end
    puts "@scanners : #{@scanners}"
    
    render :back => '/app'
  end

  def take
      #Barcode.stop
  
      Barcode.take_barcode(url_for(:action => :take_callback), {})
      #Barcode.take_barcode(url_for(:action => :take_callback), {:camera => 'front'})
      redirect :action => :wait
  end

  def cancel_take
      #Barcode.stop
      Barcode.disable
      
      redirect :action => :index
  end
  
  def take_callback
      status = @params['status']
      barcode = @params['barcode']

      puts 'take_callback'
      puts 'status = '+status.to_s unless status == nil
      puts 'barcode = '+barcode.to_s unless barcode == nil

      if status == 'ok'
           Alert.show_popup  ('Barcode['+barcode.to_s+']')  
      elsif status == 'cancel'
           Alert.show_popup  ('Barcode taking was canceled !')  
      end

      #Barcode.disable      
      redirect :action => :index
  end

  def multiscan
    $barcodes = []
    Barcode.enable( url_for(:action => :multi_callback), {})
    redirect :action => :show_barcodes
  end

  def multi_callback
      status = @params['status']
      barcode = @params['barcode']

      puts 'multi_callback'
      puts 'status = '+status.to_s unless status == nil
      puts 'barcode = '+barcode.to_s unless barcode == nil

      $barcodes += [barcode] if status == 'ok'
      
      WebView.refresh
  end
  
  def show_barcodes
    render :back => 'callback:' + url_for(:action => :go_back)
  end
  
  def go_back
    Barcode.disable
    WebView.navigate url_for(:action => :index)
  end
  
  def start_scan
    Barcode.start
    redirect :action => :show_barcodes        
  end

  def stop_scan
    Barcode.stop
    redirect :action => :show_barcodes        
  end
     
end
