require 'rexml/document'

file_name = 'test.xml'

file = File.new(file_name)
begin

    doc = REXML::Document.new(file)
    puts doc

    REXML::XPath.each( doc, "//AssignedServiceOrder/") do|so|
        puts "ServiceOrderId : #{ REXML::XPath.first(so, '//ServiceOrderId/text()') }"
    end
    
rescue Exception => e
    puts "error : #{e}"
end
