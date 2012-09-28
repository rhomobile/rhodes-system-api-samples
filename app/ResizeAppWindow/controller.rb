require 'rho/rhocontroller'

class ResizeAppWindowController < Rho::RhoController

  #GET /ResizeAppWindow
  def index
    puts "ResizeAppWindow index controller"
    render :back => '/app'  	
  end

  def move_window_to_default_position
    System.set_window_position(0, 0)
    render :action => :index
  end

  def move_window_to_test_position
    System.set_window_position(200, 200)
    render :action => :index
  end

  def set_default_screen_size
    System.set_window_size(400, 600)
    render :action => :index
  end

  def set_iphone3gs_screen_size
    System.set_window_size(320, 480)
    render :action => :index
  end

  def set_ipad2_screen_size
    System.set_window_size(1024, 768)
    render :action => :index
  end

  def disable_resize
    System.lock_window_size(1)
    render :action => :index
  end

  def enable_resize
    System.lock_window_size(0)
    render :action => :index
  end

end
