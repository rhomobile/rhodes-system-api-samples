require 'rho/rhocontroller'

class GeoLocationController < Rho::RhoController
  @layout = 'GeoLocation/layout'
  
  def index
    puts "GeoLocation index controller"
    if System::get_property('platform') == 'Blackberry'
        set_geoview_notification url_for(:action => :geo_callback), "", 2
    else
        GeoLocation.set_notification url_for(:action => :geo_callback), "mytag=55", 3
    end
    render :back => '/app'
  end
  
  def geo_callback
    puts "$$$$$$$$$$$ GEOCALLBACK : $$$$$$$$$$$$$$$"
    puts "geo_callback : #{@params}"

    if WebView.current_location !~ /GeoLocation/
        puts "Stopping geo location since we are away of geo page: " + WebView.current_location
        puts "########## GEOLOCATION TURNOFF ###############"
        GeoLocation.turnoff
        return
    end
    
    if @params['known_position'].to_i != 0 && @params['status'] =='ok'
        if System::get_property('platform') == 'Blackberry'
            WebView.refresh
        else
            WebView.execute_js("updateLocation(#{@params['latitude']}, #{@params['longitude']})")
        end
    end
  end
  
  def show 
    render :action => :show
  end

  def preload_callback
       puts '@@@@@@@@@      Preload Callback       STATUS['+@params['status']+']   PROGRESS['+@params['progress']+']'
  end

  def preload_map
      puts '$$$ preload map START'
      
      options = { :engine => @params['provider'],
          :map_type => @params['map_type'],
          :top_latitude => 60.1,
          :left_longitude => 30.0,
          :bottom_latitude => 59.7,
          :right_longitude => 30.6,
          :min_zoom => 9,
          :max_zoom => 11
        }
      count = MapView.preload_map_tiles(options, url_for(:action => :preload_callback))    
      puts '$$$ preload map FINISH   count = '+count.to_s
      redirect :action => :index
  end

  def showmap
     puts @params.inspect
     
    if System::get_property('platform') != 'Blackberry'
        GeoLocation.set_notification "", ""
    end
     
     #pin color
     if @params['latitude'].to_i == 0 and @params['longitude'].to_i == 0
       #@params['latitude'] = '37.349691'
       #@params['longitude'] = '-121.983261'
       @params['latitude'] = '59.9'
       @params['longitude'] = '30.3'
     end
     
     region = [@params['latitude'], @params['longitude'], 0.6, 0.6]     
     #region = {:center => @params['latitude'] + ',' + @params['longitude'], :radius => 0.2}

     myannotations = []

     myannotations <<   {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014", :url => "/app/GeoLocation/show?city=Cupertino", :pass_location => true }
     myannotations << {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051", :url => "/app/GeoLocation/show?city=Santa%20Clara", :pass_location => true }

     #  add annotation with customized image :
     myannotations << {:latitude => '60.0270', :longitude => '30.299', :title => "Original Location", :subtitle => "orig test", :url => "/app/GeoLocation/show?city=Original_Location", :pass_location => true}	
     myannotations << {:latitude => '60.0270', :longitude => '30.33', :title => "Red", :subtitle => "r tst", :url => "/app/GeoLocation/show?city=Red_Location", :image => '/public/images/marker_red.png', :image_x_offset => 8, :image_y_offset => 32, :pass_location => true }
     myannotations << {:latitude => '60.0270', :longitude => '30.36', :title => "Green Location", :subtitle => "green test", :image => '/public/images/marker_green.png', :image_x_offset => 8, :image_y_offset => 32, :pass_location => true }
     myannotations << {:latitude => '60.0270', :longitude => '30.39', :title => "Blue Location Bla-Bla-Bla !!!", :subtitle => "blue test1\nblue test2\nblue 1234567890 1234567890 1234567890 test3", :url => "/app/GeoLocation/show?city=Blue_Location", :image => '/public/images/marker_blue.png', :image_x_offset => 8, :image_y_offset => 32, :pass_location => true }





     myannotations << {:latitude => '60.1', :longitude => '30.0', :title => "PRELOAD MARKER"}	
     myannotations << {:latitude => '59.7', :longitude => '30.0', :title => "PRELOAD MARKER"}	
     myannotations << {:latitude => '60.1', :longitude => '30.6', :title => "PRELOAD MARKER"}	
     myannotations << {:latitude => '59.7', :longitude => '30.6', :title => "PRELOAD MARKER"}



    map_params = {
          :provider => @params['provider'],
          :settings => {:map_type => "roadmap", :region => region,
                        :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => true, :api_key => '0jDNua8T4Teq0RHDk6_C708_Iiv45ys9ZL6bEhw'},
          :annotations => myannotations
     }

     #if @params['provider'] == 'RhoGoogle'
         MapView.set_file_caching_enable(1)
     #end 














     puts map_params.inspect            

















     MapView.create map_params
     redirect :action => :index
  end


  def showmap_250
     puts @params.inspect
     #pin color
     if @params['latitude'].to_i == 0 and @params['longitude'].to_i == 0
       @params['latitude'] = '37.349691'
       @params['longitude'] = '-121.983261'
     end
     
     region = [@params['latitude'], @params['longitude'], 0.2, 0.2]     
     #region = {:center => @params['latitude'] + ',' + @params['longitude'], :radius => 0.2}

     myannotations = []
     2500.times do |j|
          annotation = {:latitude => @params['latitude'], :longitude => @params['longitude'], :title => "Current location", :subtitle => "test", :url => "/app/GeoLocation/show?city=Current Location"}	
          myannotations << annotation
     end

     myannotations <<   {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014", :url => "/app/GeoLocation/show?city=Cupertino", :pass_location => true }
     myannotations << {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051", :url => "/app/GeoLocation/show?city=Santa%20Clara", :pass_location => true }

     map_params = {
          :provider => @params['provider'],
          :settings => {:map_type => "roadmap", :region => region,
                        :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => true, :api_key => '0jDNua8T4Teq0RHDk6_C708_Iiv45ys9ZL6bEhw'},
          :annotations => myannotations
     }

     puts map_params.inspect            
     MapView.create map_params
     redirect :action => :index
  end



def showmap_coding
     puts @params.inspect
     #pin color
     region = {:center => 'NG10 3XL', :radius => 0.2}

    # Build up the parameters for the call
    map_params = {
        :provider => @params['provider'],
        # General settings for the map, type, viewable area, zoom, scrolling etc.
        # We center on the user, with 0.2 degrees view
        :settings => {:map_type => "roadmap",:region => region,
            :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false
        }#,
        # This annotation shows the user, give the marker a title, and a link directly to that user
        #:annotations => [{
        #    :title => "TEST",
        #    :subtitle => "TEST"
        #}]
    }

     puts map_params.inspect            
     MapView.create map_params
     redirect :action => :index
  end        



end
