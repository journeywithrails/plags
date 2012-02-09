class DepartmentsController < ApplicationController
  prepend_before_filter :find_department, :except => [ :index, :new, :create ]
  
  def index
    @departments = Department.paginate(:page => params[:page], :order => "created_at DESC")
    
    respond_to do |format|
      format.html
    end
  end

  def show
    if params[:filter]
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

    conditions = "department_id = ?"
    args = [ @department.id ]

    unless authorized?
      conditions += " AND approved = ?"
      args.push true
    end

    if !session[:filter][:tags].empty?
     condition = nil
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
    @brand = session[:filter][:brand_name]

    @plaggs = Plagg.paginate(:conditions => conditions, :page => params[:page], :per_page => per_page, :order => "created_at DESC", :include => [ :assets, :user ])

    respond_to do |format|
      format.html
    end
  end

  def monitor
    @tags = Tag.non_brands_grouped
    @sizes = Size.all
    @sel_tags = Monitoring.monitored(current_user, @department, 'Tag')
    @sel_sizes = Monitoring.monitored(current_user, @department, 'Size')
    @location = Location.name(Monitoring.monitored(current_user, @department, 'Location', true))
  end

  def set_monitor
    if params[:filter]
      tags  = params[:filter][:tags].map  { |i| i.to_i } .select { |i| i > 0 }
      sizes = params[:filter][:sizes].blank? ? [] : params[:filter][:sizes].map { |i| i.to_i } .select { |i| i > 0 }
      location = params[:filter][:location]
      group_count = Monitoring.find(:first, :order => "group_id DESC")
      group_count.blank? ? group_count_no= 1 : group_count_no = group_count.group_id + 1
      Monitoring.monitor(current_user, @category, tags, sizes, location, group_count_no)
      flash[:notice] = "Successfully set monitoring parameters"
    else
      flash[:error] = "No parameters selected"
    end

    respond_to do |format|
       format.html { redirect_to department_path(@department) }
    end
  end


  def new
    @department = Department.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @department = Department.new(params[:department])
    
    respond_to do |format|
      if @department.save
        flash[:notice] = "Successfully created your department!"
        format.html { redirect_to departments_path}
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
      if @department.update_attributes(params[:department])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_department_path(@department) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @department.destroy

    respond_to do |format|
      format.html { redirect_to departments_path }
    end
  end

  def watch
    watching = current_user.watchings.new({
      :watchable_id   => @department.id,
      :watchable_type => "Department",
      :current_unseen => 0,
      :new_unseen => 0
    })

    respond_to do |format|
      if watching.save
        flash[:notice] = "You will now receive notifications when new ads are submitted to #{@department.name}."
      else
        flash[:warning] = "You're already monitoring this department."
      end

      format.html { redirect_to :back }
    end
  end

  def ignore
    watching = current_user.watchings.first(:conditions => {
      :watchable_id =>   @department.id,
      :watchable_type => "Department"
    })

    respond_to do |format|
      if watching && watching.destroy
        flash[:notice] = "You will no longer receive notifications when ads are submitted to #{@department.name}."
      else
        flash[:warning] = "You're not monitoring this department."
      end

      format.html { redirect_to :back }
    end
  end


  protected

  def find_department
    @department = Department.find(params[:id])
  end

  def authority_required?
    %w(index new create edit update destroy).include?(action_name)
  end
end
