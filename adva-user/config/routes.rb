Rails.application.routes.draw do
  devise_for :user, :module => 'user'
end