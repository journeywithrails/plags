require 'test_helper'

class PageTest < ActiveSupport::TestCase
  context "the Page class" do
    should_have_many :comments

    should_belong_to :user

    should_validate_presence_of :title, :content, :user_id

    should_not_allow_mass_assignment_of :user_id
  end
end
