require 'rho/rhocontroller'
require 'rho/rhocontact'
 
class ContactsController < Rho::RhoController
 
  # GET /Contacts
  def index
    if System::get_property('platform') == "ANDROID"
        @count = Rho::RhoContact.find(:count)
        if @params['offset']
            @offset = @params['offset'].to_i
        else
            @offset = 0;
        end

        @contacts = Rho::RhoContact.find(:all, :per_page => 10, :offset => @offset, :select => ["id", "display_name", "first_name", "last_name", "mobile_number"])
        @contacts = {} unless @contacts
        @contacts = @contacts.sort do |x,y| 
          res = 1 if x[1]['display_name'].nil? 
          res = -1 if y[1]['display_name'].nil?
          res = x[1]['display_name'] <=> y[1]['display_name'] unless res
          res
        end
    else
        @contacts = Rho::RhoContact.find(:all)
        @contacts = {} unless @contacts
        @contacts = @contacts.sort do |x,y| 
          res = 1 if x[1]['first_name'].nil? 
          res = -1 if y[1]['first_name'].nil?
          res = x[1]['first_name'] <=> y[1]['first_name'] unless res
          res
        end
    end
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
    puts @params['contact'].inspect
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
    contacts << {"first_name" => "A.", "last_name" => "RhoTest", "mobile_number" => "+12345678091"}
    contacts << {"first_name" => "B.", "last_name" => "RhoTest", "mobile_number" => "+12345678092"}
    contacts << {"first_name" => "C.", "last_name" => "RhoTest", "mobile_number" => "+12345678093"}
    contacts << {"first_name" => "D.", "last_name" => "RhoTest", "mobile_number" => "+12345678094"}
    contacts << {"first_name" => "E.", "last_name" => "RhoTest", "mobile_number" => "+12345678095"}
    contacts << {"first_name" => "F.", "last_name" => "RhoTest", "mobile_number" => "+12345678096"}
    contacts << {"first_name" => "G.", "last_name" => "RhoTest", "mobile_number" => "+12345678097"}
    contacts << {"first_name" => "H.", "last_name" => "RhoTest", "mobile_number" => "+12345678098"}
    contacts << {"first_name" => "I.", "last_name" => "RhoTest", "mobile_number" => "+12345678099"}
    contacts << {"first_name" => "J.", "last_name" => "RhoTest", "mobile_number" => "+12345678100"}
    contacts << {"first_name" => "K.", "last_name" => "RhoTest", "mobile_number" => "+12345678101"}
    contacts << {"first_name" => "L.", "last_name" => "RhoTest", "mobile_number" => "+12345678102"}
    contacts << {"first_name" => "M.", "last_name" => "RhoTest", "mobile_number" => "+12345678103"}
    contacts << {"first_name" => "N.", "last_name" => "RhoTest", "mobile_number" => "+12345678104"}
    contacts << {"first_name" => "O.", "last_name" => "RhoTest", "mobile_number" => "+12345678105"}
    contacts << {"first_name" => "P.", "last_name" => "RhoTest", "mobile_number" => "+12345678106"}
    contacts << {"first_name" => "Q.", "last_name" => "RhoTest", "mobile_number" => "+12345678107"}
    contacts << {"first_name" => "R.", "last_name" => "RhoTest", "mobile_number" => "+12345678108"}
    contacts << {"first_name" => "S.", "last_name" => "RhoTest", "mobile_number" => "+12345678109"}
    contacts << {"first_name" => "T.", "last_name" => "RhoTest", "mobile_number" => "+12345678110"}

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
