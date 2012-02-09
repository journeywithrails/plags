class Location

  class << self

    def all(conditions = {})
      County.all(conditions) + City.all(conditions)
    end
  
    def all_names(conditions = {})
      locations = []
      County.all(conditions).each do |county|
      locations << county.name
      end
      City.all(conditions).each do |city|
      locations << city.name + ' i ' + city.county.name
      end
      locations
    end
    
    def get_city_county(location)
      city_county = []
      unless location.blank?
        if location.include?(' i ')
          city_county = location.split(/ i /) 
        else
          city_county[1] = location
        end
      end
      city_county
    end
  
    def users_for(city_county)
      if city_county[0]
        User.all(:conditions => ['city = ? and county = ?', city_county[0], city_county[1]])
      else
        User.all(:conditions => ['county = ?', city_county[1]])
      end
    end

      def id(location)
      if !location.blank?
      location.class == City ? 1000 + location.id : location.id
    end
  end

    def city_county_id(location)
      city_county = get_city_county(location)
      county = County.find_by_name(city_county[1])
      if city_county[0]
        Location.id(City.find_by_name_and_county_id(city_county[0], county.id))
      else
        Location.id(county)
      end
    end
 
    def name(id)
      return '' unless id
      if id > 1000
        city = City.find(id - 1000)
        city.name + ' i ' + city.county.name
      else
        County.find(id).name
      end
    end

  end

end
