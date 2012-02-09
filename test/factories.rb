Factory.sequence(:title) do |i|
  "Generic title slash name ##{i}"
end

Factory.sequence(:email_address) do |i|
  "user#{i}@plaggs.com"
end

Factory.define(:plagg) do |f|
  f.title        { Factory.next(:title) }
  f.description  { "Generic non-nil description." }
  f.price        { "32 SEK" }
  f.is_tradeable { true }
  f.association  :user
  f.association  :department
  f.association  :category
  f.association  :size
end

Factory.define(:department) do |f|
  f.name { Factory.next(:title) }
end

Factory.define(:category) do |f|
  f.name        { Factory.next(:title) }
  f.association :department
end

Factory.define(:tag) do |f|
  f.name  { Factory.next(:title) }
  f.group { Tag::Group::BRAND }
end

Factory.define(:size) do |f|
  f.name { Factory.next(:title) }
end

Factory.define(:user) do |f|
  f.username              { Factory.next(:title) }
  f.email_address         { Factory.next(:email_address) }
  f.password              { "password" }
  f.password_confirmation { "password" }
end

Factory.define(:post) do |f|
  f.title       { Factory.next(:title) }
  f.content     { "Here's a blog post!" }
  f.association :user
end

Factory.define(:page) do |f|
  f.title       { Factory.next(:title) }
  f.content     { "Here's some page content!" }
  f.association :user
end