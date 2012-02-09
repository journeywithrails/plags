require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  context "the Offer class" do
    should_have_many :offerings, :dependent => :destroy
    should_have_many :plaggs,    :through => :offerings

    should_belong_to :sender, :receiver, :plagg
    
    should_validate_presence_of :plagg_id
  end
end
