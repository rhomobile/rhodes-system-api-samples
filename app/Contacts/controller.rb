require 'rho/rhocontroller'
require 'rho/rhocontact'
 
class ContactsController < Rho::RhoController
 
  # GET /Contacts
  def index
    @count = Rho::RhoContact.find(:count)
    if @params['offset']
        @offset = @params['offset'].to_i
    else
        @offset = 0;
    end
    @contacts = Rho::RhoContact.find({:max_results => 10, :offset => @offset})
    @contacts = {} unless @contacts
#    @contacts = @contacts.sort do |x,y| 
#      res = 1 if x[1]['first_name'].nil? 
#      res = -1 if y[1]['first_name'].nil?
#      res = x[1]['first_name'] <=> y[1]['first_name'] unless res
#      res
#    end
    render :back => '/app'
  end
 
  # GET /Contacts/1
  def show
    @contact = Rho::RhoContact.find(@params['id'])
    render :action => :show
  end
 
  # GET /Contacts/new
  def new
    render :action => :new
  end
 
  # GET /Contacts/1/edit
  def edit
    @contact = Rho::RhoContact.find(@params['id'])
    render :action => :edit
  end
 
  # POST /Contacts
  def create
    @contact = Rho::RhoContact.create!(@params['contact'])
    redirect :action => :index
  end
 
  # POST /Contacts/1
  def update
    Rho::RhoContact.update_attributes(@params['contact'])
    redirect :action => :index
  end
 
  # POST /Contacts/1/delete
  def delete
    Rho::RhoContact.destroy(@params['id'])
    redirect :action => :index
  end

  def test_create
    contacts = []
    contacts << {"first_name" => "A.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "B.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "C.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "D.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "E.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "F.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "G.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "H.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "I.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "J.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "K.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "L.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "M.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "N.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "O.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "P.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "Q.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "R.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "S.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}
    contacts << {"first_name" => "T.", "last_name" => "RhoTest", "mobile_number" => "+12345678090"}

    contacts.each do |contact|
      Rho::RhoContact.create! contact
    end

    redirect :action => :index
  end
 
  def test_remove
    contacts = Rho::RhoContact.find :all

    contacts.each do |contact|
      if contact[1]["last_name"] == "RhoTest"
        Rho::RhoContact.destroy(contact[1]['id'])
      end
    end

    redirect :action => :index
  end
 
end
