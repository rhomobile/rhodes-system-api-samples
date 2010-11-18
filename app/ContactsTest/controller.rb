require 'rho/rhocontroller'
require 'rho/rhocontact'
 
class ContactsTestController < Rho::RhoController
 
  # GET /Contacts
  def index
    puts 'Contacts::index START'
    @contacts = Rho::RhoContact.find(:all)
    puts 'Contacts::index contacts received'
    @contacts = @contacts.sort do |x,y| 
      res = 1 if x[1]['first_name'].nil? 
      res = -1 if y[1]['first_name'].nil?
      res = x[1]['first_name'] <=> y[1]['first_name'] unless res
      res
    end
    puts 'Contacts::index contacts sorted'
    render
    #puts 'Contacts::index FINISH rendered'
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
 
  def delete_all_contacts
    @contacts = Rho::RhoContact.find(:all)
    @contacts.each do |x|
        Rho::RhoContact.destroy(x[1]['id'])
        puts 'contact '+x[1]['id']+' deleted'
    end
    redirect :action => :index
  end

  def make_200_contacts
     200.times do |j|
          i = j
          hash = {}
          hash['first_name'] = 'John' + i.to_s 
          hash['last_name'] = 'Smith' + i.to_s 
          hash['mobile_number'] = '555' + i.to_s
          hash['email_address'] = 'john' + i.to_s + '@mail.com' 
          hash['company_name'] = 'John Smith Co LTD' 
          contact = Rho::RhoContact.create!(hash)
          puts 'contact '+i.to_s+' created'
     end
    redirect :action => :index
  end

end