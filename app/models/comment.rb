require 'rdiscount'

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates_presence_of :text

  def text_html
    RDiscount.new(text).to_html
  end
end
