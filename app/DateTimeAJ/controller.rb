require 'rho/rhocontroller'
require 'time'
require 'dateME'
 
class DateTimeAJController < Rho::RhoController
  $saved = nil
  $choosed = {}
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
 
  def callback
    if @params['status'] == 'ok'
     $saved = nil
     datetime_vars = Marshal.load(@params['opaque'])
      format = case datetime_vars[:flag]
        when "0" then '%F %T'
        when "1" then '%F'
        when "2" then '%T'
        else '%F %T'
      end
      formatted_result = Time.at(@params['result'].to_i).strftime(format)
      $choosed[datetime_vars[:flag]] = formatted_result
      WebView.execute_js('setFieldValue("'+datetime_vars[:field_key]+'","'+formatted_result+'");')
    end
  end

end
