Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions      => 'admin/session',
    :registrations => 'admin/registrations'
  }
end