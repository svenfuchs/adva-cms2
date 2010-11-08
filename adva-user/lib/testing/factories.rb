Factory.define :user, :class => User do |f|
  f.sequence(:email) { |n| "user-#{n}@example.com" }
  f.password 'password'
  f.after_build  { |user| User.deactivate_callbacks }
  f.after_create { |user| user.confirm!; User.activate_callbacks }
end

Factory.define :admin, :parent => :user do |f|
  f.email { User.find_by_email('admin@admin.org') ? 'admin-2@admin.org' : 'admin@admin.org' }
  f.password 'admin!'
end
