class OfferObserver < ActiveRecord::Observer
  def after_create(offer)
    recipient      = offer.receiver
    sender         = offer.sender
    offering_count = offer.offerings.size
    plagg_title    = offer.plagg.title

    Delayed::Job.enqueue(MailerJob.new({
      :kind               => MailerJob::OFFER,
      :recipient_address  => recipient.email_address,
      :recipient_username => recipient.username,
      :sender_username    => sender.username,
      :offering_count     => offering_count,
      :plagg_title        => plagg_title
    }))
  end
end
