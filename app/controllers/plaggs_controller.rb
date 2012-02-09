class PlaggsController < ApplicationController
  prepend_before_filter :find_plagg, :except => [ :index, :new, :create ]
  before_filter :redirect_back_unless_privileged, :only => [ :edit, :update, :destroy ]

  def index
    #~ render :text => session[:user] and return
    if request.post? && params[:query]
      if authorized?
        @plaggs = Plagg.search(params[:query])
      else
        @plaggs = Plagg.search(params[:query], :conditions => { :approved => true })
      end
    elsif params[:filter]
      if params[:filter][:tags]
        tags  = params[:filter][:tags].map  { |i| i.to_i } .select { |i| i > 0 }
        session[:filter][:tags] = tags
      else
        session[:filter][:tags] = []
      end
      if params[:filter][:sizes]
        sizes = params[:filter][:sizes].map { |i| i.to_i } .select { |i| i > 0 }
        session[:filter][:sizes] = sizes
      else
        session[:filter][:sizes] = []
      end
      if params[:filter][:location]
        session[:filter][:location] = params[:filter][:location]
      else
        session[:filter][:location] = ''
      end
      if params[:filter][:brand_name]
        session[:filter][:brand_name] = params[:filter][:brand_name]
      else
        session[:filter][:brand_name] = ''
      end
      
      
      
    else
      session[:filter] = {}
      session[:filter][:tags]  = session[:filter][:tags]  || []
      session[:filter][:sizes] = session[:filter][:sizes] || []
      session[:filter][:location] = session[:filter][:location] || ''
      session[:filter][:brand_name] = session[:filter][:brand_name] || ''
    end

    conditions = "category_id != ?"
    args = [ 24]

    unless authorized?
      conditions += " AND approved = ?"
      args.push true
    end

    if !session[:filter][:tags].empty?
	      #~ condition = nil
	      seasons = Tag.all(:conditions => [ "id IN (?) and `group` = 2 ", session[:filter][:tags]])#, :select => "tag_id").map(&:tag_id)
	      occassions = Tag.all(:conditions => [ "id IN (?) and `group` = 3", session[:filter][:tags]])#, :select => "tag_id").map(&:tag_id)
	      other_conditions = Tag.all(:conditions => [ "id IN (?) and `group` = 4", session[:filter][:tags]])#, :select => "tag_id").map(&:tag_id)
	    condition = Tag.filter_search_combinations(seasons,occassions,other_conditions)
	     
	    
      plaggs = Tagging.find_by_sql("#{condition}").map(&:plagg_id)
      conditions += " AND id IN (?)"
      args.push plaggs
    end

    if !session[:filter][:sizes].empty?
      conditions += " AND size_id IN (?)"
      args.push session[:filter][:sizes]
    end

    if !session[:filter][:location].blank?    
      city_county = Location.get_city_county(session[:filter][:location])
      unless city_county.blank?
        conditions += " AND user_id IN (?)"
        args.push  Location.users_for(city_county).map(&:id)
      end
    end
    
     if !session[:filter][:brand_name].empty?
      conditions += " AND brand_name LIKE (?)"
      args.push session[:filter][:brand_name]
    end
    
    conditions = [ conditions ] + args
    
    @tags = Tag.non_brands_grouped
    @sizes = Size.all
    @sel_tags = session[:filter][:tags]
    @sel_sizes = session[:filter][:sizes]
    @location = session[:filter][:location]
    @brand= session[:filter][:brand_name]
    @plaggs = Plagg.paginate(:conditions => conditions, :page => params[:page], :per_page => per_page, :order => "created_at DESC", :include => [ :assets, :user ])

    respond_to do |format|
      format.html
    end
  end

  def show
    @plagg = Plagg.find(params[:id], :include => [ :department, :category, :user, :size, :assets ])
    @comments = Comment.all(:conditions => [ "commentable_id = ? AND commentable_type = ?", @plagg.id, "Plagg" ], :include => :user)
    @comment = @plagg.comments.new if logged_in?
    unless @plagg.approved?
      raise ActiveRecord::RecordNotFound unless logged_in? && (@plagg.user == current_user || authorized?)
      flash[:notice] = "This Plagg will not be publicly viewable until an admin approves it." if flash[:notice].blank?
    end

    tags = @plagg.tags.partition { |tag| tag.group == Tag::Group::CONDITION }

    @conditions = tags[0]
    @tags = tags[1]
    @offer = Offer.new if logged_in?

    respond_to do |format|
      format.html
    end
  end

  def vote_plagg
    if Vote.find(:all,:conditions=>["user_id=? and plagg_id=?",current_user.id,params[:id]]).blank?
      vote= Vote.new
      vote.plagg_id=params[:id]
      vote.user_id=current_user.id
      vote.save
      
      count=Plagg.find(params[:id]).votes.count
      respond_to do |format|
        format.json { render :json => count }
      end
    end
  end
  
  def new
    
    @plagg = Plagg.new 
    @plagg.user = current_user
    respond_to do |format|
      format.html
    end
  end

  def create
    #~ render :text => params[:plagg][:size_id] and return
    @plagg = Plagg.new(params[:plagg])
    @plagg.approved = params[:plagg][:approved] if authorized?
    @plagg.user = current_user

    respond_to do |format|
      if @plagg.save
        flash[:notice] = "Your ad has been saved and will be publicly accessible once an admin approves it."
        format.html { redirect_to plagg_path(@plagg) }
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
      params[:plagg][:asset_ids] += @plagg.asset_ids if params[:plagg][:asset_ids]
      @plagg.approved = false
      if @plagg.update_attributes(params[:plagg])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to plagg_path(@plagg) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if authorized? || @plagg.user == current_user
        @plagg.destroy
        flash[:notice] = "Ad successfully deleted."
        format.html { redirect_to plaggs_path }
      else
        flash[:warning] = "You must be the ad's creator to do that."
        format.html { redirect_to plagg_path(@plagg) }
      end
    end
  end

  def publish
    
    
    
    
    @plagg.approved = true
    @plagg.save!
    notifiables = []
    Watching.all(:conditions => { :watchable_id => @plagg.user_id, :watchable_type => "User" }).each do |watching|
      watcher = watching.watcher
      watchee = watching.watchee

      watching.new_unseen += 1
      watching.save!
      unless watching.new_unseen > 1
        Delayed::Job.enqueue(MailerJob.new({
          :kind               => MailerJob::USER,
          :recipient_address  => watcher.email_address,
          :recipient_username => watcher.username,
          :user_username      => watchee.username,
          :user_id            => watcher.id
        })) 
        notifiables << {:user_id => watcher.id, :watchee_username => watchee.username}
      end
    end

    notifiables += Monitoring.notify(@plagg)

    Delayed::Job.enqueue(MailerJob.new({
      :kind               => MailerJob::PUBLISHED_PLAGG,
      :recipient_address  => @plagg.user.email_address,
      :recipient_username => @plagg.user.username,
      :plagg_title        => @plagg.title,
      :plagg_id           => @plagg.id
    }))
    notifiables += [{:user_id =>  @plagg.user.id}]

    #if more than one notification send one generic message
    #more_than_one is an array of user ids that can receive more than one message
    user_ids = []
    more_than_one = []
    notifiables.each do |notifiable|
      if user_ids.include?(notifiable[:user_id])
         more_than_one << notifiable[:user_id]
      else
         user_ids << notifiable[:user_id]
      end
    end
    sent_user_ids = []
    notifiables.each do |notifiable|
      begin
        unless sent_user_ids.include?(notifiable[:user_id])
          sent_user_ids << notifiable[:user_id]
          render :juggernaut => {:type => :send_to_client, :client_id =>  notifiable[:user_id] } do |page|
            if more_than_one.include?(notifiable[:user_id])
                message = 'You have notifications'
            else
                if notifiable.has_key?(:watchee_username)
                  message = "New ad by #{notifiable[:watchee_username]}"
                elsif notifiable.has_key?(:categorizable_name)
                  message = "New ad in #{notifiable[:categorizable_name]}"
                else
                  message = 'Your ad has been approved and published'
                end
            end
            page['#notify'].html(message)
          end
        end
      rescue => exc
        logger.info "PlaggsController.publish juggernaut error: #{exc}"
      end
    end
    respond_to do |format|
      flash[:notice] = "Successfully published this ad."
      format.html { redirect_to plagg_path(@plagg) }
    end
  end

  def decline
     render :text => params.inspect and return
    Delayed::Job.enqueue(MailerJob.new({
      :kind               => MailerJob::DECLINED_PLAGG,
      :recipient_address  => @plagg.user.email_address,
      :recipient_username => @plagg.user.username,
      :plagg_title        => @plagg.title,
      :plagg_id           => @plagg.id,
      :description_of_changes => params[:reason][:description_of_changes]
    }))
