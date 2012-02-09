class PagesController < ApplicationController
  before_filter :find_page, :except => [ :index, :new, :create ]

  def index
    @pages = Page.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @comments = Comment.all(:conditions => [ "commentable_id = ? AND commentable_type = ?", @page.id, "Page" ], :include => :user)
    @comment = @page.comments.new if logged_in?

    respond_to do |format|
      format.html
    end
  end

  def new
    @page = Page.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @page = Page.new(params[:page])
    @page.user = current_user

    respond_to do |format|
      if @page.save
        flash[:notice] = "Successfully published your page!"
        format.html { redirect_to slugged_page_path(:slug => @page.slug) }
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
      if @page.update_attributes(params[:page])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_page_path(@page) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @page.destroy
    
    respond_to do |format|
      format.html { redirect_to pages_path }
    end
  end

  protected

  def find_page
    if params[:slug]
      raise ActiveRecord::RecordNotFound unless @page = Page.find_by_slug(params[:slug])
    else
      @page = Page.find(params[:id])
    end
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end
end
