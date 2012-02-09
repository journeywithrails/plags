require 'test_helper'

class SizingTest < ActiveSupport::TestCase
  context "the Sizing class" do
    should_belong_to :category
    should_belong_to :size

    should_validate_presence_of :category_id, :size_id
  end
end
