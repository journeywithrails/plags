class Mailer < ActionMailer::Base
  def contact_email(params, sent_at = Time.now)
    recipients "jklina@pixelfuckers.org"
    from       "#{params[:email_address]}"
    subject    "Message from a user at Plaggs"
    sent_on    sent_at
    body       params
  end

  def contact_user_email(params, sent_at = Time.now)
    recipients "#{params[:to]}"
    from       "<noreply@plaggs.com>"
    subject    "Message regarding your plagg: #{params[:plagg_title]}"
    reply_to   "#{params[:from]}"
    sent_on    sent_at
    body       params
  end

   def share_plagg_email(params, sent_at = Time.now)
    recipients "#{params[:to]}"
    from       "<noreply@plaggs.com>"
    subject    "Check out this plagg: #{params[:plagg_title]}"
    reply_to   "#{params[:from]}"
    sent_on    sent_at
    body       params
  end

  def watching_category_email(params, sent_at = Time.now)
    recipients params[:recipient_address]
    from       "The Plaggs Crew <noreply@plaggs.com>"
    subject    "New ads in #{params[:category_name]}"
    sent_on    sent_at
    body       params
  end

  def monitoring_email(params, sent_at = Time.now)
    recipients params[:recipient_address]
    from       "The Plaggs Crew <noreply@plaggs.com>"
    subject    "New ad in #{params[:categorizable].name}"
    sent_on    sent_at
    body       params
  end

  def watching_user_email(params, sent_at = Time.now)
    recipients params[:recipient_address]
    from       "The Plaggs Crew <noreply@plaggs.com>"
    subject    "New ads by #{params[:user_username]}"
    sent_on    sent_at
    body       params
  end

  def offer_email(params, sent_at = Time.now)
    recipients params[:recipient_address]
    from       "The Plaggs Crew <noreply@plaggs.com>"
    subject    "#{params[:sender_username]} has an offer for you"
    sent_on    sent_at
    body       params
  end
  
  def confirmation_email(user, sent_at = Time.now)
    recipients user.email_address
    from       "robot@plaggs.com"
    subject    "Activating your Plaggs account"
    sent_on    sent_at
    @body["name"] = user.username
    @body["confirmation_url"] = confirm_url(:token => user.confirmation_token, :only_path => false)
  end

  def new_plagg_email(plagg, sent_at = Time.now)
    recipients "jklina@pixelfuckers.org"
    from       "robot@plaggs.com"
    subject    "A new ad awaits your approval"
    sent_on    sent_at
    body       params
  end

  def published_plagg_email(params, sent_at = Time.now)
    recipients params[:recipient_address]
    from       "The Plaggs Crew <noreply@plaggs.com>"
    subject    "Your ad has been approved and published"
    sent_on    sent_at
    body       params
  end

  def declined_plagg_email(params, sent_at = Time.now)

    recipients params[:recipient_address]
    from       "noreply@plaggs.com"
    subject    "Your ad is almost ready to be published"
    sent_on    sent_at
    body       params
  end




   def offer_accept_email(offer, sent_at = Time.now)
    @recipients=  offer.sender.email_address
    @from  =     "<noreply@plaggs.com>"
    @subject  =  "Your offer is accepted"
    @sent_on  =  sent_at
    @body =   {"offer" => offer}
  end
  
   #method for forgot password mail
  def reset_password(id,email_address,password,username,token)
   @subject                 = "Plaggs "  "-"  " Password Reminder"
   @body['id']       =  id
   @body['password']  =  password
   @recipients              =  email_address
   @body['username']  = username
   @body['token']  =  token
   @from                     = "support@plaggs.com"
   @content_type = "text/html"
  end

  
  
  
  
end
