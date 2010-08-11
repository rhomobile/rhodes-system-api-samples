require 'rho/rhocontroller'
require 'time'
require 'dateME'
 
class DateTimeAJController < Rho::RhoController
  $saved = nil
  $choosed = {}
  $date_time = {}
  @layout = 'DateTimeAJ/layout'
  
  def index
    render
  end

  def save
    $saved = 1
    redirect :action => :index
  end
 
  def popup
    flag = @params['flag']
    if ['0', '1', '2'].include?(flag)
      DateTimePicker.choose url_for(:action => :callback), @params['title'], Time.new, flag.to_i, Marshal.dump({:flag => flag, :field_key => @params['field_key']})
    end
  end
 
  def selection
    @datetime = $date_time[@params['field_key']] ? $date_time[@params['field_key']] : ''
    render :action => :selection, :layout => false, :use_layout_on_ajax => false
  end

  def callback
    if @params['status'] == 'ok'
      $dt = Time.at( @params['result'].to_i )
     datetime_vars = Marshal.load(@params['opaque'])
      format = case datetime_vars[:flag]
        when "0" then '%F %T'
        when "1" then '%F'
        when "2" then '%T'
        else '%F %T'
      end
      $date_time[datetime_vars[:field_key]] = Time.at(@params['result'].to_i).strftime(format)
      $choosed[datetime_vars[:flag]] = $dt.strftime( format )
    end
  end

end
