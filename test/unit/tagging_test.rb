require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  context "the Tagging class" do
    should_belong_to :plagg
    should_belong_to :tag

    should_validate_presence_of :plagg_id, :tag_id
  end
end
