module ActionView
  module Helpers
    module CaptureHelper
      def content_for!(name, content = nil, &block)
        ivar = "@content_for_#{name}"
        instance_variable_set(ivar, nil)
        content_for(name, content, &block)
      end
    end
  end
end
