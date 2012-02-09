class SizesController < ApplicationController
  before_filter :find_size, :except => [ :index, :new, :create ]
  def index
    if (params[:category_id])
      category = Category.find_by_id(params[:category_id])
      @sizes = category.nil? ? [] : category.sizes
    else
      @sizes = Size.all
    end

    respond_to do |format|
      format.html
      format.json { render :json => @sizes.to_json(:only => [ :id, :name ]) }
    end
  end

  def new
    @size = Size.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @size = Size.new(params[:size])
    
    respond_to do |format|
      if @size.save
        flash[:notice] = "Successfully created your size!"
        format.html { redirect_to sizes_path }
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
      if @size.update_attributes(params[:size])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_size_path(@size) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @size.destroy
    
    respond_to do |format|
      format.html { redirect_to sizes_path }
    end
  end

  def find_size
    @size = Size.find(params[:id])
  end

  def authority_required?
       %w(new create edit update destroy).include?(action_name) \
    || %w(index).include?(action_name) && request.format.html?
  end
end
