class AboutUsController < ApplicationController


def index
  end

def faq
 @content = Content.find(:all, :order=>'contents.weight DESC')
end


def terms
end

def contact
end

end