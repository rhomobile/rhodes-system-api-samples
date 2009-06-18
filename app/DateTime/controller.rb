require 'rho/rhocontroller'
require 'dateME'

class DateTimeController < Rho::RhoController
  @layout = :simplelayout
  $choosed = 'none'
  
  def index
    render
  end

  def new
    puts "Choose date/time"
    DateTimePicker::choose( url_for( :action => :datetime_callback ), "Choose date/time", Time.new )
    render
  end

  def datetime_callback
    print "datetime_callback: received params:"
    p @params
    #@params.each { |k,v| puts "#{k} => #{v}" }

    $status = @params['status']
    if $status == 'ok'
      $dt = Time.at( @params['result'].to_i )
      $choosed = $dt.strftime( '%FT%T' )
    end
    #reply on the callback
    render :action => :index
  end

end
