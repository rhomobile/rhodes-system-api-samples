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

      puts 'BarcodeRecognizer::take_callback !'
      puts 'status = '+status.to_s unless status == nil
      puts 'barcode = '+barcode.to_s unless barcode == nil

      if status == 'ok'
           Alert.show_popup  ('Barcode['+recognized_code.to_s+']')  
      elsif status == 'cancel'
           Alert.show_popup  ('Barcode taking was canceled !')  
      end

      #Barcode.disable      
      redirect :action => :index
  end

end
