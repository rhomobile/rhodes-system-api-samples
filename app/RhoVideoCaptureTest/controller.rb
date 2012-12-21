require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class RhoVideoCaptureTestController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  @layout = 'RhoVideoCaptureTest/layout'
  
  def index
    render :back => '/app'
  end


  def vc_start
      puts 'VideoCaptureTest::vc_start'
      #VideoCapture::name = 'myvideo.mov'
      VideoCapture.destination = File.join(Rho::RhoApplication::get_user_path(), 'myvideo.mov')
      VideoCapture.duration = 10000
      VideoCapture.videoSaveEvent = url_for(:action => :vc_callback)
      VideoCapture.start
  end


  def vc_stop
      puts 'VideoCaptureTest::vc_stop'
      VideoCapture.stop
  end


  def vc_cancel
      puts 'VideoCaptureTest::vc_cancel'
      VideoCapture.cancel
  end


  def vc_play
      System.open_url(File.join(Rho::RhoApplication::get_user_path(), 'myvideo.mov'))
   end

  def vc_callback
      puts 'VideoCapture::callback    STATUS = ' +  @params['status']
  end

  
end
