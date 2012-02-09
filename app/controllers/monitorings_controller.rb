class MonitoringsController < ApplicationController
  def index
    @category_watchings = Watching.all(:conditions => { :watcher_id => current_user.id, :watchable_type => "Category" })
    @department_watchings = Watching.all(:conditions => { :watcher_id => current_user.id, :watchable_type => "Category" })
    @user_watchings     = Watching.all(:conditions => { :watcher_id => current_user.id, :watchable_type => "User" }, :order => "created_at DESC")

    @department_monitorings = Monitoring.find(:all, :group => "group_id", :conditions => ["user_id LIKE ?",current_user.id], :order => "created_at DESC")
    @var = []
    @tags = []
    @sizes = []
    @finalOutPut= Array.new
   i=0
   for dep in @department_monitorings
   @final = []
   @final_ids = []
   @final_dep = []
   @final_size = []
   @final_size_ids= []
   @final_loc = []
   @tag_records = Monitoring.find(:all, :conditions => ["monitorizable_type = 'Tag' and user_id= #{dep.user_id} AND group_id =#{dep.group_id}"])
   @size_records = Monitoring.find(:all, :conditions => ["monitorizable_type = 'Size' and user_id= #{dep.user_id} AND group_id =#{dep.group_id}"])
   @location_records = Monitoring.find(:all, :conditions => ["monitorizable_type = 'Location' and user_id= #{dep.user_id} AND group_id =#{dep.group_id}"])
 
  
     if dep.categorizable_type == "Department"
            @category_name = Department.find(dep.categorizable_id)
     else
            @category_name = Category.find(dep.categorizable_id)    
            @dep_name = Department.find(@category_name.department_id 	).name
            @final_dep <<  "#{@dep_name}"
     end
            @final_dep << "#{@category_name.name}"
            for tag in @tag_records
               @tag_name = Tag.find_by_id(tag.monitorizable_id)
               @final  << "#{@tag_name.name}"
               @final_ids << tag.monitorizable_id
            end
          
            for size_rec in @size_records
                @size_name = Size.find(size_rec.monitorizable_id)
                @final_size <<  "Size #{@size_name.name}"
                @final_size_ids << @size_name.id
            end
    
            for location in @location_records
                @location_name = Location.name(location.monitorizable_id)
                if !@location_name.blank?
                @final_loc <<  @location_name
                end
            end
    
 
            @finalOutPut <<  {:dep => @final_dep, :tag => @final, :tag_ids =>  @final_ids, :rec_sizes => @final_size , :rec_size_ids => @final_size_ids, :location => @final_loc ,:group_id => dep.group_id,:time_created => dep.created_at, :is_mon => dep.is_monitored, :category_id => dep.categorizable_id}

             i = i+1
  end
    @category_watchings.each do |w|
      w.current_unseen = w.new_unseen
      w.new_unseen = 0
      w.save!
    end

    @department_watchings.each do |w|
      w.current_unseen = w.new_unseen
      w.new_unseen = 0
      w.save!
    end

    #~ @user_watchings.each do |w|
      #~ w.current_unseen = w.new_unseen
      #~ w.new_unseen = 0
      #~ w.save!
    #~ end

    respond_to do |format|
      format.html
    end
  end
  
  #method for deleting selected monitoring
  def delete
    @monitorings = Monitoring.find(:all, :conditions => ["group_id LIKE ? AND user_id LIKE ?",params[:id],current_user.id])
    if !@monitorings.blank?
      for monitoring in @monitorings
       monitoring.destroy
     end
     flash[:notice] = "The selected monitoring is successfully deleted."
    else
     flash[:notice] = "Invalid monitoring record"
   end
   redirect_to :controller => "monitorings", :tab => params[:tab] and return
  end
end
