class LocationsController < ApplicationController

  layout false

  def index
    if params[:q]
      @locations = Location.all_names(:conditions => ["name LIKE ?", "#{params[:q]}%"])
    else
      @locations = Location.all_names
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

end