class GuidesController < ApplicationController
  before_filter :find_guide, :except => [ :index, :new, :create ]

  def index
    @guides = Guide.paginate(:page => params[:page], :order => "created_at DESC")

    respond_to do |format|
      format.html
    end
  end

  def show
    @comments = Comment.all(:conditions => [ "commentable_id = ? AND commentable_type = ?", @guide.id, "Guide" ], :include => :user)
    @comment = @guide.comments.new if logged_in?

    respond_to do |format|
      format.html
    end
  end

  def new
    @guide = Guide.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @guide = Guide.new(params[:guide])
    @guide.user = current_user

    respond_to do |format|
      if @guide.save
        flash[:notice] = "Successfully published your page!"
        format.html { redirect_to guide_path(@guide) }
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
      if @guide.update_attributes(params[:guide])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_guide_path(@guide) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @guide.destroy
    
    respond_to do |format|
      format.html { redirect_to guides_path }
    end
  end

  protected

  def find_guide
    @guide = Guide.find(params[:id])
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end
end
