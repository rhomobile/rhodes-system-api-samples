require 'rho/rhocontroller'
require 'rexml/document'

class RexmlTestController < Rho::RhoController

  #GET /RexmlTest
  def index

    file_name = File.join(Rho::RhoApplication::get_model_path('app','RexmlTest'), 'test.xml')
    puts "file_name : #{file_name}"
    
    file = File.new(file_name)
    begin
        doc = REXML::Document.new(file)
        puts doc
        
        @res = "Success"
    rescue Exception => e
        puts "Error: #{e}"
        @res = "Error: #{e}"
    end
    
  end
  
end
