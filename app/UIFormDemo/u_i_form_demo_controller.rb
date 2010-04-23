require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UIFormDemoController < Rho::RhoController
  include BrowserHelper

  #GET /UIFormDemo
  def index
    @uiformdemos = UIFormDemo.find(:all)
    render
  end

  # GET /UIFormDemo/{1}
  def show
    @uiformdemo = UIFormDemo.find(@params['id'])
    if @uiformdemo
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /UIFormDemo/new
  def new
    @uiformdemo = UIFormDemo.new
    render :action => :new
  end

  # GET /UIFormDemo/{1}/edit
  def edit
    @uiformdemo = UIFormDemo.find(@params['id'])
    if @uiformdemo
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /UIFormDemo/create
  def create
    @uiformdemo = UIFormDemo.new(@params['uiformdemo'])
    @uiformdemo.save
    redirect :action => :index
  end

  # POST /UIFormDemo/{1}/update
  def update
    @uiformdemo = UIFormDemo.find(@params['id'])
    @uiformdemo.update_attributes(@params['uiformdemo']) if @uiformdemo
    redirect :action => :index
  end

  # POST /UIFormDemo/{1}/delete
  def delete
    @uiformdemo = UIFormDemo.find(@params['id'])
    @uiformdemo.destroy if @uiformdemo
    redirect :action => :index
  end
end
