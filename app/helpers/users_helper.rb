module UsersHelper
  def user_role(user)
    case user.role
    when User::Role::MEMBER
      "Member"
    when User::Role::ADMINISTRATOR
      "Administrator"
    else
      "Member"
    end
  end

  def user_genders
    [
      [ "Male", 1 ],
      [ "Female", 2 ]
    ]
  end

  def user_roles
    [
      [ "Member", User::Role::MEMBER ],
      [ "Administrator", User::Role::ADMINISTRATOR ]
    ]
  end
end
