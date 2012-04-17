require 'rho/rhocontroller'

class NlistTestController < Rho::RhoController
  
  def index
    render :back => '/app'
  end

  def run_test
    base_url = WebView.current_location() + '/render_item'
    data_url = WebView.current_location() + '/render_data'
    #base_url = url_for(:action => :render_item)
    # use WebView inside each list Item
    #list_params = { :items_count => 10000, :item_height => 64, :item_request_url => base_url, :data_request_url => data_url, :item_data_cache_size => 300, :item_data_portion_size => 50}
    # use Native view at Item
    list_params = { :items_count => 10000, :item_height => 64, :data_request_url => data_url, :item_data_cache_size => 300, :item_data_portion_size => 50}
    NList.open_list(list_params, url_for(:action => :nlist_callback))
    render :action => :selected, :back => 'callback:'+url_for(:action => :process_back) 
  end

  def process_back
     NList.close_list
     #render :index
     WebView.navigate(url_for :action => :index) 
  end

  def render_item
       @item = @params['item'].to_i	       
  end

  def get_data_for_index(index)
       # return JSON data
       image_path = File.join(Rho::RhoApplication::get_base_app_path(), '/public/images/custom/Car-3'+(index%10).to_s+'.png')
       return '{"title":"Title ( '+index.to_s+' )","subtitle":"Subtitle ( '+index.to_s+' )","number":"[ '+index.to_s+' ]","image":"'+image_path+'"}'
  end

  def render_data
       #return portion of JSON datas packed to XML
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
      puts '$$$$$$$$$$$$$$$$$$$$$   JS = '+ "nlist_set_selected('"+index.to_s+"');"
      WebView.execute_js('document.getElementById("selected_item").innerHTML = "'+index.to_s+'";')
  end
  
end
