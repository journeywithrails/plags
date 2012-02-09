class SessionsController < ApplicationController
    before_filter :login_from_cookie, :except => :destroy

  
  def index
    
    render :text => "Your Password has been changed successfully" and return
    
  end
  
  
  def new
    respond_to do |format|
      if logged_in?
        format.html { redirect_to root_path }
      else
        format.html
      end
    end
  end



  def create
    respond_to do |format|
      if session[:user] = User.authenticate(params[:session][:username], params[:session][:password])
         if logged_in?
            if params[:remember_me].to_i == 1
               self.current_user.remember_me
               cookies[:auth_token] = {:value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
               cookies[:username] = { :value => params[:session][:username], :expires => 20.days.from_now }
               cookies[:password] = { :value => params[:session][:password], :expires => 20.days.from_now }
            else
               self.current_user.forget_me
               cookies.delete(:auth_token)
               cookies[:auth_token] = nil
               cookies.delete  :username
               cookies.delete  :password
            end
         end

       
        
           if session[:destination]
               @destination = session[:destination]
               session[:destination] = nil
           else
               @destination = "http://plaggs.com:3000"
           end    
    
    flash[:warning] = nil
        format.html { redirect_to @destination }
        format.js
      else
        flash[:warning] = "We couldn't find an account with that username and password. Please try again."
        format.html { render :action => "new" }
        format.js { render :layout => false }
      end
    end
  end



def forgot_password
     $title = "Plaggs Forgot Password Page"
    
     if request.post?
          user = User.find(:first, :conditions => ["email_address LIKE ?",params[:session][:email_address]]) || user = User.find(:first, :conditions => ["username LIKE ?",params[:session][:username]]) 
                    

          if user
            random_password = User.random_password(8)
            token = User.random_password(10)
            user.update_attributes(:security_token => token)
            Mailer.deliver_reset_password(user.id,user.email_address,random_password,user.username,user.security_token)	   
            flash[:notice] = "An email has been sent to you containing your password."
            redirect_to :action => 'forgot_password'  and return
          else
           flash[:warning] = 'You are not authorized user to use this service.'
          end

      end   
  end
  
#method for saving new password
def active_new_password

  @user = User.find(:first, :conditions => ["id LIKE ? AND security_token LIKE ?",params[:id], params[:alias]])
  if @user
         @user.password = params[:value]
     @user.password_confirmation = params[:value]
     @user.update_attributes(params[:user])
    flash[:notice] = "Your password has been changed successfully"
    redirect_to :action => 'new'
  else
    flash[:warning] = "Password has not been changed due to some invalid data"
     redirect_to :action => 'forgot_password' and return
  end
end


  #~ def destroy
    #~ if current_user.facebooker?
      #~ clear_fb_cookies!
      #~ clear_facebook_session_information
    #~ end
    
     #~ reset_session
    #~ session[:user_id] = nil
      #~ cookies[:username] = ''
     #~ cookies[:password] = ''
     
    #~ respond_to do |format|
      #~ flash[:notice] = "You are now logged out."
      #~ format.html { redirect_to root_path }
    #~ end
  #~ end
  
  
  
def destroy
  
    if current_user.facebooker?
      clear_fb_cookies!
      clear_facebook_session_information
    end
  
  #~ current_user.last_seen_at = Time.now 
  #~ current_user.save
  self.current_user.forget_me if logged_in?
  cookies.delete(:auth_token)
  reset_session
 respond_to do |format|
      flash[:notice] = "You are now logged out."
      format.html { redirect_to root_path }
    end
end

  
  
  
  
  
  
  
  
  
  
  
  
  

  def link_with_facebook
    respond_to do |format|
      if current_user
        current_user.link_to_facebook_user(facebook_session.user) unless current_user.fb_user_id == facebook_session.user.uid
        destination = session[:destination] || :back
        format.html { redirect_to destination }
      elsif user = User.find_by_facebook(facebook_session.user)
        session[:user] = user
        destination = session[:destination] || :back
        format.html { redirect_to destination }
      else
        u = User.create_from_facebook_session(facebook_session.user)
        flash[:notice] = "Thanks for connecting with Facebook! Please pick a username and enter an email address below."
        format.html { redirect_to edit_user_path(u) }
      end
    end
  end

  protected

  def verification_required?
    false
  end
end
