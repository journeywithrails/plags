class TagsController < ApplicationController
  before_filter :find_tag, :except => [ :index, :new, :create ]

  def index
    @tags = Tag.all(:order => "'group' ASC")
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @plaggs = @tag.plaggs.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 8)

    respond_to do |format|
      format.html
    end
  end

  def new
    @tag = Tag.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @tag = Tag.new(params[:tag])
    
    respond_to do |format|
      if @tag.save
        flash[:notice] = "Successfully created your tag!"
        format.html { redirect_to tags_path }
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
      if @tag.update_attributes(params[:tag])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_tag_path(@tag) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @tag.destroy
    
    respond_to do |format|
      format.html { redirect_to tags_path }
    end
  end

  protected
  
  def find_tag
    @tag = Tag.find(params[:id])
  end

  def authority_required?
    %w(index new create edit update destroy).include?(action_name)
  end
end
