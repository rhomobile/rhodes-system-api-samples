require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'


class CameraController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  def index
    Rho::Camera.enumerate url_for(:action => :enumCallback) unless $cameraList
    render
  end
  
  def camera
    render :camera
  end
  
  def enumCallback
    puts @params.inspect
    $cameraList = @params['result'] if (@params['result'])
    Rho::WebView.navigate(url_for(:action => :index))
  end
  
  def takePicture
    
    options = {
        :outputFormat => @params['outputFormat'],
        :colorModel => @params['colorModel'],
        :fileName => File.join(Rho::Application.databaseBlobFolder, 'sample')
              }
    if @params['size']
        options[:desiredWidth] = $cameraSizeList[@params['size'].to_i]['width'].to_s
        options[:desiredHeight] = $cameraSizeList[@params['size'].to_i]['height'].to_s
    end
    options['saveToDeviceGallery'] = 'true' if (@params['target'] == 'gallery')
    
    $cameraList[@params['cameraIdx'].to_i].takePicture options, url_for(:action => :takeCallback)
    redirect :action => :index
  end
  
  def systemApp
    options = {:useSystemViewfinder => "true", :outputFormat => "image", :fileName => "#{Rho::Application.databaseBlobFolder}/sample"}
    $cameraList.first.takePicture options, url_for(:action => :takeCallback)
    render :index
  end
  
  def choose
    options = {:fileName => "#{Rho::Application.databaseBlobFolder}/sample"}
    Rho::Camera.choosePicture options, url_for(:action => :takeCallback)
    redirect :action => :index
  end
  
  def open
    Rho::System.openUrl @params['url']
    render :index
  end
  
  def takeCallback
    puts @params.inspect
    $sample = @params['imageUri'] if (@params['imageUri'])
    Rho::WebView.navigate(url_for(:action => :index))
  end
end
