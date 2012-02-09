require 'test_helper'

class SizeTest < ActiveSupport::TestCase
  context "the Size class" do
    setup do
      Factory.create(:size)
    end

    should_have_many :plaggs
    should_have_many :sizings, :dependent => :destroy
    should_have_many :categories, :through => :sizings

    should_validate_presence_of :name
    should_validate_uniqueness_of :name, :case_sensitive => false
  end
end
