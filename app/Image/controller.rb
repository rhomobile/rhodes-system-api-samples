require 'rho/rhocontroller'

class ImageController < Rho::RhoController
  #@layout = :simplelayout
  @layout = 'Image/layout'

  $camera_main = 'NONE'
  $camera_front = 'NONE'

  $use_new_api = true
  
  def index
    puts "Camera index controller"
    @images = Image.find(:all)

    if $use_new_api
        main_info = Camera::get_camera_info('main')
        if main_info != nil
             $camera_main = 'YES , '+main_info['max_resolution']['width'].to_s+'x'+main_info['max_resolution']['height'].to_s
        end	
        front_info = Camera::get_camera_info('front')
        if front_info != nil
             $camera_front = 'YES , '+front_info['max_resolution']['width'].to_s+'x'+front_info['max_resolution']['height'].to_s
        end
    end
    render :back => '/app'
  end

  def new
    Camera::take_picture(url_for(:action => :camera_callback))
    redirect :action => :index
  end

  def on_take
    puts 'Image.on_take() !'
    en_ed = (@params['enable_editing'] == 'enable')
    pr_size = @params['preferred_size']
    width = 0
    height = 0
    if pr_size == 'size1'
        width = 1000
        height = 1000
    end
    if pr_size == 'size2'
        width = 100
        height = 100
    end

    settings = { :camera_type => @params['camera_type'], :color_model => @params['color_model'], :enable_editing => en_ed, :desired_width => width, :desired_height => height, :flash_mode => 'auto' }
    Camera::take_picture(url_for(:action => :camera_callback), settings)
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
	
  def save_to_gallery
	  img = Image.find(@params['id'])
	  Camera::save_image_to_device_gallery(Rho::RhoApplication::get_blob_path(img.image_uri))
	  redirect :action => :index
  end
  
  def open_image
    puts @params.inspect
    Rho::System.open_url(@params['url'])
    redirect :action => :index
  end

  def camera_callback
    if @params['status'] == 'ok'
      #create image record in the DB
      image = Image.new({'image_uri'=>Rho::Application.relativeDatabaseBlobFilePath(@params['image_uri'])})
      image.save
      puts "new Image object: " + image.inspect
      if (((System::get_property('platform') == 'ANDROID') || (System::get_property('platform') == 'APPLE')) && ($use_new_api))
           img_width = @params['image_width']
           img_height = @params['image_height']
           img_format = @params['image_format']
           puts "Captured Image  Size: #{img_width}x#{img_height}, Format: #{img_format} "
      end
    end  
    WebView.navigate( url_for :action => :index )
    #WebView::refresh
    #reply on the callback
    #render :action => :ok, :layout => false
    ""
  end
      
end
