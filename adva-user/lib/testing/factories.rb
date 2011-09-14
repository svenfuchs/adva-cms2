Factory::DefaultPassword = 'secret'

Factory.define :user, :class => User do |f|
  f.sequence(:email) { |n| "user-#{n}@example.com" }
  f.password Factory::DefaultPassword
  f.after_create { |user| user.confirm! }
end

Factory.define :admin, :parent => :user do |f|
  # FIXME should be possible to create more than one admin
  f.email { User.find_by_email('admin@admin.org') ? 'admin-2@admin.org' : 'admin@admin.org' }
  f.roles %w(admin)
end
