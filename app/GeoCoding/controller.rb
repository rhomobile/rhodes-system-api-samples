require 'rho/rhocontroller'
require 'json'

class GeoCodingController < Rho::RhoController

$status = ''
$adress = ''
$latitude = ''
$longitude = ''

  
  def index
    puts "GeoCoding index controller"
    render :back => '/app'
  end
  
  def prepare_direct_geocoding_url(latitude, longitude)
      url = 'http://maps.googleapis.com/maps/api/geocode/json?'
      url = url + 'latlng='+latitude.to_s+','+longitude.to_s
      url = url + '&sensor=false'
      return url
  end

  def prepare_inverse_geocoding_url(adress)
      url = 'http://maps.googleapis.com/maps/api/geocode/json?'
      url = url + 'address='+Rho::RhoSupport.url_encode(adress)
      url = url + '&sensor=false'
      return url
  end

  def do_direct_geocoding
      adress = @params['adress']      
      Rho::AsyncHttp.get(
            :url => prepare_inverse_geocoding_url(adress),
            :callback => (url_for :action => :httpget_callback)
      )
      render :action => :wait
  end


  def do_inverse_geocoding  
      latitude = @params['latitude']      
      longitude = @params['longitude']      
      Rho::AsyncHttp.get(
            :url => prepare_direct_geocoding_url(latitude, longitude),
            :callback => (url_for :action => :httpget_callback)
      )
      render :action => :wait
  end

  
  def httpget_callback
      body = @params['body']
      # body already converted to Hash because it is JSON data !      
      body = Rho::JSON.parse(body)

      $adress = ''
      $latitude = ''
      $longitude = ''

      if @params["status"] == "ok"
        
          # firstly check JSON result status
          json_status = body['status']

          if json_status != nil && json_status == 'OK' 

              $status = 'OK'
              json_results = body['results']
              
              if json_results != nil
                   
                   # get formatted adress
                   formatted_adress = json_results[0]['formatted_address']
                   if formatted_adress != nil
                        $adress = formatted_adress.to_s
                   end
                   
                   # get coordinates
                   json_geometry = json_results[0]['geometry']
                   if json_geometry != nil
                        json_location = json_geometry['location']
                        if json_location != nil
                             $latitude = json_location['lat'].to_s unless json_location['lat'].nil?
                             $longitude = json_location['lng'].to_s unless json_location['lng'].nil?
                        end 
                   end
              end

          else
              $status = json_status
          end 

      else
          $status = @params["status"]
      end

      WebView.navigate( url_for(:action => :index) )
  end

  def cancel_request
      Rho::AsyncHttp.cancel
      $status = 'canceled'
      $adress = ''
      $latitude = ''
      $longitude = ''
      render :action => :index
  end

end


#Example of received data :
#[
#  {
#    "address_components"=>[
#                           {"long_name"=>"6", "short_name"=>"6", "types"=>["street_number"]},
#                           {"long_name"=>"ulitsa Shcherbakova", "short_name"=>"ulitsa Shcherbakova", "types"=>["route"]}, 
#                           {"long_name"=>"Primorskiy rayon", "short_name"=>"Primorskiy rayon", "types"=>["sublocality", "political"]},
#                           {"long_name"=>"St Petersburg", "short_name"=>"St Petersburg", "types"=>["locality", "political"]}, 
#                           {"long_name"=>"Russian Federation", "short_name"=>"RU", "types"=>["country", "political"]}
#                           ], 
#    "formatted_address"=>"ulitsa Shcherbakova, 6, St Petersburg, Russia", 
#    "geometry"=>{
#                  "location"=>{"lat"=>60.02780439999999, "lng"=>30.2989359}, 
#                  "location_type"=>"ROOFTOP", 
#                  "viewport"=>{"northeast"=>{"lat"=>60.0291533802915, "lng"=>30.3002848802915}, "southwest"=>{"lat"=>60.02645541970848, "lng"=>30.2975869197085}}
#                }, 
#    "partial_match"=>true, 
#    "types"=>["street_address"]
#  }
#]



