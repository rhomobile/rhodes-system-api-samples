require 'rho/rhocontroller'
require 'rho/rhoevent.rb'
require 'time'

class CalendarController < Rho::RhoController

  @layout = 'Calendar/layout'

  def fetch_events
    start = Time.utc(2007, 'jan', 1, 0, 0, 0)
    finish = Time.utc(2030, 'dec', 31, 23, 59, 59)
    events = Rho::RhoEvent.find(:all, :start_date => start, :end_date => finish)

    @events = []
    events.each do |k, e|
      class << e
        def pretty_print(io)
          io.puts "Id: #{e[Rho::RhoEvent::ID]}"
          io.puts "Title: #{e[Rho::RhoEvent::TITLE]}"
          io.puts "Start Date: #{e[Rho::RhoEvent::START_DATE].to_s}"
          io.puts "End Date: #{e[Rho::RhoEvent::END_DATE].to_s}"
        end
      end
      @events << e
    end

    @events = @events.sort do |x,y|
      res = 1 if x[1]['start_date'].nil?
      res = -1 if y[1]['start_date'].nil?
      res = x[1]['start_date'] <=> y[1]['start_date'] unless res
      res
    end

    @event = nil
  end
  private :fetch_events

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
    if event[Rho::RhoEvent::ID].nil?
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
    id = @params[Rho::RhoEvent::ID]
    id = $1 if id =~ /^{(.*)}$/
    puts "id: #{id}"
    @event = Rho::RhoEvent.find(id)
    render :action => :edit
  end

  def delete
    id = @params[Rho::RhoEvent::ID]
    id = $1 if id =~ /^{(.*)}$/
    Rho::RhoEvent.destroy(id)

    fetch_events
    redirect :action => :index
  end
 
end
