Rails.application.routes.draw do
  resources :ldaps
  namespace :api do
    namespace :v1 do
      post "auth", to: "weixin#auth"
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
