Rails.application.routes.draw do

  get 'combination_fours/add'
  get 'remarks/add'
  get 'results/add'
  get 'ranks/add'
  get 'combinations/index'
  get 'races/index'
  get "/" => "home#top"
  get "/login" => "universities#login_form"
  get "/players/index" =>"players#index"
  get "/reg/top" => "universities#top"
  post "/login" => "universities#login"
  post "/logout" => "universities#logout"
  post "/players/add" => "players#add"
  post "/players/destroy/:id" => "players#destroy"
  get "/players/edit/:id" => "players#edit"
  post "/players/update/:id" => "players#update"
  get '/entries/index' => "entries#index"
  post "/entries/add1" => "entries#add1"
  post "/entries/add2" => "entries#add2"
  post "/entries/add3" => "entries#add3"
  post "/entries/add4" => "entries#add4"
  post "/entries/add" => "entries#add"
  post "/entries/delete" => "entries#delete"
  post "/entries/destroy/:id" => "entries#destroy"
  get "/pairs/index" => "pairs#index"
  post "/pairs/add/:id" => "pairs#add"
  post "/pairs/addtwo/:id" => "pairs#addtwo"
  post "/pairs/destroy/:id" => "pairs#destroy"
  post "/pairs/destroytwo/:id" => "pairs#destroytwo"
  get 'substitutes/index' => "substitutes#index"
  post 'substitutes/add' => "substitutes#add"
  post 'substitutes/destroy/:id' => "substitutes#destroy"
  get 'fours/index' => "fours#index"
  post "fours/add" => "fours#add"
  post "fours/destroy/:id" => "fours#destroy"
  get "/reg/confirm" => "universities#confirm"
  get "/reg/choice" => "universities#choice_tour_form"
  post "/choice" => "universities#choice"

  get "operations/top" => "operations#top"
  get "operations/login" => "operators#login_form"
  post "operations/login" => "operators#login"
  get "operators/index" => "operators#index"
  get "operators/edit/:id" => "operators#edit"
  post "operators/update/:id" => "operators#update"
  post "operations/logout" => "operators#logout"
  get "operations/accounts/index" => "accounts#index"
  post "operations/accounts/add" => "accounts#add"
  get "operations/accounts/edit/:id" => "accounts#edit"
  post "operations/accounts/update/:id" => "accounts#update"
  post "operations/accounts/destroy/:id" => "accounts#destroy"
  get "operations/bibs" => "bibs#index"
  post "operations/bibs/assign" => "bibs#assign"
  get "operations/races" => "races#index"
  post "operations/races/make" => "races#make"
  post "/operations/races/change" => "races#change"
  get "operations/races/show" => "races#show"
  post "/operations/races/add" => "races#add"
  post "operations/races/delete" => "races#delete"
  get "operations/entries1" => "races#entries1"
  get "operations/entries2" => "races#entries2"
  get "operations/entries4" => "races#entries4"
  get "operations/combinations" => "combinations#index"
  post "operations/combinations/lott" => "combinations#lott"
  get "operations/combinations/add" => "combinations#add"
  get "operations/combinations/comfirm" => "combinations#comfirm"
  post "operations/combinations/add" => "combinations#added"
  get "operations/ranks/add" => "ranks#add"
  get "operations/ranks/comfirm" => "ranks#comfirm"
  post "operations/ranks/add" => "ranks#added"
  get "operations/results/add" => "results#add"
  get "operations/results/search" => "results#search"
  post "operations/results/add" => "results#added"
  get "/operations/results/option" => "results#option"
  post "/operations/results/option_add" => "results#option_add"
  get "/operations/fours/search" => "combination_fours#search"
  get "/operations/fours/add" => "combination_fours#add"
  post "/operations/fours/add" => "combination_fours#added"
  get "/operations/fours/combi_search" => "combination_fours#combi_search"
  get "/operations/fours/combi_add" => "combination_fours#combi_add"
  post "/operations/fours/combi_add" => "combination_fours#combi_added"
  get "/operations/substitutes" => "operations#substitutes"
  get "/operations/entry_time" => "operations#entry_time"
  post "/operations/entry_time/change" => "operations#entry_time_change"

  get "/results" => "combinations#results"
  get "/search" => "combinations#search"
  get "/results_name" => "combinations#results_name"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
