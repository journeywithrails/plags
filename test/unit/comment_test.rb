require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  context "the Comment class" do
    should_belong_to :user
    should_belong_to :commentable

    should_validate_presence_of :text
  end
end
