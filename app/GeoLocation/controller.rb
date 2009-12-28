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
     if System.get_property('platform') == 'Blackberry'
       # Temporary fork for bb: just to be sure it's working. Will be changed to common interface soon
       MapView.create(GeoLocation.latitude, GeoLocation.longitude, 4)
     else
       puts @params.inspect
       #pin color
       map_params = {
            :settings => {:map_type => "hybrid",:region => [@params['latitude'], @params['longitude'], 0.2, 0.2],
                          :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false},
            :annotations => [{:latitude => @params['latitude'], :longitude => @params['longitude'], :title => "Current location", :subtitle => ""},
                             {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014", :url => "/app/GeoLocation/show?city=Cupertino"},
                             {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051", :url => "/app/GeoLocation/show?city=Santa%20Clara"}]
       }
       puts map_params.inspect            
       MapView.create map_params
     end
     redirect :action => :index
  end
        
end
