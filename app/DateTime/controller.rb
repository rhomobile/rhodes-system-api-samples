require 'rho/rhocontroller'
require 'dateME'

class DateTimeController < Rho::RhoController
  @layout = :simplelayout
  $choosed = 'none'
  
  def index
    puts "Choosed date/time: " + $choosed
    render
  end

  def new
    #puts "params: " + @params
    #puts "query: " + @query
    #$fmt = @query['fmt']

    #if $fmt.nil?
      $dt = DateTimePicker::choose("Choose date/time", Time.new)
    #else
    #  puts "fmt received: " + $fmt
    #  $dt = DateTimePicker::choose("Choose date/time", Time.new, $fmt)
    #end
    
    if $dt.nil?
      $choosed = "none"
    else
      $choosed = $dt.strftime('%FT%T')
    end
    redirect :action => :index
  end

end
