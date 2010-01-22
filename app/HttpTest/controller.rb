require 'rho/rhocontroller'
require 'net/http'
require 'net/https'
require 'uri'
#require 'json'

class HttpTestController < Rho::RhoController

  #GET /HttpTest
  def index

    #clnt.set_auth(domain, user, password)
    #
    #query = {
    #  'auth_type'=>'basic',
    #  'fields'=> 'id acd_number claim_number status adjuster_fullname date_time_created',
    #  'limit'=>'25'
    #}
    #res = clnt.get('http://api.acd.local.cj.nu/v1/propertylink/claim/format/json?auth_type=basic',query)

    #user = "superuser"
    #password = "1a1dc91c907325c69271ddf0c944bc72" #Digest::MD5.hexdigest("pass")
    
    #url = URI.parse('http://api.acd.local.cj.nu/v1/propertylink/claim/format/json?auth_type=basic')
    
    #Net::HTTP.start(url.host, url.port) {|http|
    #      req = Net::HTTP::Get.new(url.path)
    #      req.basic_auth user, password
    #      response = http.request(req)
    #      
    #      puts "JSON: #{response.body}"
    #      parsed = JSON.parse(response.body)
    #      puts "JSON parsed: #{parsed}"
    #}

    #res = JSON.parse("[{\"count\":10}]")
    #puts 'JSON.parse():' + res.inspect

    #res = JSON.parse("[{\"count\":10},{\"version\":1},{\"total_count\": 5425},{\"token\": 123},{\"s\":\"RhoDeleteSource\",\"ol\":[{\"o\":\"rho_del_obj\",\"av\":[{\"i\":55550425},{\"i\":75665819},{\"i\":338165272},{\"i\":402396629},{\"i\":521753981},{\"i\":664143530},{\"i\":678116186},{\"i\":831092394},{\"i\":956041217},{\"i\":970452458}]}]}]")
    #puts 'JSON.parse():' + res.inspect

    #uri = URI::HTTP.build({:host => 'www.example.com', :path => '/search.cgi'})

    #@get_result = Net::HTTP.post_form(URI.parse('http://www.example.com/search.cgi'), {'q' => 'ruby', 'max' => '50'})
    
    #@get_result = Net::HTTP.get 'www.apache.org', '/licenses/LICENSE-2.0'

    strurl = 'https://gmail.google.com/mail/'
  	uri = URI.parse(strurl)
	  http = Net::HTTP.new(uri.host, uri.port)
  	http.use_ssl = true if uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
	  http.start {
		  http.request_get(uri.path) { |res| 
			  @get_result = res.body
		  }
	  }
  
    render
  end
end
