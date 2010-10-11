require 'rho/rhocontroller'
require 'rho/rhoevent.rb'
require 'time'

class CalendarController < Rho::RhoController

  @layout = 'Calendar/layout'

  def fetch_events
    start = Time.utc(2007, 'jan', 1, 0, 0, 0)
    finish = Time.utc(2010, 'dec', 31, 23, 59, 59)
    @@events = Rho::RhoEvent.find(:all, :start_date => start, :end_date => finish, :find_type => 'starting', 
        :include_repeating => true)
    puts "events : #{@@events}"
    
    @@events = @@events.sort do |x,y|
      res = 1 if x['start_date'].nil?
      res = -1 if y['start_date'].nil?
      res = x['start_date'] <=> y['start_date'] unless res
      res
    end

    @event = nil
  end
  private :fetch_events

  def get_events
    @@events    
  end
  
  def index
    fetch_events
    render :action => :index
  end

  def date_popup
    DateTimePicker.choose url_for(:action => :date_callback), @params['title'], Time.new, 0, Marshal.dump(@params['field_key'])
  end

  def date_callback
    if @params['status'] == 'ok'
      key = Marshal.load(@params['opaque'])
      result = Time.at(@params['result'].to_i).strftime('%F %T')
      WebView.execute_js('setFieldValue("'+key+'","'+result+'");')
    end
  end

  def save
    event = @params['event']
    recurrence = @params['recurrence'] == 'true'
    frequency = @params['frequency']
    interval = @params['interval']
    if recurrence
      event['recurrence'] = { 'frequency' => frequency, 'interval' => interval }
    end
    puts "event: #{event.inspect}"
    id = event[Rho::RhoEvent::ID]
    if id.nil? or id.empty?
      Rho::RhoEvent.create! event
    else
      Rho::RhoEvent.update_attributes event
    end

    fetch_events
    redirect :action => :index
  end

  def new
    puts "create event"
    @event = nil
    render :action => :edit
  end

  def edit
    #id = @params[Rho::RhoEvent::ID]
    #puts "id: #{id}"
    #@event = Rho::RhoEvent.find(id)
    
    @event = @@events[strip_braces(@params['id']).to_i ]
    render :action => :edit
  end

  def delete
    id = @params[Rho::RhoEvent::ID]
    Rho::RhoEvent.destroy(id)

    fetch_events
    redirect :action => :index
  end
 
end
