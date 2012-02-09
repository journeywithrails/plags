class AddApprovedToPlaggs < ActiveRecord::Migration
  def self.up
    add_column :plaggs, :approved, :boolean
    
    Plagg.update_all("approved = 'true'")
  end

  def self.down
    remove_column :plaggs, :approved
  end
end
