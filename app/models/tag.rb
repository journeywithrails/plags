class Tag < ActiveRecord::Base
  class Group
    BRAND     = 1
    SEASON    = 2
    OCCASION  = 3
    CONDITION = 4
	SUBCATEGORY = 5
  end

  has_many :taggings, :dependent => :destroy
  has_many :plaggs, :through => :taggings
  has_many :monitorings, :as => :monitorizable

  validates_presence_of :name, :group
  validates_uniqueness_of :name, :case_sensitive => false

  def self.brands(options = {})
    self.all({ :conditions => { :group => Group::BRAND } }.merge(options))
  end

  def self.seasons(options = {})
    self.all({ :conditions => { :group => Group::SEASON } }.merge(options))
  end

  def self.occasions(options = {})
    self.all({ :conditions => { :group => Group::OCCASION } }.merge(options))
  end

  def self.conditions(options = {})
    self.all({ :conditions => { :group => Group::CONDITION } }.merge(options))
  end
  
  def self.subcategories(options = {})
    self.all({ :conditions => { :group => Group::SUBCATEGORY } }.merge(options))
  end

  def self.non_brands(options = {})
    self.all({ :conditions => [ "`group` != ? AND `group` != ?", Tag::Group::SUBCATEGORY, Tag::Group::BRAND] }.merge(options))
  end
  
  def self.non_brands_grouped(options = {})
    ts=[]
    Tag.seasons.each_with_index do|a,index|
      ts[index]=[a.name,a.id]
    end
    to=[]
    Tag.occasions.each_with_index do|a,index|
      to[index]=[a.name,a.id]
    end
    tc=[]
    Tag.conditions.each_with_index do|a,index|
      tc[index]=[a.name,a.id]
    end
    [["Seasons", ts], ["Occasions", to], ["Conditions", tc]]
  end
  
  
  
  
  
  
  
  
  
  
  
  #method for 
  def self.filter_search_combinations(seasons,occassions,other_conditions)
    condition = nil
    a=[];  b = [] ;  c= []       
    selected_count = 1
         if !seasons.blank?
             for season in seasons
                a << season.id
             end
            selected_count = selected_count+1
         end
      
         if !occassions.blank?
             for occassion in occassions
                  if selected_count == 1
                    a << occassion.id
                  else
                    b << occassion.id
                  end
             end
             selected_count = selected_count+1
           end
           
           
        if !other_conditions.blank?
             for other_condition in other_conditions
                if selected_count == 1
                  a << other_condition.id
               elsif selected_count == 2
                  b << other_condition.id
               else
                  c << other_condition.id
               end
             end
              selected_count = selected_count+1
      end
      
      if selected_count == 2
          count = 0
              condition =   "SELECT * FROM `taggings` WHERE "
                   for val in a
                        if count == 0
                           condition = condition + " tag_id= #{val}"
                           count=count+  1
                        else
                           condition = condition + " or tag_id= #{val}"
                        end
                    end
      end
             
      if selected_count == 3
           count1 = 0
           count2 = 0
           count3 = 0
                 condition =    "SELECT * FROM `taggings` WHERE `plagg_id` IN (SELECT `plagg_id` FROM `taggings` WHERE  "
                 for val in a
                      if count1 == 0
                       condition = condition + " ( tag_id= #{val}"
                       count1=count1+  1
                      else
                       condition = condition + " or tag_id= #{val}"
                      end
                 end
          
               condition = condition +  ")"
               condition = condition + "  AND `plagg_id` IN (SELECT `plagg_id` FROM `taggings` WHERE "
               for val1 in b
                    if count2 == 0
                      condition = condition + " ( tag_id= #{val1}"
                      count2=count2+  1
                     else
                      condition = condition + " or tag_id= #{val1}"
                     end
              end
                   condition = condition +  " ))GROUP BY `plagg_id` ) and ("
                   
             for val in a
                      if count3 == 0
                       condition = condition + "  tag_id= #{val}"
                       count3=count3+  1
                      else
                       condition = condition + " or tag_id= #{val}"
                      end
             end
                    
             for val in b
                    condition = condition + " or tag_id= #{val}"
             end
                    condition = condition + " )"
                   
             end
             

  if selected_count == 4
                 count1 = 0
                 count2 = 0
                 count3 = 0
                 count4 = 0
                 count5 = 0
                 condition =    "SELECT * FROM `taggings` WHERE `plagg_id` IN (SELECT `plagg_id` FROM `taggings` WHERE "
                 for val in a
                      if count1 == 0
                      condition = condition + " ( tag_id= #{val}"
                      count1=count1+  1
                     else
                      condition = condition + " or tag_id= #{val}"
                     end
                 end
          
               condition = condition +  ")"
               condition = condition + "  AND `plagg_id` IN (SELECT `plagg_id` FROM `taggings` WHERE "
               for val1 in b
                    if count2 == 0
                      condition = condition + " ( tag_id= #{val1}"
                      count2=count2+  1
                     else
                      condition = condition + " or tag_id= #{val1}"
                     end
                   end
                   condition = condition +  " )"
                   
                   
                  
               condition = condition + "  AND `plagg_id` IN (SELECT `plagg_id` FROM `taggings` WHERE "
               for val1 in c
                    if count3 == 0
                      condition = condition + " ( tag_id= #{val1}"
                      count3=count3+  1
                     else
                      condition = condition + " or tag_id= #{val1}"
                     end
                   end
                   condition = condition +  " ))) GROUP BY `plagg_id` ) and ("
                   
                   
                   
                   for val in a
                      if count4== 0
                      condition = condition + "  tag_id= #{val}"
                      count4=count4+  1
                     else
                      condition = condition + " or tag_id= #{val}"
                    end
                  end
                    
                      for val in b
                    
                         condition = condition + " or tag_id= #{val}"
                    end
                    
                    for val in c
                    
                      
                      condition = condition + " or tag_id= #{val}"
                      end
                    condition = condition + " )"
                   
             end
             
     return condition
  end
  
 
end
