class User::PasswordsController < Devise::PasswordsController
  layout 'user'

  protected

  # FIXME this should work automatically.
  #
  # In the original method definition in the Devise::PasswordsController,
  # new_session_path(:user) is supposed to returns the new_user_session_path.
  # For some reason, this does not work inside the test-host-app.
  #
  # This fixes the test. It remains, however, unclear wether this is an
  # adva-anomaly or a devise-bug.
  def after_sending_reset_password_instructions_path_for(resource_name)
    require 'devise/version'
    unless Devise::VERSION == '1.4.8'
      raise "Review wether this workaround is still necessary."
    end
    new_user_session_path
  end
end
