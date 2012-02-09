module TagsHelper
  def tag_group(tag)
    case tag.group
    when Tag::Group::BRAND
      "Brand"
    when Tag::Group::SEASON
      "Season"
    when Tag::Group::OCCASION
      "Occasion"
    when Tag::Group::CONDITION
      "Condition"
    when Tag::Group::SUBCATEGORY
      "Sub Category"
    else
      "Brand"
    end
  end

  def tag_groups
    [
      [ "Brand", Tag::Group::BRAND ],
      [ "Season", Tag::Group::SEASON ],
      [ "Occasion", Tag::Group::OCCASION ],
      [ "Condition", Tag::Group::CONDITION ],
	  [ "Sub Category", Tag::Group::SUBCATEGORY ]
    ]
  end
end
