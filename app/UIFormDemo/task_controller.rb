require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TaskController < Rho::RhoController
  include BrowserHelper

  #GET /Task
  def index
    @tasks = Task.find(:all)
    render
  end

  # GET /Task/{1}
  def show
    @task = Task.find(@params['id'])
    if @task
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /Task/new
  def new
    @task = Task.new
    render :action => :new
  end

  # GET /Task/{1}/edit
  def edit
    @task = Task.find(@params['id'])
    if @task
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /Task/create
  def create
    @task = Task.new(@params['task'])
    @task.save
    redirect :action => :index
  end

  # POST /Task/{1}/update
  def update
    @task = Task.find(@params['id'])
    @task.update_attributes(@params['task']) if @task
    redirect :action => :index
  end

  # POST /Task/{1}/delete
  def delete
    @task = Task.find(@params['id'])
    @task.destroy if @task
    redirect :action => :index
  end
end
