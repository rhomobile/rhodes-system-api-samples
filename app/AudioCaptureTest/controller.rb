require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class AudioCaptureTestController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  @layout = 'AudioCaptureTest/layout'
  
  def index
    render :back => '/app'
  end


  def sc_start

      #AudioCapture::name = 'mysound.wav'
      AudioCapture.destination = File.join(Rho::RhoApplication::get_user_path(), 'mysound.wav')
      AudioCapture.duration = 5000
      AudioCapture.audioSaveEvent = url_for(:action => :sc_callback)
      AudioCapture.start

  end


  def sc_stop
      AudioCapture.stop
  end


  def sc_cancel
      AudioCapture.cancel
  end


  def sc_play
      #Alert.play_file File.join(Rho::RhoApplication::get_user_path(), 'mysound.wav')
      System.open_url(File.join(Rho::RhoApplication::get_user_path(), 'mysound.wav'))
      #redirect :action => :index
  end

  def sc_callback
      puts 'AudioCapture::callback    STATUS = ' +  @params['status']
  end

  
end
