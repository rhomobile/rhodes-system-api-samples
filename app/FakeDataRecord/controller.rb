require 'rho/rhocontroller'
require 'helpers/application_helper'

class FakeDataRecordController < Rho::RhoController
  
  include ApplicationHelper

  #GET /FakeDataRecord
  def index
    render
  end

  #GET /FakeDataRecord
  def show
    @FakeDataRecords = FakeDataRecord.find(:all, :order => 'attr0')
    render :action => :show
  end

  #GET /FakeDataRecord
  def generate
    render :action => :generate
  end

  # POST /FakeDataRecord/create
  def create

    numRecords = @params['numRecords'].to_i
    puts 'Create ' + numRecords.to_s + ' FakeData records'

    @FakeDataRecord = FakeDataRecord.new()

    0.upto(numRecords) do |i|

	0.upto(10) do |j|      
          attrib = "attr" + j.to_s
          @FakeDataRecord.send("#{attrib}=".to_sym(), rand_str(10 + rand(30)) )
	end
	attrib = "object"
	@FakeDataRecord.send("#{attrib}=".to_sym(), rand_str(36) )

      attrib = "update_type"
	@FakeDataRecord.send("#{attrib}=".to_sym(), "query" )

      @FakeDataRecord.save
    end
  end

  def rand_str(len)
     Array.new(len/2) { rand(256) }.pack('C*').unpack('H*').first
  end

end
