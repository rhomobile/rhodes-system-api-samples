require 'rho/rhocontroller'
require 'rho/rhoevent'
require 'time'
 
class EventsController < Rho::RhoController
 
  # GET /Events
  def index
    #start = Time.now
    #end_time = start + 3600
    #@events = Rho::RhoEvent.find(:all, :start_date => start, :end_date => end_time, :find_type => 'starting', 
    #    :include_repeating => true )
    @events = Rho::RhoEvent.find(:all)
    @events = @events.sort do |x,y| 
      res = 1 if x[1]['start_date'].nil? 
      res = -1 if y[1]['start_date'].nil?
      res = x[1]['start_date'] <=> y[1]['start_date'] unless res
      res
    end
    render
  end
 
  # GET /Events/1
  def show
    @event = Rho::RhoEvent.find(@params['id'])
    puts "@event : #{@event}"
    render :action => :show
  end
 
  # GET /Events/new
  def new
    render :action => :new
  end
 
  # GET /Events/1/edit
  def edit
    @event = Rho::RhoEvent.find(@params['id'])
    
    $choosed_start_date = @event['start_date']
    $choosed_end_date = @event['end_date']
        
    render :action => :edit
  end

  def edit2
    @event = Rho::RhoEvent.find(@params['id'])
    
    render :action => :edit
  end

  def edit_date 
    puts "edit_date: #{@params}"

    type = @params['type']
    title = @params['title']
    $saved = nil
    
    DateTimePicker.choose( url_for( :action => :datetime_callback ), title, 
      type == 'start_date' ? $choosed_start_date : $choosed_end_date, 0, Marshal.dump({'type'=>type, 'id'=>@params['id']}) )
    ""
  end

  def datetime_callback
    puts "datetime_callback : #{@params}"

    $status = @params['status']
    if $status == 'ok'
      dt = Time.at( @params['result'].to_i )
      params = Marshal.load(@params['opaque'])
      if params['type'] == 'start_date'
        $choosed_start_date = dt
      else
        $choosed_end_date = dt
      end  
    end
    
    WebView.navigate( url_for :action => :edit2, :query => { :id => params['id'] } )
    
    ""
  end
  
  # POST /Events
  def create
    @event = Rho::RhoEvent.create!(@params['event'])
    redirect :action => :index
  end
 
  # POST /Events/1
  def update
    @params['event']['start_date'] = $choosed_start_date
    @params['event']['end_date'] = $choosed_end_date
    @params['event']['reminder'] = @params['event']['reminder'].to_i
    
    Rho::RhoEvent.update_attributes(@params['event'])
    redirect :action => :index
  end
 
  # POST /Events/1/delete
  def delete
    Rho::RhoEvent.destroy(@params['id'])
    redirect :action => :index
  end
 
end