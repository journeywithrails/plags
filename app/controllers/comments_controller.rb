class CommentsController < ApplicationController
  before_filter :find_comment, :except => [ :index, :create ]

  def index
    if params[:page_id]
      @page = Page.find(params[:page_id])
      
      respond_to do |format|
        format.html { redirect_to page_path(@page) }
      end
    elsif params[:post_id]
      @post = Post.find(params[:post_id])
      
      respond_to do |format|
        format.html { redirect_to post_path(@post) }
      end
    end
  end

  def create
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @comment = @page.comments.new(params[:comment])
      @comment.user = current_user

      respond_to do |format|
        if @comment.save
          format.html { redirect_to page_path(@page) }
        else
          format.html { render :template => "pages/show" }
        end
      end
    elsif params[:plagg_id]
      @plagg = Plagg.find(params[:plagg_id])
      @comment = @plagg.comments.new(params[:comment])
      @comment.user = current_user

      respond_to do |format|
        if @comment.save
          format.html { redirect_to plagg_path(@plagg) }
        else
          format.html { render :template => "plaggs/show" }
        end
      end
    elsif params[:post_id]
      @post = Post.find(params[:post_id])
      @comment = @post.comments.new(params[:comment])
      @comment.user = current_user

      respond_to do |format|
        if @comment.save
          format.html { redirect_to post_path(@post) }
        else
          format.html { render :template => "posts/show" }
        end
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
      if @comment.update_attributes(params[:comment])
        flash[:notice] = "Your changes were saved."
        case @comment.commentable.class.to_s
        when "Post"
          format.html { redirect_to post_path(@comment.commentable) }
        when "Plagg"
		  format.html { redirect_to plagg_path(@comment.commentable) }
        else
          format.html { redirect_to page_path(@comment.commentable) }
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      if @comment.commentable.class.to_s == "Post"
        format.html { redirect_to post_path(@comment.commentable) }
      else
        format.html { redirect_to page_path(@comment.commentable) }
      end
    end
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def authentication_required?
    true
  end
end
