class Monitoring < ActiveRecord::Base
   belongs_to :user
   belongs_to :monitorizable, :polymorphic => true
   belongs_to :categorizable, :polymorphic => true
   validates_presence_of :user_id, :department_id, :monitorizable_type, :monitorizable_id, :categorizable_type, :categorizable_id

   def self.monitor(user, categorizable, selected_tags, selected_sizes, location, group_count_no)
     all_tags = Tag.non_brands.map(&:id)
     all_sizes =  Size.all.map(&:id)
     import_data(user, categorizable, selected_tags, 'Tag', true, group_count_no)
     import_data(user, categorizable, (all_tags - selected_tags), 'Tag', false, group_count_no)
     import_data(user, categorizable, selected_sizes, 'Size', true, group_count_no)
     import_data(user, categorizable, (all_sizes - selected_sizes), 'Size', false, group_count_no)
     if !location.blank?
        locations = []
        Location.all.each  { |l|  locations <<  Location.id(l) }
        location_id = [Location.city_county_id(location)]
        import_data(user, categorizable, location_id, 'Location', true, group_count_no)
        import_data(user, categorizable, (locations - location_id), 'Location', false, group_count_no)
     end
   end

   def self.monitored(group_id, user, categorizable, monitorizable_type, find_one = false)
      #conditions = {:conditions => ["user_id = ?  AND categorizable_type = ? AND categorizable_id = ? AND monitorizable_type = ? AND is_monitored = ?", user.id, categorizable.class.to_s,  categorizable.id, monitorizable_type, true]}
      conditions = {:conditions => ["user_id = ?  AND categorizable_type = ? AND categorizable_id = ? AND monitorizable_type = ? AND group_id = ?", user.id, categorizable.class.to_s,  categorizable.id, monitorizable_type, group_id]}
     
    if find_one
        monitoring = first(conditions)
        monitoring ? monitoring.monitorizable_id : nil
     else
       all(conditions).map(&:monitorizable_id)
     end
   end

  
  def self.notify(plagg)
    notifiables = []
    ['Department', 'Category'].each  do |categorizable_type|
      monitorizables = ['Tag', 'Location']
      if categorizable_type == 'Department' 
        categorizable =  plagg.department 
      else
        categorizable = plagg.category
        monitorizables << 'Size'
      end
      categorizable_name =  categorizable.name
      condition = ''
      monitorizables.each do |m|
        if m == 'Tag'
          monitorizable_ids = plagg.tags.map(&:id)
        elsif m =='Location'
          monitorizable_ids = [Location.city_county_id(plagg.user.location)]
        else
          monitorizable_ids = [plagg.size_id]
        end
        unless monitorizable_ids.blank?
           monitorizable_ids.each do |z|
             condition += "'#{m}_#{z}', "
           end
        end
      end
      unless condition.blank?
        condition.chop!.chop!
        select = []
        ['IN', 'NOT IN'].each do |n|
          select <<  "SELECT DISTINCT user_id FROM monitorings WHERE categorizable_type = '#{categorizable_type}' AND categorizable_id = '#{categorizable.id}' AND is_monitored = 1 AND CONCAT(monitorizable_type, '_', monitorizable_id) #{n} (#{condition})"
        end
        user_ids = Monitoring.find_by_sql("#{select[0]} AND user_id NOT IN (#{select[1]})").map(&:user_id)
        user_ids.each do |user_id|
          next if user_id == plagg.user_id
          user = User.find(user_id)
          Watching.all(:conditions => { :watchable_id => categorizable.id, :watchable_type => categorizable_type }).each do |watching|
              watching.new_unseen += 1
              watching.save!
              unless watching.new_unseen > 1
                Delayed::Job.enqueue(MailerJob.new({
                  :kind               => MailerJob::MONITORING,
                  :recipient_address  => user.email_address,
                  :recipient_username => user.username,
                  :categorizable      => categorizable,
                  :plagg_title        => plagg.title,
                  :plagg_id           => plagg.id
                }))
                notifiables << {:user_id => user.id, :categorizable_name => categorizable.name}
              end
            end
         end
      end
    end
    notifiables
  end
 
  def self.import_data(user, categorizable, tags, tag_type, selected, group_count_no)
    tags.each do |tag|
      if selected
        monitoring = find_or_create_by_user_id_and_categorizable_type_and_categorizable_id_and_monitorizable_type_and_monitorizable_id(user.id, categorizable.class.to_s, categorizable.id, tag_type, tag, group_count_no)
		monitoring.update_attribute(:group_id, group_count_no)
        monitoring.update_attribute(:is_monitored, true) unless monitoring.is_monitored
      else
        monitoring = find_by_user_id_and_categorizable_type_and_categorizable_id_and_monitorizable_type_and_monitorizable_id(user.id, categorizable.class.to_s,  categorizable.id, tag_type, tag, group_count_no)
        monitoring.update_attribute(:is_monitored, false) if monitoring and monitoring.is_monitored
      end
    end
  end

end
