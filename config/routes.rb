ActionController::Routing::Routes.draw do |map|
  map.root                 :controller => "plaggs",   :action => "index"
  map.sign_up  "sign-up",  :controller => "users",    :action => "new"
  map.sign_in  "sign-in",  :controller => "sessions", :action => "new"
  map.sign_out "sign-out", :controller => "sessions", :action => "destroy"
  map.confirm  "confirm",  :controller => "users",    :action => "confirm"
  map.mysession "sessions",:controller => "sessions", :action => "index"
  map.forgotpassword "forgot-password",:controller => "sessions", :action => "forgot_password"


  map.facebook "sessions/link_with_facebook", :controller => "sessions", :action => "link_with_facebook"

  map.search        "plaggs/search",  :controller => "plaggs", :action => "index", :conditions => { :method => :post }
  map.publish_plagg "plaggs/:id/publish", :controller => "plaggs", :action => "publish", :conditions => { :method => :put }
  map.decline_plagg "plaggs/:id/decline", :controller => "plaggs", :action => "decline", :conditions => { :method => :post }
  map.resources :plaggs, :has_many => :comments

  map.resources         :departments, :member =>  {:monitor => :get, :set_monitor => :post, :watch => :post, :ignore => :delete }
  map.browse_department "departments/:id", :controller => "departments", :action => "show", :conditions => { :method => :post }

  map.resources :categories, :member =>  {:monitor => :get, :set_monitor => :post }
  map.browse_category "categories/:id",        :controller => "categories", :action => "show",   :conditions => { :method => :post }
  map.watch_category  "categories/:id/watch",  :controller => "categories", :action => "watch",  :conditions => { :method => :post }
  map.ignore_category "categories/:id/ignore", :controller => "categories", :action => "ignore", :conditions => { :method => :delete }
                      
  
  map.resources :ads, :collection =>  {:list => :get,:about => :get}
  map.resources :about_us,:collection =>  {:faq => :get , :terms => :get, :contact => :get}
   #~ map.ad_update 'ads/update/:id',:controller => 'ads',:action => 'update'
  ##test
 #~ map.satya "departments/:cat_id/:tag_id",  :controller => "tags", :action => "show"
 ##
 
 #map.ads  "ads", :controller => "ads", :action => "index"
 map.tag "/categories/:cat_id/:id", :controller => "categories", :action => "show"
 
 map.resources :tags
 
  map.resources :networks

  map.watch_user  "users/:id/watch",  :controller => "users", :action => "watch",  :conditions => { :method => :post }
  map.ignore_user "users/:id/ignore", :controller => "users", :action => "ignore", :conditions => { :method => :delete }
  map.resources :users
  map.resources :pages, :has_many => :comments
  map.resources :posts, :has_many => :comments, :as => 'guide'
  map.resources :guides, :has_many => :comments
  map.resources :comments
  map.resources :offers
  map.resources :sizes
  map.resources :assets
  map.resources :locations
  map.resources :brand_names
  
  map.monitoring "monitorings", :controller => "monitorings", :action => "index",  :method => :get
  map.monitoring_delete "monitorings/delete/:id", :controller => "monitorings", :action => "delete", :id => @id,  :method => :delete

  map.notifications "notifications",                :controller => "notifications", :action => "index",  :method => :get
  map.unseen        "notifications/unseen.:format", :controller => "notifications", :action => "unseen", :method => :get

  map.contact        "email/contact",          :controller => "email", :action => "contact", :method => :post
  map.contact_user        "email/contact_user",          :controller => "email", :action => "contact_user", :method => :post
  map.share_plagg_with_friend        "email/share_plagg_with_friend",          :controller => "email", :action => "share_plagg_with_friend", :method => :post


  map.slugged_page ":slug",          :controller => "pages", :action => "show"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end