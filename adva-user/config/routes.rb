Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions      => 'session',
    :registrations => 'registrations'
  }
end