#~ Mailer.deliver_declined_plagg_email({
      #~ :kind               => 6,
      #~ :recipient_address  => 'swaminadhan_nyros@yahoo.com',
      #~ :recipient_username => @plagg.user.username,
      #~ :plagg_title        => @plagg.title,
      #~ :plagg_id           => @plagg.id,
      #~ :description_of_changes => params[:reason][:description_of_changes]
    #~ })
    #~ Mailer.deliver_reset_password(user.id,user.email_address,random_password,user.username,user.security_token)	   

    respond_to do |format|
      flash[:notice] = "Your message has been sent."
      @plagg.update_attributes(:approved=>0)
      format.html { redirect_to plagg_path(@plagg) }
      
    end
  end
def my_condition(cond1=0,cond2=0,cond3=0)
		condition = Tagging.find_by_sql("select plagg_id from taggings a where (a.tag_id = #{cond1} or a.tag_id = #{cond2}) and (select count(*) from taggings b where (b.tag_id = #{cond1} or b.tag_id = #{cond2}) and b.plagg_id=a.plagg_id)>1 group by plagg_id").map(&:plagg_id)       
		if condition.blank?
		return "",false	
		else
		 return "plagg_id in (#{condition.join(',')})",true
		end	
	end
  protected

  def find_plagg
    @plagg = Plagg.find(params[:id])

    if !@plagg.approved
      raise ActiveRecord::RecordNotFound unless logged_in? && (@plagg.user == current_user || authorized?)
    end
  end

  def authentication_required?
    %w(new create edit update destroy publish decline).include?(action_name)
  end

  def authorization_required?
    %w(publish decline).include?(action_name)
  end
  
  def redirect_back_unless_privileged
    unless authorized? || current_user == @plagg.user
      respond_to do |format|
        flash[:warning] = "You don't have the proper permissions to do that."
        format.html { redirect_to plagg_path(@plagg) }
      end
    end
  end
end
