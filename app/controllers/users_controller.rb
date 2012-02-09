class UsersController < ApplicationController
  before_filter :find_user, :except => [ :new, :create, :confirm ]
  before_filter :redirect_back_unless_privileged, :only => [ :edit, :update, :destroy ]

  def show
    conditions = "user_id = ?"
    args = [ @user.id ]

    unless authorized?
      conditions += " AND approved = ?"
      args.push true
    end

    conditions = [ conditions ] + args
    
    @plaggs = Plagg.paginate(:conditions => conditions, :page => params[:page], :order => "created_at DESC", :include => :department)

    respond_to do |format|
      format.html
    end
  end

  def new
    @user = User.new
    @networks=Network.all
    @networks.each do |n|
      @user.networks_users.build
    end
    respond_to do |format|
      if logged_in?
        format.html { redirect_to user_path(current_user) }
      else
        format.html
      end
    end
  end

  def create
    @user = User.new(params[:user])
    @user.role = params[:user][:role] if authorized?
    
    respond_to do |format|
      if  verify_recaptcha(:model => @user) && @user.save
        flash[:notice] = "Welcome to Plaggs.com! We sent an e-mail that needs to be verfied."
        session[:user] = @user.id
        format.html { redirect_to user_path(@user) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @networks=Network.all

    if @user.networks.blank?
      @networks.each do |n|
        @user.networks_users.build
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def update
    @user.attributes = params[:user]
    @user.role = params[:user][:role] if authorized?
     params[:user][:network_ids] ||= []

    respond_to do |format|
      if @user.save
         

        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_user_path(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if authorized?
        format.html { redirect_to users_path }
      else
        format.html { redirect_to sign_out_path }
      end
    end
  end

  def watch
    watching = current_user.watchings.new({
      :watchable_id   => @user.id,
      :watchable_type => "User",
      :current_unseen => 0,
      :new_unseen => 0
    })

    respond_to do |format|
      if watching.save
        flash[:notice] = "You will now receive notifications when #{@user.username} submits new ads."
      else
        flash[:warning] = "You're already monitoring this user."
      end

      format.html { redirect_to :back }
    end
  end

  def ignore
    watching = current_user.watchings.first(:conditions => {
      :watchable_id =>   @user.id,
      :watchable_type => "User"
    })

    respond_to do |format|
      if watching && watching.destroy
        flash[:notice] = "You will no longer receive notifications when #{@user.username} submits new ads."
      else
        flash[:warning] = "You're not monitoring this user."
      end

      format.html { redirect_to :back }
    end
  end

  def confirm
    respond_to do |format|
      if user = User.confirm(params[:token])
        session[:user] = user.id
	      flash[:notice] = "Thanks for confirming your email address!"
	      format.html { redirect_to root_path }
	    else
	      flash[:warning] = "That looks like an invalid confirmation token. Please try again or contact an administrator for help."
	      format.html { redirect_to :back }
	    end
	  end
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  def verification_required?
    false
  end

  def authentication_required?
    %w(edit update destroy watch ignore).include?(action_name)
  end

  def redirect_back_unless_privileged
    unless authorized? || current_user == @user
      respond_to do |format|
        flash[:warning] = "You don't have the proper permissions to do that."
        format.html { redirect_to user_path(@user) }
      end
    end
  end

end