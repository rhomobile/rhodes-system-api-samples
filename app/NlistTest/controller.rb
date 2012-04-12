require 'rho/rhocontroller'

class NlistTestController < Rho::RhoController
#  @layout = 'NlistTest/layout'
  
  def index
    render :back => '/app'
  end

  def run_test
    base_url = WebView.current_location() + '/render_item'
    data_url = WebView.current_location() + '/render_data'
    #base_url = url_for(:action => :render_item)
    list_params = { :items_count => 10000, :item_height => 64, :item_request_url => base_url, :data_request_url => data_url, :item_data_cache_size => 300, :item_data_portion_size => 50}
    NList.open_list(list_params, url_for(:action => :nlist_callback))
    render :index
  end

  def render_item
       @item = @params['item'].to_i	       
  end

  def get_data_for_index(index)
       return '[ '+index.to_s+' ]'
  end

  def render_data
       start_index = @params['start_item'].to_i
       count = @params['items_count'].to_i

       data = '<?xml version="1.1" encoding="US-ASCII"?><items>'	
       
       for index in start_index..(start_index+count-1)     
             data = data + '<item index="'+index.to_s+'">'+get_data_for_index(index)+'</item>'
       end
	
       data = data + '</items>'
       render :string => data
  end 
  
  def nlist_callback
      index = @params['selected_item'].to_i	
      NList.close_list
      $selected_item = index
      puts '$$$$$$$$$$$$$$$$$ selected_item = '+$selected_item.to_s
      WebView.navigate( url_for :action => :selected )
  end
  
  def selected
       render
  end

end
