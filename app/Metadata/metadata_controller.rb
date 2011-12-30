require 'rho/rhocontroller'
require 'helpers/browser_helper'

class MetadataController < Rho::RhoController
  @layout = 'Metadata/layout'
  include BrowserHelper

  def index
    render :back => '/app'
  end

  def address
    @contacts = Metadata.find(:all)
    @account = {
      'name' => 'John Account',
      'phone' => '555-1000',
      'date_created' => '2001-01-01',
      'do_not_contact' => 'false',
      'size' => 'Medium',
      'address1' => '123 fake street',
      'address2' => 'somewheresville, CA',
      'address3' => '94089',
    }
    puts @contacts.inspect
    puts Metadata.metadata.inspect
    render #:layout => false
  end

  def form_index
    @forms = Metadata.find(:all)
    @link1 = link_to 'Click Me', :action => :new_index
    render :template => false
  end

  def validation
    @form = Metadata.new
    @errors = ""
    @errorlabel = ""
    @submiturl = url_for(:controller => :Metadata) + "/create"
    puts "SUBMIT: #{@submiturl}"
  end

  def create
    errors = validate(Metadata.metadata['validation'],@params)
    puts "ERRORS: #{errors.inspect}"
    if errors
      @submiturl = url_for(:controller => :Metadata) + "/create"
      @errorlabel = "Errors:<br/>\n"
      @errors = errors.join("<br/>\n")
      @form = @params
      render :action => :validation
    else
      @form = Metadata.new(:name => @params['name'], :age => @params['age'], :year => @params['year'])
      @form.save
      redirect :action => :index
    end
  end



  def show_map

    map_type = @params['map_type'].nil? ? "hybrid" : @params['map_type']
    lat = @params['lat'].nil? ? "37.349691" : @params['lat']
    long = @params['long'].nil? ? "-121.983261" : @params['long']
    scroll =  @params['scroll'] == "true"
    zoom = @params['zoom'] == "true"
    show_user = @params['show_user'] == "true"
    title_location = @params['title_location'].nil? ? "Current location" : @params['title_location']
    subtitle_location = @params['subtitle_location']
    url_location = @params['url_location']

    api_key = @params['api_key']

    redirect_to = @params['next_uri'].nil? ? "/app" : @params['next_uri']

    annotations = []

    annotations << {
      :latitude => lat,
      :longitude => long,
      :title => title_location,
      :subtitle => subtitle_location,
      :url => url_location

      }

     unless @params['annotations'].nil?
       @params['annotations'].each do |k,v|
         annotations << v.symbolize_keys
       end
     end

     map_params = {
          :settings => {:map_type => map_type,:region => [lat, long, 0.2, 0.2],
                        :zoom_enabled => zoom,:scroll_enabled => scroll,:shows_user_location => show_user,
                        :api_key => api_key},
          :annotations => annotations
     }
     MapView.create map_params

    redirect redirect_to
  end
end
