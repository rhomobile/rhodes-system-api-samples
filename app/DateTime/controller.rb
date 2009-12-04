require 'rho/rhocontroller'
require 'date'

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
      # preset_time = Time.parse("2009-10-20 14:30:00")
      # puts "Parsed Time Object: #{preset_time.inspect.to_s}"
      # DateTimePicker.choose( url_for( :action => :datetime_callback ), title, preset_time, flag.to_i, Marshal.dump(flag) )
      DateTimePicker.choose( url_for( :action => :datetime_callback ), title, Time.new, flag.to_i, Marshal.dump(flag) )
    end
    #redirect :action => :index
    ""
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
      #WebView::refresh
      WebView.navigate( url_for :action => :index )
    end
    #reply on the callback
    #render :action => :index
    ""
  end

end
