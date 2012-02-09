class RemoveDepartmentIdFromMonitorings < ActiveRecord::Migration
  def self.up
    Monitoring.all.each do |monitor|
       monitor.update_attributes(:categorizable_id => monitor.department_id, :categorizable_type => 'Department')
    end
    remove_column :monitorings, :department_id
  end

  def self.down
    add_column :monitorings, :department_id, :integer
    Monitoring.all.each do |monitor|
       if monitor.categorizable_type == 'Department'
         monitor.update_attribute(:department_id, monitor.categorizable_id)
       end
    end
  end
end
