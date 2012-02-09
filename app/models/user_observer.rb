class UserObserver < ActiveRecord::Observer
  def after_create(user)
	unless user.facebooker?
      Mailer.deliver_confirmation_email(user)
	end
  end
end
