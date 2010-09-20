module Adva::User::Paths
  def path_to(page)
    case page
    when /^the sign in page$/
      new_user_session_path
    when /^the new registration page$/
      new_user_registration_path
    else
      super
    end
  end
end

World(Adva::User::Paths)
