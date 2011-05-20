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

  def do_p2p_enable
      # prepare NdefMessage for send to another device
      payload = Rho::NFCManager.make_payload_with_well_known_uri(0, 'http://www.rhomobile.com')
      hash = { 'id' => [0], 'type' => Rho::NdefRecord::RTD_URI, 'tnf' => Rho::NdefRecord::TNF_WELL_KNOWN, 'payload' => payload}
      record = Rho::NFCManager.make_NdefRecord_from_hash(hash)
      records = [record]
      msg = Rho::NFCManager.make_NdefMessage_from_array_of_NdefRecord(records)
      # start push message
      Rho::NFCManager.p2p_enable_foreground_nde_push(msg)

      add_to_log('Enable PUSH P2P')
      set_log($log)
  end
    
  def do_p2p_disable
      # stop push message
      Rho::NFCManager.p2p_disable_foreground_nde_push
      add_to_log('Disable PUSH P2P')
      set_log($log)
  end
    
  def do_open_app_event
      # see doc about this method - it used for process events received when application was not started or in background
      Rho::NFCManager.perform_open_application_event  
  end    
    
    
  def print_record(offset, record)
      puts offset+'Record :'
      s = offset+$offset_step+'id = '
      id_array = record['id']
      if id_array != nil
          count = id_array.size
          i = 0
          while i < count do
              s = s + id_array[i].to_s
              i = i + 1
              if i < count
                  s = s + ', '
              end    
          end    
          s = s + ' ]'
          puts s
      end        
      puts offset+$offset_step+'tnf = '+Rho::NdefRecord.convert_Tnf_to_string(record['tnf'])
      puts offset+$offset_step+'type = '+Rho::NdefRecord.convert_RTD_to_string(record['type'])
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

    
  def test_MifareClassic_read
      tag = Rho::NFCManager.get_current_Tag
      if tag != nil
              
              mifareClassic = tag.get_tech(Rho::NFCTagTechnology::MIFARE_CLASSIC)
              if mifareClassic != nil
                  puts '    MifareClassic is supported !'
                  
                  mifareClassic.connect
                  
                  connected = mifareClassic.is_connected
                  puts '  MifareClassic.isConnected() = '+connected.to_s
                  
                  type = mifareClassic.get_type
                  puts '       type = '+type.to_s+'    ['+Rho::NFCTagTechnology_MifareClassic.convert_type_to_string(type)+']'
                  
                  block_count = mifareClassic.get_block_count
                  puts '       block_count = '+block_count.to_s
                  
                  sector_count = mifareClassic.get_sector_count
                  puts '       sector_count = '+sector_count.to_s
                  
                  cur_sector = 0
                  while cur_sector < sector_count do
                      puts 'process sector no '+cur_sector.to_s 
                      blocks_in_sector = mifareClassic.get_blocks_in_sector_count(cur_sector)
                      first_block_in_sector = mifareClassic.sector_to_block(cur_sector) 
                      
                      if mifareClassic.is_connected
                          auth = mifareClassic.authenticate_sector_with_key_A(cur_sector, Rho::NFCTagTechnology_MifareClassic::KEY_DEFAULT)
                          if !auth
                              auth = mifareClassic.authenticate_sector_with_key_A(cur_sector, Rho::NFCTagTechnology_MifareClassic::KEY_MIFARE_APPLICATION_DIRECTORY)
                              
                              if !auth
                                  auth = mifareClassic.authenticate_sector_with_key_A(cur_sector, Rho::NFCTagTechnology_MifareClassic::KEY_NFC_FORUM)
                                  if auth
                                     puts '    sector authenticated by KEY_NFC_FORUM'     
                                  else 
                                      puts '    ERROR - Tag is connected but not authenticated !'
                                      puts '    Current is_connected status = '+mifareClassic.is_connected.to_s
                                  end    
                              else
                                  puts '    sector authenticated by KEY_MIFARE_APPLICATION_DIRECTORY'     
                              end    
                              
                          else
                              puts '    sector authenticated by KEY_DEFAULT'     
                          end
                      else
                          puts '   ERROR - MifareClassic tech is not connected now !' 
                      end    
                      
                      if auth  
                          cur_block = 0
                          while cur_block < blocks_in_sector do
                              
                              block_index = first_block_in_sector + cur_block
                              
                              if mifareClassic.is_connected
                                  block = mifareClassic.read_block(block_index)
                                  if block != nil 
                                      puts '        block['+block_index.to_s+']  = '+block[0].to_s+', '+block[1].to_s+', '+block[2].to_s+', '+block[3].to_s+', '+block[4].to_s+', '+block[5].to_s+', '+block[6].to_s+', '+block[7].to_s+', '+block[8].to_s+', '+block[9].to_s+', '+block[10].to_s+', '+block[11].to_s+', '+block[12].to_s+', '+block[13].to_s+', '+block[14].to_s+', '+block[15].to_s
                                  else
                                      puts '        block not readed !'
                                  end    
                              else
                                  puts '   ERROR - MifareClassic tech is not connected now !' 
                              end    
                              
                              cur_block = cur_block + 1
                          end
                      else
                          puts '    sector is not authenticated !!!'     
                      end         
                          cur_sector = cur_sector + 1    
                          
                  end    
                      
                  mifareClassic.close
                      
                else
                    puts 'MifareClassic is not supported !'
                end
                      
             else
                 puts 'Tag is NIL !'
             end	
  end    

          
          
          
          
  def test_MifareClassic_write
          tag = Rho::NFCManager.get_current_Tag
          if tag != nil
              
              mifareClassic = tag.get_tech(Rho::NFCTagTechnology::MIFARE_CLASSIC)
              if mifareClassic != nil
                  puts '    MifareClassic is supported !'
                  
                  mifareClassic.connect
                  
                  connected = mifareClassic.is_connected
                  puts '  MifareClassic.isConnected() = '+connected.to_s
                  
                  type = mifareClassic.get_type
                  puts '       type = '+type.to_s+'    ['+mifareClassic.convert_type_to_string(type)+']'
                  
                  block_count = mifareClassic.get_block_count
                  puts '       block_count = '+block_count.to_s
                  
                  sector_count = mifareClassic.get_sector_count
                  puts '       sector_count = '+sector_count.to_s
                  
                  
                  test_sector = 3
                  auth = mifareClassic.authenticate_sector_with_key_A(test_sector, Rho::NFCTagTechnology_MifareClassic::KEY_NFC_FORUM)
                  if auth
                      first_block_in_sector = mifareClassic.sector_to_block(test_sector)
                      
                      puts '       srite test data to block '+first_block_in_sector.to_s
                      
                      test_block = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
                      mifareClassic.write_block(first_block_in_sector, test_block)

                  else
                      puts '      Authentification is not passed !!!'
                  end    
                  
                      
                  mifareClassic.close
                      
              else
                  puts 'MifareClassic is not supported !'
              end
                      
          else
              puts 'Tag is NIL !'
          end	
          
  end        
    
      
      
  def test_Ndef_read
      tag = Rho::NFCManager.get_current_Tag
      if tag != nil
          
          ndef = tag.get_tech(Rho::NFCTagTechnology::NDEF)
          if ndef != nil
              puts '  Ndef is supported !'
              
              ndef.connect
              
              connected = ndef.is_connected
              puts '  Ndef.isConnected() = '+connected.to_s
              
              type = ndef.get_type
              puts '       type = '+type

              puts '       max_size = '+ndef.get_max_size.to_s
              puts '       is_writable = '+ndef.is_writable.to_s
              puts '       can_make_read_only = '+ndef.can_make_read_only.to_s
              
              msg = ndef.read_NdefMessage

              puts '      message readed !' 
              
              records = msg.get_records
              
              r_a = []
              
              i = 0
              puts '  records count = '+records.size.to_s
              while i < records.size do
                 r_a << records[i].make_hash 
                 i = i+1
              end
              
              msg_hash = {'records' => r_a}

              puts '  Ndef Message :'    
                  
              print_message('    ', msg_hash)    
                  
              ndef.close
              
              else
              puts 'Ndef is not supported !'
          end
          
          else
          puts 'Tag is NIL !'
      end	
      
  end    
      
      
      
      
      
  def test_Ndef_write
      tag = Rho::NFCManager.get_current_Tag
      if tag != nil
          
          ndef = tag.get_tech(Rho::NFCTagTechnology::NDEF)
          if ndef != nil
              puts '  Ndef is supported !'
              
              ndef.connect
              
              connected = ndef.is_connected
              puts '  Ndef.isConnected() = '+connected.to_s
              
              type = ndef.get_type
              puts '       type = '+type

              puts '       max_size = '+ndef.get_max_size.to_s
              puts '       is_writable = '+ndef.is_writable.to_s
              puts '       can_make_read_only = '+ndef.can_make_read_only.to_s
              
              
              payload = Rho::NFCManager.make_payload_with_well_known_uri(0, 'http://www.rhomobile.com')
              
              hash = { 'id' => [0], 'type' => Rho::NdefRecord::RTD_URI, 'tnf' => Rho::NdefRecord::TNF_WELL_KNOWN, 'payload' => payload}
              
              record = Rho::NFCManager.make_NdefRecord_from_hash(hash)
              
              records = [record]
              
              msg = Rho::NFCManager.make_NdefMessage_from_array_of_NdefRecord(records)


              # already prepared TEXT record
              #text_msg_raw = [ 0xd1,  0x01,  0x1c,  0x54,  0x02,  0x65,
              #     0x6e,  0x53,  0x6f,  0x6d,  0x65,  0x20,
              #     0x72,  0x61,  0x6e,  0x64,  0x6f,  0x6d,
              #     0x20,  0x65,  0x6e,  0x67,  0x6c,  0x69,
              #     0x73,  0x68,  0x20,  0x74,  0x65,  0x78,
              #     0x74,  0x2e]
              #msg = Rho::NFCManager.make_NdefMessage_from_byte_array(text_msg_raw)
              
              puts ' write test NdefMessage with Rhomobile URI'
              
              
              ndef.write_NdefMessage(msg)
              
              puts ' finish write NdefMessage'
                  
              ndef.close
              
          else
              puts 'Ndef is not supported !'
          end
          
      else
          puts 'Tag is NIL !'
      end	
          
  end 
      
      
      
      
    
  def nfc_tech_callback
      puts 'NfcController.nfc_tech_callback START'
      event = @params['Tag_event']
      add_to_log('TECH received !')

      puts 'Tag_event :'+event

      tag = Rho::NFCManager.get_current_Tag
      if tag != nil
           puts 'Tag get from Manager OK'	
          
           id = tag.get_ID
          
           if id != nil
               s = '  Tag ID = [ '
               count = id.size
               i = 0
               while i < count do
                   s = s + id[i].to_s
                   i = i + 1
                   if i < count
                       s = s + ', '
                   end    
               end    
               s = s + ' ]'
               puts s    
           else
               puts 'Tag ID is NIL !'
           end    
           
           techList = tag.get_tech_list
           puts 'tech list = '
           puts techList
           puts ''
               
               
           test_MifareClassic_read
           #test_MifareClassic_write    
           
           test_Ndef_read
           #test_Ndef_write    


      else
           puts 'Tag is NIL !'
      end	

      set_log($log)
      puts 'NfcController.nfc_tech_callback FINISH'
  end


end
