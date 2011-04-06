require 'rho/rhocontroller'
require 'nfc'

 
class NfcController < Rho::RhoController
  @layout = 'Nfc/layout'


  $status = ''
  $log = ''
  $supported = ''	

  $offset_step = '    '

  def index
    $status = Rho::NFCManager.is_enabled.to_s
    $supported = Rho::NFCManager.is_supported.to_s
    $log = ''
    Rho::NFCManager.set_nfc_callback(url_for(:action => :nfc_callback))
    puts 'NfcController.index'
    render
  end

  def add_to_log(ttt)
     $log = $log + '\n' + ttt
  end

  def set_log(log)
    WebView.execute_js('setLog("'+log+'");')
  end

  def set_status(status)
    WebView.execute_js('setStatus("'+status+'");')
  end

  def do_enable
       Rho::NFCManager.enable
       $status = Rho::NFCManager.is_enabled.to_s
       set_status($status)    
  end

  def do_disable
       Rho::NFCManager.disable
       $status = Rho::NFCManager.is_enabled.to_s
       set_status($status)    
  end

  def print_record(offset, record)
      puts offset+'Record :'
      puts offset+$offset_step+'tnf = '+Rho::NFCManager.convert_Tnf_to_string(record['tnf'])
      puts offset+$offset_step+'type = '+Rho::NFCManager.convert_RTD_to_string(record['type'])
      puts offset+$offset_step+'payload_as_string = '+record['payload_as_string']
      subrecords = record['subrecords']
      if subrecords != nil
           puts offset+$offset_step+'Subrecords :'
           print_message(offset+$offset_step+$offset_step, subrecords)
      end
  end

  def print_message(offset, message)
      puts offset+'Message :'
      records = message['records']
      puts offset+$offset_step+'Records :'
      records.each do |r|
            print_record(offset+$offset_step+$offset_step, r)
      end
  end

  def nfc_callback
      puts 'NfcController.nfc_callback START'
      messages = @params['messages']
      add_to_log('TAG received !')

      puts 'NFC Messages :'
      messages.each do |m|
            print_message($offset_step, m)
      end

      set_log($log)
      puts 'NfcController.nfc_callback FINISH'
  end

end
