class OffersController < ApplicationController
  before_filter :find_offer, :except => [ :create, :unread ]

  def create
    plagg = Plagg.find(params[:offer][:plagg_id])
    plagg_ids=params[:offer][:plagg_ids]
    plagg_ids.each do|p|

      @offer=Offer.new(:plagg_id => params[:offer][:plagg_id],
                       :sender_id => current_user.id,
                       :receiver_id => plagg.user.id,
                       :received_at => Time.now,
                       :sent_at => Time.now )
          
      if current_user != plagg.user
        if plagg.is_tradeable?
          if @offer.save
            @offer.offerings.create(:plagg_id => p, :notes => params[:offer][:notes][p])
            @flash_msg = "Your offer has been sent! The plagg's owner will contact you if they're interested."
            @errors=true
          else
            @flash_msg = "Unable to create your offer. Please try again."
            @errors=false
          end
        else
          @flash_msg = "That plagg isn't available for trading."
          @errors=true
        end
      else
        @flash_msg = "You can't make an offer to yourself."
        @errors=true
      end
    end
    
    respond_to do |format|
    if @errors==true
       flash[:notice] = @flash_msg
       format.html { redirect_to :back }
    else
       flash[:notice] = @flash_msg
       format.html { redirect_to plagg_path(plagg) }
    end
  end
  end

  def rdestroy
    if @offer.receiver == current_user
      if @offer.sent_at.nil?
        @offer.destroy
      else
        @offer.update_attribute(:received_at, nil)
      end
    else
      flash[:warning] = "You must be the barter suggestion's receiver to do that."
    end

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def sdestroy
    if @offer.sender == current_user
      if @offer.received_at.nil?
        @offer.destroy
      else
        @offer.update_attribute(:sent_at, nil)
      end
    else
      flash[:warning] = "You must be the barter suggestion's sender to do that."
    end

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def accept
    if @offer.receiver == current_user
        @offer.update_attribute(:sent_at, @offer.created_at) if @offer.sent_at.nil?
        @offer.update_attribute(:accepted_at, Time.now)
        @offer.update_attribute(:viewed_at, nil)
        Mailer.deliver_offer_accept_email(@offer)
    else
      flash[:warning] = "You must be the barter suggestion's receiver to do that"
    end
     respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def delete_accept 
    if @offer.receiver == current_user
      unless @offer.accepted_at.nil?
        @offer.update_attribute(:accepted_at, nil)
      end
    elsif @offer.sender == current_user
      unless @offer.sent_at.nil?
        @offer.update_attribute(:sent_at, nil)
      end
    else
      flash[:warning] = "You must be the barter suggestion's receiver or sender to do that"
    end
     respond_to do |format|
      format.html { redirect_to :back }
    end
  end
  protected

  def authentication_required?
    true
  end

  def find_offer
    @offer = Offer.find(params[:id])
  end
end
