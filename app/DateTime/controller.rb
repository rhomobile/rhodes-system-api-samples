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
    title = @params['title']
    if flag == '0' or flag == '1' or flag == '2'
      $saved = nil
      DateTimePicker.choose( url_for( :action => :datetime_callback ), title, Time.new, flag.to_i, Marshal.dump(flag) )
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
      format = case flag
        when "0" then '%F %T'
        when "1" then '%F'
        when "2" then '%T'
        else '%F %T'
      end
      $choosed[flag] = $dt.strftime( format )
      WebView::refresh
    end
    #reply on the callback
    render :action => :index
  end

end
