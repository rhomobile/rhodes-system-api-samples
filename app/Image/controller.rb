require 'rho/rhocontroller'

class ImageController < Rho::RhoController
  #@layout = :simplelayout
  @layout = 'Image/layout'

  $camera_main = 'NONE'
  $camera_front = 'NONE'
  
  def index
    puts "Camera index controller"
    @images = Image.find(:all)

    main_info = Camera::get_camera_info('main')
    if main_info != nil
         $camera_main = 'YES , '+main_info['max_resolution']['width'].to_s+'x'+main_info['max_resolution']['height'].to_s
    end	
    front_info = Camera::get_camera_info('front')
    if front_info != nil
         $camera_front = 'YES , '+front_info['max_resolution']['width'].to_s+'x'+front_info['max_resolution']['height'].to_s
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

    settings = { :camera_type => @params['camera_type'], :color_model => @params['color_model'], :enable_editing => en_ed, :desired_width => width, :desired_height => height }
    Camera::take_picture(url_for(:action => :camera_callback), settings)
  end

  def edit
    Camera::choose_picture(url_for :action => :camera_callback)
    
    #redirect :action => :index
    ""
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
      if ((System::get_property('platform') == 'ANDROID') || (System::get_property('platform') == 'APPLE'))
           img_width = @params['image_width']
           img_height = @params['image_height']
           img_format = @params['image_format']
           puts ' Captured Image  Size:  '+img_width.to_s+'x'+img_height.to_s+',  Format: '+img_format
      end
    end  
    WebView.navigate( url_for :action => :index )
    #WebView::refresh
    #reply on the callback
    #render :action => :ok, :layout => false
    ""
  end
      
end
