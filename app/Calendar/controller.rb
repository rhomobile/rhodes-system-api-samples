require 'rho/rhocontroller'
require 'rho/rhoevent.rb'
require 'time'

class CalendarController < Rho::RhoController

  @layout = 'Calendar/layout'

  def fetch_events
    #start = Time.utc(Rho::RhoEvent::MIN_TIME.to_i)
    #finish = Time.utc(2030, 'dec', 31, 23, 59, 59)
    @authorization_status = Rho::RhoEvent.get_authorization_status

    @@events = Rho::RhoEvent.find(:all,
        :start_date => (Rho::RhoEvent::MIN_TIME + 1), :end_date => (Rho::RhoEvent::MAX_TIME - 1),
        :find_type => 'starting', :include_repeating => false)
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
    render :back => '/app'
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
    event[Rho::RhoEvent::END_DATE] = nil if event[Rho::RhoEvent::END_DATE] == ''
    recurrence = !@params['recurrence'].nil?
    frequency = @params['frequency']
    interval = @params['interval']
    recurrence_end = @params['recurrence_end']
    recurrence_times = @params['recurrence_times']
    
    if recurrence
      event[Rho::RhoEvent::RECURRENCE] = {
        Rho::RhoEvent::RECURRENCE_FREQUENCY => frequency,
        Rho::RhoEvent::RECURRENCE_INTERVAL => interval,
        Rho::RhoEvent::RECURRENCE_END => recurrence_end, 
        Rho::RhoEvent::RECURRENCE_COUNT => recurrence_times }
    end
    puts "event: #{event.inspect}"
    id = event[Rho::RhoEvent::ID]
    if id.nil? or id.empty?
      new_event = Rho::RhoEvent.create!(event)
      if new_event != nil
          new_id = new_event['id']
          puts 'created new event with id = ' + new_id
      end
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
