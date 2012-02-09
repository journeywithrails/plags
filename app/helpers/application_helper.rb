# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_department?(department, i)
    if @department && !@department.new_record?
      "selected" if department == @department
    elsif @category && !@category.new_record?
      "selected" if department == @category.department
    elsif @plagg && !@plagg.new_record?
      "selected" if department == @plagg.department
    end
  end

  def current_category?(category, i)
    if @category && !@category.new_record?
      "selected" if category == @category
    elsif @plagg && !@plagg.new_record?
      "selected" if category == @plagg.category
    end
  end

  def unseen?
    offer_count = Offer.count(:conditions => [ "receiver_id = ? AND received_at IS NOT ? AND viewed_at IS ? AND accepted_at IS ?", current_user.id, nil, nil, nil ])
    watching_count = Watching.all(:conditions => [ "watcher_id = ?", current_user.id ], :select => :new_unseen).inject(0) do |sum, w|
      sum += w.new_unseen
    end
    accept_count=@accept=Offer.count(:conditions => [ "sender_id = ? AND accepted_at IS NOT ? AND viewed_at IS ?", current_user.id, nil,nil ])
    suggestion_count=offer_count+accept_count
    
    if suggestion_count > 0 && watching_count > 0
      "notification"
    elsif suggestion_count > 0
      "suggestion"
    elsif watching_count > 0
      "monitoring"
    else
      "none"
    end
   end


#method for updating pink links
def update_pink_links(group_id)
  monitorings = Monitoring.find(:all, :conditions => ["user_id LIKE ? AND group_id LIKE ?",current_user.id,group_id])
   if  !monitorings.blank?
      for monitor_rec in monitorings
          monitor_rec.update_attribute(:is_monitored, 0) 
        end
   end
 end
 
 #methopd for updating users pink links
 def update_user_pink_links
    watching_counts = Watching.all(:conditions => [ "watcher_id = ? AND current_unseen LIKE ?", current_user.id,0])
      if  !watching_counts.blank?
          for test in watching_counts
               test.update_attribute(:current_unseen, true)
          end
        end
  end
end