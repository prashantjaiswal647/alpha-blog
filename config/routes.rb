Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :articles #, only: [:show, :index, :new, :create, :edit, :update, :destroy] # We slowly added all of the routes in one by one to learn about them. resources :articles has all of these, so having them all listed is no longer necessary.
  get 'signup', to: 'users#new'
  resources :users, except: [:new] # the users/new route (similar to articles/new, is ignored here since it is used in the signup above, so that localhost:3000/signup is for new users INSTEAD of localhost:3000/users/new)
  get 'login', to: 'sessions#new' # Manually creating routes for logging in and logging out. Manually adding sessions controller to handle this.
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :categories
end
