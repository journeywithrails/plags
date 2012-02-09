class BrandNamesController < ApplicationController
    layout false


  def index
    if params[:q]
      @brands = Brand.find(:all,:conditions => ["name LIKE ?", "#{params[:q]}%"])
    else
      @brands = Brand.find(:all)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end
