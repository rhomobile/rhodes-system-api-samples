require 'rho/rhocontroller'
require 'json'

class JsonTestController < Rho::RhoController

  #GET /JsonTest
  def index
    
    #begin
        file_name = File.join(Rho::RhoApplication::get_model_path('app','JsonTest'), 'test.json')
        puts "file_name : #{file_name}"

        content = File.read(file_name)
        puts "content : #{content}"
      
        parsed = Rho::JSON.parse(content)
        puts "parsed : #{parsed}"

        gen = ::JSON.generate(parsed)
        puts "gen : #{gen}"
        
        @@get_result = "Success!"
    #rescue Exception => e
    #    puts "Error: #{e}"
    #    @@get_result = "Uncomment in build.yml:<br/> extensions: [\"json\"]<br/>"
    #    @@get_result += "Error: #{e}"
    #end
        
  end

  def get_res
    @@get_result    
  end

end
