require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class RawSensorsTestController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  @layout = 'RawSensorsTest/layout'

  $accelerator_x = ''
  $accelerator_y = ''
  $accelerator_z = ''
  $magnetometer_x = ''
  $magnetometer_y = ''
  $magnetometer_z = ''

  $accelerator_available = false
  $magnetometer_available = false


  def index
    $accelerator_available = RawSensors.is_available('accelerometer')
    $magnetometer_available = RawSensors.is_available('magnetometer')
    RawSensors.sensorEvent = url_for(:action => :sensors_callback)
    RawSensors.minimumInterval = 200
    render :back => '/app'
  end

  def sensors_callback
      if  @params['status'] == 'OK'
           accelerometer_x = @params['accelerometerX']
           if accelerometer_x != nil
               WebView.execute_js('document.getElementById("id_accelerometer_x").value="'+accelerometer_x+'"')
           end
           accelerometer_y = @params['accelerometerY']
           if accelerometer_y != nil
               WebView.execute_js('document.getElementById("id_accelerometer_y").value="'+accelerometer_y+'"')
           end
           accelerometer_z = @params['accelerometerZ']
           if accelerometer_z != nil
               WebView.execute_js('document.getElementById("id_accelerometer_z").value="'+accelerometer_z+'"')
           end
           magnetometer_x = @params['magnetometerX']
           if magnetometer_x != nil
               WebView.execute_js('document.getElementById("id_magnetometer_x").value="'+magnetometer_x+'"')
           end
           magnetometer_y = @params['magnetometerY']
           if magnetometer_y != nil
               WebView.execute_js('document.getElementById("id_magnetometer_y").value="'+magnetometer_y+'"')
           end
           magnetometer_z = @params['magnetometerZ']
           if magnetometer_z != nil
               WebView.execute_js('document.getElementById("id_magnetometer_z").value="'+magnetometer_z+'"')
           end


      else
          puts 'RawSensorsTest::sensors callback - receive ERROR !'
      end
  end


  def fire_update
      RawSensors.minimumInterval = 10000
      RawSensors.all = true
      RawSensors.getSensorData	
  end

  def start_update
      puts 'RawSensorsTest::start_update'
      RawSensors.all = true
      RawSensors.minimumInterval = 200
  end

  def stop_update
      puts 'RawSensorsTest::stop_update'
      RawSensors.all = false
      WebView.execute_js('document.getElementById("id_accelerometer_x").value=""')
      WebView.execute_js('document.getElementById("id_accelerometer_y").value=""')
      WebView.execute_js('document.getElementById("id_accelerometer_z").value=""')
      WebView.execute_js('document.getElementById("id_magnetometer_x").value=""')
      WebView.execute_js('document.getElementById("id_magnetometer_y").value=""')
      WebView.execute_js('document.getElementById("id_magnetometer_z").value=""')

  end
  
end
