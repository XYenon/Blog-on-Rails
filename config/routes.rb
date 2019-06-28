Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'articles#index'

  get '/register', to: 'users#new'
  get '/login', to: 'user_sessions#new'
  delete '/logout', to: 'user_sessions#destroy'

  get '/user', to: 'users#show', as: 'user'
  get '/user/edit', to: 'users#edit', as: 'edit_user'
  patch '/user', to: 'users#update'
  delete '/user', to: 'users#destroy'

  get '/search', to: 'search#index'
  get '/search/articles', to: 'search#articles'
  get '/search/users', to: 'search#users'

  get '/tags', to: 'tags#index'
  get '/tags/:name', to: 'tags#show', as: 'tag'

  get '/admin', to: 'admin#index'
  get '/admin/show/:id', to: 'admin#show', as: 'admin_show_user'
  get '/admin/edit/:id', to: 'admin#edit', as: 'admin_edit_user'
  patch '/admin/update/:id', to: 'admin#update', as: 'admin_update_user'
  delete '/admin/show/:id', to: 'admin#destroy', as: 'admin_destroy_user'

  resources :users
  resource :user_sessions, only: %i[new create destroy]
  resources :articles
  resources :comments

  resources :articles do
    resources :comments
  end
  resources :users do
    resources :articles
  end
  resources :users do
    resources :comments
  end
end
