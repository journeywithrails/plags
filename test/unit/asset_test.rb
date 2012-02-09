require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  context "the Asset class" do
    should_belong_to :plagg

    should_have_attached_file :data
    should_validate_attachment_presence :data
    should_validate_attachment_content_type :data, :valid => [ "image/jpeg", "image/jpg", "image/pjpeg", "image/png", "image/x-png", "image/gif" ] 
    should_validate_attachment_size :data, :less_than => 10.megabytes
  end
end
