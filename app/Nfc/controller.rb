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
    Rho::NFCManager.set_nfc_tech_callback(url_for(:action => :nfc_tech_callback))
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

  def nfc_tech_callback
      puts 'NfcController.nfc_tech_callback START'
      event = @params['Tag_event']
      add_to_log('TECH received !')

      puts 'Tag_event :'+event

      tag = Rho::NFCManager.get_current_Tag
      if tag != nil
           puts 'Tag get from Manager OK'	
           
           techList = tag.get_tech_list
           puts 'tech list = '
           puts techList

           mifareClassic = tag.get_tech(Rho::NFCTagTechnology::MIFARE_CLASSIC)
           if mifareClassic != nil
                  puts 'MifareClassic is supported !'
 
                  mifareClassic.connect

                  connected = mifareClassic.is_connected
                  puts ' MifareClassic.isConnected() = '+connected.to_s

                  block_count = mifareClassic.get_block_count
                  puts '       block_count = '+block_count.to_s

                  sector_count = mifareClassic.get_sector_count
                  puts '       sector_count = '+sector_count.to_s
               
                  cur_sector = 0
                  while cur_sector < sector_count do
                     puts 'process sector no '+cur_sector.to_s 
                     blocks_in_sector = mifareClassic.get_blocks_in_sector_count(cur_sector)
                     first_block_in_sector = mifareClassic.sector_to_block(cur_sector) 

                     auth = mifareClassic.authenticate_sector_with_key_A(cur_sector, Rho::NFCTagTechnology_MifareClassic::KEY_DEFAULT)
                     if !auth
                         auth = mifareClassic.authenticate_sector_with_key_A(cur_sector, Rho::NFCTagTechnology_MifareClassic::KEY_MIFARE_APPLICATION_DIRECTORY)
                         
                         if !auth
                             auth = mifareClassic.authenticate_sector_with_key_A(cur_sector, Rho::NFCTagTechnology_MifareClassic::KEY_NFC_FORUM)
                             if auth
                                 puts 'sector authenticated by KEY_NFC_FORUM'     
                             end    
                         else
                             puts 'sector authenticated by KEY_MIFARE_APPLICATION_DIRECTORY'     
                         end    
                         
                     else
                         puts 'sector authenticated by KEY_DEFAULT'     
                     end
                      
                      
                     if auth  
                          cur_block = 0
                          while cur_block < blocks_in_sector do
                         
                                block_index = first_block_in_sector + cur_block
                         
                              block = mifareClassic.read_block(block_index)                   
                              puts 'block['+block_index.to_s+'] :'
                              puts block
                         
                               cur_block = cur_block + 1
                          end
                     else
                         puts 'sector is not authenticated !!!'     
                     end         
                     cur_sector = cur_sector + 1    
                      
                  end    
               

          else
                  puts 'MifareClassic is not supported !'
           end

      else
           puts 'Tag is NIL !'
      end	

      set_log($log)
      puts 'NfcController.nfc_tech_callback FINISH'
  end


end
