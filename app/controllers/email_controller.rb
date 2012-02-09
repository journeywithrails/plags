class EmailController < ApplicationController
    
    
    def contact
    respond_to do |format|
      unless params[:email][:name].blank? || params[:email][:email_address].blank? || params[:email][:body].blank?
        Mailer.deliver_contact_email(params[:email])
        flash[:notice] = "Thanks for contacting us! If appropriate, we'll contact you soon."
      else
        flash[:warning] = "You must provide a name, an email address, and a message to contact the administrators."
      end
      
      format.html { redirect_to :back }
    end
  end

  def contact_user
    respond_to do |format|
      unless params[:email][:Message].blank? || params[:email][:Title].blank?
          Mailer.deliver_contact_user_email(params[:email])
          flash[:notice] = "User will get your message and reply to your mail directly."
      else
        flash[:warning] = "You must provide an email address and Message to contact this user."
      end
      format.html { redirect_to :back }
    end
  end

   def share_plagg_with_friend
    respond_to do |format|
      unless params[:email][:Message].blank? || params[:email][:to].blank?
          Mailer.deliver_share_plagg_email(params[:email])
          flash[:notice] = "Thank you for sharing with your friend."
      else
        flash[:warning] = "You must provide an email address and Message to contact this user."
      end
      format.html { redirect_to :back }
    end
  end

end

