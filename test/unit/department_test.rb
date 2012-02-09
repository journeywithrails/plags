require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  context "the Department class" do
    setup do
      Factory.create(:department)
    end
    
    should_have_many :categories, :dependent => :destroy
    should_have_many :plaggs
    
    should_validate_presence_of :name
    should_validate_uniqueness_of :name, :case_sensitive => false
  end
end
