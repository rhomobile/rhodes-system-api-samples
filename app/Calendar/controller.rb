require 'rho/rhocontroller'
require 'time'

class CalendarController < Rho::RhoController

  @layout = 'Calendar/layout'

  def fetch_events
    start = Time.utc(2010, 'jan', 1, 0, 0, 0)
    finish = Time.utc(2010, 'dec', 31, 23, 59, 59)
    events = Event.fetch(start, finish)

    @events = []
    events.each do |e|
      class << e
        def pretty_print(io)
          io.puts "Id: #{e[Event::ID]}"
          io.puts "Title: #{e[Event::TITLE]}"
          io.puts "Canceled: #{e[Event::CANCELED]}"
          io.puts "Organizer: #{e[Event::ORGANIZER]}"
          io.puts "Start Date: #{e[Event::START_DATE].to_s}"
          io.puts "End Date: #{e[Event::END_DATE].to_s}"
        end
      end
      @events << e
    end
  end
  private :fetch_events

  def index
    fetch_events
    render
  end

  def new
    render :action => :new
  end

  def date_popup
    DateTimePicker.choose url_for(:action => :date_callback), @params['title'], Time.new, 1, Marshal.dump(@params['field_key'])
  end

  def date_callback
    if @params['status'] == 'ok'
      key = Marshal.load(@params['opaque'])
      result = Time.at(@params['result'].to_i).strftime('%F')
      WebView.execute_js('setFieldValue("'+key+'","'+result+'");')
    end
  end

  def create
    event = @params['event']
    puts "event: #{event.inspect}"
    event[Event::START_DATE] = Time.parse(event[Event::START_DATE]) unless event[Event::START_DATE].nil?
    event[Event::END_DATE] = Time.parse(event[Event::END_DATE]) unless event[Event::END_DATE].nil?
    Event.save(event)

    fetch_events
    render :action => :index
  end

  def edit
    id = @params[Event::ID]
    id = $1 if id =~ /^{(.*)}$/
    puts "id: #{id}"
    @event = Event.fetch(id)
    render
  end
 
end
