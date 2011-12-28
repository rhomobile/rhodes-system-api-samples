require 'rho/rhocontroller'

class BarcodeRecognizerMotoController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Moto Barcode index controller"
    @scanners = Barcode.enumerate()
    puts "@scanners : #{@scanners}"
    render :back => '/app'
  end

  def take
      #Barcode.stop
      scanner = @params['scanner']
      puts "take - using scanner: #{scanner}"
      Barcode.take_barcode(url_for(:action => :take_callback), {:name => scanner})
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
          Alert.show_popup(
              :message => "Barcode["+barcode.to_s+"]",
              :title => "Take barcode",
              :buttons => ["Ok"]
          )
      elsif status == 'cancel'
          Alert.show_popup(
              :message => "Barcode taking was canceled !",
              :title => "Take barcode",
              :buttons => ["Ok"]
          )
      end
      #Barcode.disable
      WebView.navigate(url_for(:action => :index))
  end

  def multiscan
    scanner = @params['scanner']
    puts "multiscan - using scanner: #{scanner}"
    $barcodes = []
    Barcode.enable( url_for(:action => :multi_callback), {:name => scanner})
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
