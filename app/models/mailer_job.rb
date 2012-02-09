class MailerJob < Struct.new(:params)
  OFFER           = 1
  CATEGORY        = 2
  USER            = 3
  NEW_PLAGG       = 4
  PUBLISHED_PLAGG = 5
  DECLINED_PLAGG  = 6
  MONITORING      = 7
  
  def perform
    args = params.reject { |k, v| k.eql?(:kind) }

    case params[:kind]
    when OFFER           then Mailer.deliver_offer_email(args)
    when CATEGORY        then Mailer.deliver_watching_category_email(args)
    when USER            then Mailer.deliver_watching_user_email(args)
    when NEW_PLAGG       then Mailer.deliver_new_plagg_email(args)
    when PUBLISHED_PLAGG then Mailer.deliver_published_plagg_email(args)
    when DECLINED_PLAGG  then Mailer.deliver_declined_plagg_email(args)
    when MONITORING      then Mailer.deliver_monitoring_email(args)
    else false
    end
  end
end