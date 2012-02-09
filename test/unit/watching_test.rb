require 'test_helper'

class WatchingTest < ActiveSupport::TestCase
  context "the Watching class" do
    should_belong_to :user
    should_belong_to :watchable
  end
end
