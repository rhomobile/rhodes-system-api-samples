require 'rho/rhocontroller'

class CameraController < Rho::RhoController
  @layout = :simplelayout
  
  def index
    puts "Camera index controller"
    @images = Image.find(:all)
    render
  end

  def new
    Camera::take_picture(url_for :action => :camera_callback)
    redirect :action => :index
  end

  def edit
    Camera::choose_picture(url_for :action => :camera_callback)
    redirect :action => :index
  end
  
  def delete
    @image = Image.find(@params['id'])
    @image.destroy
    redirect :action => :index
  end

  def camera_callback
    if @params['status'] == 'ok'
      #create image record in the DB
      image = Image.new({'image_uri'=>@params['image_uri']})
      image.save
      puts "new Image object: " + image.inspect
      #WebView::refresh
    end  
    #reply on the callback
    render :action => :ok, :layout => false
  end
      
end
