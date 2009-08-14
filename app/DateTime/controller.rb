require 'rho/rhocontroller'
require 'dateME'

class DateTimeController < Rho::RhoController
  @layout = :simplelayout
  $saved = nil
  $choosed = {}
  
  def index
    render
  end

  def choose
    puts "Choose date/time"

    flag = @params['flag']
    if flag == '0' or flag == '1' or flag == '2'
      $saved = nil
      DateTimePicker.choose( url_for( :action => :datetime_callback ), "Choose date/time", Time.new, flag.to_i, Marshal.dump(flag) )
    end
    redirect :action => :index
  end

  def save
    $saved = 1
    redirect :action => :index
  end

  def datetime_callback
    puts "datetime_callback"

    $status = @params['status']
    if $status == 'ok'
      $dt = Time.at( @params['result'].to_i )
      flag = Marshal.load(@params['opaque'])
      $choosed[flag] = $dt.strftime( '%F %T' )
      WebView::refresh
    end
    #reply on the callback
    render :action => :index
  end

end
