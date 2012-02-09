class ApplicationController < ActionController::Base
  before_filter :authenticate_if_necessary
  before_filter :redirect_if_unverified
  before_filter :redirect_if_unauthorized
  before_filter :find_navigation_items
  before_filter :login_from_cookie, :except=>:destroy
  before_filter :display_brands
  
  #~ before_filter :set_facebook_session

  helper_method :authentication_required?, :authority_required?,
                :current_user, :logged_in?, :authorized? #,  :facebook_session

  helper :all
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation

  rescue_from ActiveRecord::RecordNotFound, :with => :respond_with_404
  rescue_from ActionController::RedirectBackError, :with => :handle_referrerless_redirect

  protected

   #~ def login_from_cookie
      #~ if cookies[:auth_token] = User.authenticate(cookies[:username],cookies[:password])     
        #~ session[:user] = cookies[:auth_token]
      #~ return unless cookies[:auth_token] && !logged_in?
      #~ user = User.find_by_remember_token(cookies[:auth_token])
      #~ if user && user.remember_token?
        #~ user.remember_me
        #~ self.current_user = user
        #~ cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at 
      #~ end
    #~ end
    #~ else
     
      #~ flash[:notice] ="you need to login"
    #~ end
    #~ end
    #~ end
    
  
def login_from_cookie
  
  return unless cookies[:auth_token] && !logged_in?
  user = User.find_by_remember_token(cookies[:auth_token])
   if user && user.remember_token?
     user.remember_me
     session[:user]  = user
     cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
   
   end
end

    
    
    
    
    
    
    
    
   
   
   def current_user
    @current_user ||= authenticate_via_session
  end

  def authenticate_via_session
    User.find_by_id(session[:user])
  end

 def logged_in?
      current_user
    end
    


  def verified?
    logged_in? && current_user.verified?
  end

  def authorized?
    logged_in? && current_user.authorized?
  end

  def authentication_required?
    false
  end

  def verification_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def authority_required?
    false
  end
  
  def display_brands
    @brands =Plagg.find(:all, :conditions=>[ "brand_name NOT LIKE?", 'NULL'], :group => "brand_name") 
  end 

  def per_page
    if params[:per_page]
      pp = params[:per_page].to_i
      pp = 8 unless pp > 0
      session[:per_page] = pp
    elsif session[:per_page]
      pp = session[:per_page]
    else
      session[:per_page] = 8
      pp = session[:per_page]
    end

    pp
  end

  private

  def authenticate_if_necessary
      
    if authentication_required? && !logged_in?
      respond_to do |format|
	      flash[:warning] = "You must be signed in to do that."
        session[:destination] = request.request_uri
        format.html { redirect_to sign_in_path }
      end
    end
  end

  def redirect_if_unverified
    if verification_required? && !verified?
      respond_to do |format|
        flash[:warning] = "You must be a verified member to do that. Please click the confirmation link that was sent to your email address when you signed up."
        format.html { redirect_to :back }
      end
    end
  end

  def redirect_if_unauthorized
    if authority_required? && !authorized?
      respond_to do |format|
        flash[:warning] = "You must be an administrator to do that."
        format.html { redirect_to :back }
      end
    end
  end

  def find_navigation_items
    @nav_departments = Department.all

    if @plagg
      @nav_categories = @plagg.department.categories.find_all_by_sub_category(false)
      @nav_sub_categories = @plagg.department.categories.find_all_by_sub_category(true)
    elsif @department
      @nav_categories = @department.categories.find_all_by_sub_category(false)
      @nav_sub_categories = @department.categories.find_all_by_sub_category(true)
    elsif @category
      @nav_categories = @category.department.categories.find_all_by_sub_category(false)
      @nav_sub_categories = @category.department.categories.find_all_by_sub_category(true)
    else
      if @nav_departments.empty?
        @nav_categories = []
      else
        @nav_categories = @nav_departments.first.categories.find_all_by_sub_category(false)
        @nav_sub_categories = @nav_departments.first.categories.find_all_by_sub_category(true)
      end
    end
  end

  def respond_with_404
    respond_to do |format|
      format.html { render :file => "public/404.html", :status => 404 }
    end
  end

  def handle_referrerless_redirect
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
end
