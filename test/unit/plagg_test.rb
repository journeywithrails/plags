require 'test_helper'

class PlaggTest < ActiveSupport::TestCase
  context "the Plagg class" do

    should_have_many :assets, :dependent => :destroy
    should_have_many :taggings, :dependent => :destroy
    should_have_many :tags, :through => :taggings

    should_belong_to :user
    should_belong_to :department
    should_belong_to :category
    should_belong_to :size

    should_validate_presence_of :title, :description, :price, :size_id
    should_allow_values_for :is_tradeable, true, false
  end
end
