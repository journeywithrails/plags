require 'fastercsv'
class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
      t.integer :county_id

      t.timestamps
    end
   add_index :cities, :county_id
   counties_cities =  FasterCSV.read(RAILS_ROOT + '/doc/cities_counties.csv')
   seen_blank = true
   county_name = ''
   counties_cities.each do |county_city| 
      if seen_blank
        county_name = county_city[0]
      elsif !county_city[0].blank? and !county_name.blank?
        City.create(:name => county_city[0], :county_id => County.find_by_name(county_name).id) 
      end
      seen_blank = county_city[0].blank? ? true : false
    end
  end

  def self.down
    drop_table :cities
  end
end
