require 'rho/rhocontroller'

class GeoLocationController < Rho::RhoController
  @layout = 'GeoLocation/layout'
  
  def index
    puts "GeoLocation index controller"
    render
  end
  
  def show 
    render :action => :show
  end

  def showmap
     puts @params.inspect
     #pin color
     if @params['latitude'].to_i == 0 and @params['longitude'].to_i == 0
       @params['latitude'] = '37.349691'
       @params['longitude'] = '-121.983261'
     end
     map_params = {
          :settings => {:map_type => "roadmap",:region => [@params['latitude'], @params['longitude'], 0.2, 0.2],
                        :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => true},
          :annotations => [{:latitude => @params['latitude'], :longitude => @params['longitude'], :title => "Current location", :subtitle => "test", :url => "/app/GeoLocation/show?city=Cupertino"},
                           {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014", :url => "/app/GeoLocation/show?city=Cupertino"},
                           {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051", :url => "/app/GeoLocation/show?city=Santa%20Clara"}]
     }
     puts map_params.inspect            
     MapView.create map_params
     redirect :action => :index
  end
        
end
