require 'rho/rhocontroller'

class BlobController < Rho::RhoController

  #GET /Blob
  def index
    @blobs = Blob.find(:all)
    render
  end

  # GET /Blob/1
  def show
    @blob = Blob.find(@params['id'])
    render :action => :show
  end

  # GET /Blob/new
  def new
    @blob = Blob.new
    render :action => :new
  end

  # GET /Blob/1/edit
  def edit
    @blob = Blob.find(@params['id'])
    render :action => :edit
  end
  
  def take_picture
	  Camera::choose_picture('/app/Blob/create')
    redirect :action => :index
  end

  # POST /Blob/create
  def create
    if @params['status'] == 'ok'
      #create image record in the DB
      @blob = Blob.new({'image_uri'=>@params['image_uri']})
      @blob.save
      WebView::refresh
    end  
    #reply on the callback
    render :action => :create
  end

  # POST /Blob/1/update
  def update
    @blob = Blob.find(@params['id'])
    @blob.update_attributes(@params['blob'])
    redirect :action => :index
  end

  # POST /Blob/1/delete
  def delete
    @blob = Blob.find(@params['id'])
    @blob.destroy
    redirect :action => :index
  end
end
