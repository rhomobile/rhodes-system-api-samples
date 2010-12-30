require 'rho/rhocontroller'
require 'rho/rhocontact'
 
class ContactsController < Rho::RhoController
 
  # GET /Contacts
  def index
    @contacts = Rho::RhoContact.find(:all)
    @contacts = {} unless @contacts
    @contacts = @contacts.sort do |x,y| 
      res = 1 if x[1]['first_name'].nil? 
      res = -1 if y[1]['first_name'].nil?
      res = x[1]['first_name'] <=> y[1]['first_name'] unless res
      res
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
    Rho::RhoContact.update_attributes(@params['contact'])
    redirect :action => :index
  end
 
  # POST /Contacts/1/delete
  def delete
    Rho::RhoContact.destroy(@params['id'])
    redirect :action => :index
  end
 
end