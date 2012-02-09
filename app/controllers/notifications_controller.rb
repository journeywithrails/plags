class NotificationsController < ApplicationController
  include ActionView::Helpers::DateHelper
  def index
    @sent     = Offer.all(:conditions => [ "sender_id = ? AND sent_at IS NOT ? AND accepted_at IS ?  ", current_user.id, nil,nil ],:order=>"updated_at DESC")
    @received_offers = Offer.all(:conditions => [ "receiver_id = ? AND received_at IS NOT ? AND accepted_at IS ?", current_user.id, nil, nil ],:group=>:plagg_id,:order=> "updated_at DESC")
    @accept=Offer.all(:conditions => [ "(sender_id = ? OR receiver_id = ?) AND accepted_at IS NOT ?", current_user.id,current_user.id, nil ],:order=> "updated_at DESC")
    @category_watchings = Watching.all(:conditions => { :watcher_id => current_user.id, :watchable_type => "Category" })
    @user_watchings     = Watching.all(:conditions => { :watcher_id => current_user.id, :watchable_type => "User" })
    @department_watchings = Watching.all(:conditions => { :watcher_id => current_user.id, :watchable_type => "Department" })
    
   

     @category_watchings.each do |w|
      w.current_unseen = w.new_unseen
      w.new_unseen = 0
      w.save!
    end

    @department_watchings.each do |w|
      w.current_unseen = w.new_unseen
      w.new_unseen = 0
      w.save!
    end

    @user_watchings.each do |w|
      w.current_unseen = w.new_unseen
      w.new_unseen = 0
      w.save!
    end
   
    respond_to do |format|
      format.html
    end
  end

  def unseen
    offer_count = Offer.count(:conditions => [ "receiver_id = ? AND received_at IS NOT ? AND viewed_at IS ? AND accepted_at IS ?", current_user.id, nil, nil,nil ])
    watching_count = Watching.all(:conditions => [ "watcher_id = ?", current_user.id ], :select => :new_unseen).inject(0) do |sum, w|
      sum += w.new_unseen
    end
    accept_count=Offer.count(:conditions => [ "sender_id = ? AND accepted_at IS NOT ? AND viewed_at IS ?", current_user.id, nil,nil ])
    total_offer_count=offer_count+accept_count
    offer_time=Offer.maximum(:updated_at,:conditions => [ "(receiver_id = ? AND received_at IS NOT ? AND viewed_at IS ? AND accepted_at IS ?) OR ( sender_id = ? AND accepted_at IS NOT ? AND viewed_at IS ?) ", current_user.id, nil, nil,nil,current_user.id, nil,nil ])
    watch_time=Watching.maximum(:updated_at,:conditions => [ "watcher_id = ? and new_unseen > 0", current_user.id ])
    unless watch_time.nil?
      watch_time= time_ago_in_words(watch_time) +" ago"
    end
     unless offer_time.nil?
      offer_time= time_ago_in_words(offer_time) +" ago"
    end
    if total_offer_count == 0
      total_offer_count="no"
    end
    if watching_count==0
      watching_count="no"
    end
    respond_to do |format|
      format.json { render :json => { :offer_count => total_offer_count, :watching_count => watching_count ,:offer_time => offer_time, :watching_time =>watch_time} }
    end
  end

  def authentication_required?
    true
  end
end
