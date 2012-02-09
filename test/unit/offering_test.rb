require 'test_helper'

class OfferingTest < ActiveSupport::TestCase
  context "the Offering class" do
    should_belong_to :offer, :plagg

    should_validate_presence_of :offer_id, :plagg_id
  end
end
