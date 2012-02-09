unless RAILS_ENV == "production"
  ActiveRecord::Base.transaction do
    %w(Men Women Kids Subcategory).each do |department_name|
      department = Department.create!(:name => department_name)

      %w(Tops Bottoms Accessories).each do |category_name|
        department.categories.create!({ :name => category_name })
      end
    end

    Size.create([
      { :name => "XS" },
      { :name => "S"  },
      { :name => "M"  },
      { :name => "L"  },
      { :name => "XL" }
    ])

    Category.all.each do |category|
      category.sizes = Size.all
      category.save!
    end

    Tag.create([
      { :name => "Spring", :group => Tag::Group::SEASON },
      { :name => "Summer", :group => Tag::Group::SEASON },
      { :name => "Fall",   :group => Tag::Group::SEASON },
      { :name => "Winter", :group => Tag::Group::SEASON },

      { :name => "Work",     :group => Tag::Group::OCCASION },
      { :name => "Leisure",  :group => Tag::Group::OCCASION },
      { :name => "Training", :group => Tag::Group::OCCASION },
      { :name => "Party",    :group => Tag::Group::OCCASION },

      { :name => "New",  :group => Tag::Group::CONDITION },
      { :name => "Used", :group => Tag::Group::CONDITION }
    ])

    admin = User.new({
      :username => "admin",
      :email_address => "admin@plaggs.com",
      :password => "admin",
      :password_confirmation => "admin"
    })
    admin.role = User::Role::ADMINISTRATOR
    admin.save!

    member = User.new({
      :username => "member",
      :email_address => "member@plaggs.com",
      :password => "member",
      :password_confirmation => "member"
    })
    member.role = User::Role::MEMBER
    member.save!

    unverified = User.new({
      :username => "unverified",
      :email_address => "unverified@plaggs.com",
      :password => "unverified",
      :password_confirmation => "unverified"
    })
    unverified.role = User::Role::UNVERIFIED
    unverified.save!

    post = Post.new({
      :title => "This is a test post",
      :content => "It comes with test content."
    })
    post.user = admin
    post.save

    comment = post.comments.build({
      :text => "And this is the test comment it comes with."
    })
    comment.user = admin
    comment.save

    page = Page.new({
      :title => "This is a test page",
      :content => "It comes with test content too."
    })
    page.user = admin
    page.save
  end
end