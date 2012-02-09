class NetworksController < ApplicationController
 before_filter :find_network, :except => [ :index, :new, :create ]
  def index
    @networks = Network.all

    respond_to do |format|
      format.html
    end
  end

   def new
    @network = Network.new

    respond_to do |format|
      format.html
    end
  end

   def create
    @network = Network.new(params[:network])

    respond_to do |format|
      if @network.save
        flash[:notice] = "Successfully created your network!"
        format.html { redirect_to networks_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

   def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @network.update_attributes(params[:network])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_network_path(@network) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @network.destroy

    respond_to do |format|
      format.html { redirect_to networks_path }
    end
  end

  protected

  def find_network
    @network = Network.find(params[:id])
  end


end
