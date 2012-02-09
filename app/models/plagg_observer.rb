class PlaggObserver < ActiveRecord::Observer
  def after_create(plagg)
    Delayed::Job.enqueue(MailerJob.new({
      :kind        => MailerJob::NEW_PLAGG,
      :plagg_title => plagg.title,
      :plagg_id    => plagg.id
    }))
  end
end