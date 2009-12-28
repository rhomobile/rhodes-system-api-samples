require 'rho/rhocontroller'
require 'net/http'
#require 'json'

class HttpTestController < Rho::RhoController

  #GET /HttpTest
  def index

    #res = JSON.parse("[{\"count\":10}]")
    #puts 'JSON.parse():' + res.inspect

    #res = JSON.parse("[{\"count\":10},{\"version\":1},{\"total_count\": 5425},{\"token\": 123},{\"s\":\"RhoDeleteSource\",\"ol\":[{\"o\":\"rho_del_obj\",\"av\":[{\"i\":55550425},{\"i\":75665819},{\"i\":338165272},{\"i\":402396629},{\"i\":521753981},{\"i\":664143530},{\"i\":678116186},{\"i\":831092394},{\"i\":956041217},{\"i\":970452458}]}]}]")
    #puts 'JSON.parse():' + res.inspect
    
    @get_result = Net::HTTP.get 'www.apache.org', '/licenses/LICENSE-2.0'
  
    render
  end
end
