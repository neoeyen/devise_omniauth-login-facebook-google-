Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks' } # :registrations => "users/registrations" - user의 controller 사용해야할때 추가
  match '/users/:id/finish_signup' => 'user/users#finish_signup', via: [:get, :patch], :as => :finish_signup  # 사인업이 끝나면 보내주는건데... 잘 모르겠다 ㅠㅠ


  # get 'home/index'
  root 'home#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
