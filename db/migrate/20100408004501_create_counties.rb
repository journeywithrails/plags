require 'fastercsv'
class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.string :name

      t.timestamps
    end
    counties_cities =  FasterCSV.read(RAILS_ROOT + '/doc/cities_counties.csv')
    seen_blank = true
    counties_cities.each do |county_city| 
      County.create(:name => county_city[0]) if seen_blank and !county_city[0].blank?
      seen_blank = county_city[0].blank? ? true : false
    end
  end

  def self.down
    drop_table :counties
  end
end
