class PostsController < ApplicationController
  before_filter :find_post, :except => [ :index, :new, :create, :update]

  def index
    @posts = Post.paginate(:page => params[:page], :order => "created_at DESC")

    respond_to do |format|
      format.html
    end
  end

  def show
    @comments = Comment.all(:conditions => [ "commentable_id = ? AND commentable_type = ?", @post.id, "Post" ], :include => :user)
    @comment = @post.comments.new if logged_in?

    respond_to do |format|
      format.html
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html
    end
  end

  def create
      require 'iconv' 
      require 'unicode'
    str=  params[:post][:title]
      str = no_accents(str)
      #~ s = ((translation_to && translation_from) ? Iconv.iconv(translation_to, translation_from, str ) : str ).to_s
    render :text=>str and return
    @post = Post.new(params[:post])
    @post.user = current_user
    respond_to do |format|
      if @post.save
        flash[:notice] = "Successfully published your page!"
        format.html { redirect_to post_path(@post.perma_link) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def translation_to
    'ascii//translit//IGNORE'
  end
  def translation_from 
    'utf-8'
end
def no_accents(str)
    str = str.gsub(/\ ö + /, 'o')
      str = str.gsub(/\ è + /, 'e')

  end
  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      @post = Post.find(params[:id])
      if @post.update_attributes(params[:post])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_post_path(@post.perma_link) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to posts_path }
    end
  end

  protected

  def find_post
    @post = Post.find_by_perma_link(params[:id])
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end
  

end
