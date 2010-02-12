require 'rho/rhocontroller'
require 'net/https'
require 'uri'

class HttpsTestController < Rho::RhoController

  #GET /HttpsTest
  def index

    strurl = 'https://www.paypal.com/'
    puts "strurl: #{strurl}"
  	uri = URI.parse(strurl)
    puts "host: #{uri.host}"
    puts "port: #{uri.port}"
    puts "scheme: #{uri.scheme}"
    puts "path: #{uri.path}"
    puts "query: #{uri.query}"
    puts "request_uri: #{uri.request_uri}" # exact the same as 'uri.path + "?" + uri.query'
    http = Net::HTTP.new(uri.host, uri.port)
  	http.use_ssl = uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl? and System::get_property('platform') != 'Blackberry'
	  http.start {
		  http.request_get(uri.request_uri) { |res| 
			  @get_result = res.body
		  }
	  }
  
    render
  end
end
