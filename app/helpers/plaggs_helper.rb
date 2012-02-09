module PlaggsHelper
  def add_asset_link(text, builder, options = {})
    asset = builder.object.class.reflect_on_association(:assets).klass.new
    markup = builder.fields_for(:assets, asset, :child_index => "new_asset_index") do |f|
      render :partial => "asset", :locals => { :f => f }
    end
    link_to_function "Add a picture", "add_asset(this, \"#{escape_javascript(markup)}\")", options
  end

  def remove_asset_link(text, options = {})
    link_to_function "Remove", "remove_asset(this)", options
  end
  
  def contact_info
    if @plagg.user.phone_number.empty?
      "#{link_to "mail #{@plagg.user.username}", "#", { :id => "contact_now_link" }} regarding the #{@plagg.title}."
    else
      "Call #{@plagg.user.phone_number} or #{link_to "mail #{@plagg.user.username}", "#", { :id => "contact_now_link" }} regarding the #{@plagg.title}."
    end
  end

end
