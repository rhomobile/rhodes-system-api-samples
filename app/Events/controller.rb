require 'rho/rhocontroller'
require 'rho/rhoevent'
 
class EventsController < Rho::RhoController
 
  # GET /Events
  def index
    @events = Rho::RhoEvent.find(:all)
    @events = @events.sort do |x,y| 
      res = 1 if x[1]['start_date'].nil? 
      res = -1 if y[1]['start_date'].nil?
      res = x[1]['start_date'] <=> y[1]['start_date'] unless res
      res
    end
    render
  end
 
  # GET /Events/1
  def show
    @event = Rho::RhoEvent.find(@params['id'])
    render :action => :show
  end
 
  # GET /Events/new
  def new
    render :action => :new
  end
 
  # GET /Events/1/edit
  def edit
    @event = Rho::RhoEvent.find(@params['id'])
    render :action => :edit
  end
 
  # POST /Events
  def create
    @event = Rho::RhoEvent.create!(@params['event'])
    redirect :action => :index
  end
 
  # POST /Events/1
  def update
    Rho::RhoEvent.update_attributes(@params['event'])
    redirect :action => :index
  end
 
  # POST /Events/1/delete
  def delete
    Rho::RhoEvent.destroy(@params['id'])
    redirect :action => :index
  end
 
end