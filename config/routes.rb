Rails.application.routes.draw do
  get "/" => "home#top"
  get "/login" => "universities#login_form"
  get "/players/index" =>"players#index"
  get "/reg/top" => "universities#top"
  post "/login" => "universities#login"
  post "/logout" => "universities#logout"
  post "/players/add" => "players#add"
  post "/players/destroy/:id" => "players#destroy"
  get "/players/edit/:id" => "players#edit"
  post "players/update/:id" => "players#update"
  get 'entries/index' => "entries#index"
  post "entries/add" => "entries#add"
  post "entries/destroy/:id" => "entries#destroy"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
