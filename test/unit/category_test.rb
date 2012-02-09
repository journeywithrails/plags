require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  context "the Category class" do
    setup do
      Factory.create(:category)
    end

    should_have_many :sizings, :dependent => :destroy
    should_have_many :sizes, :through => :sizings
    should_have_many :plaggs
    should_have_many :watchings
    should_have_many :watchers, :through => :watchings

    should_belong_to :department

    should_validate_presence_of :name, :department_id
  end
end
