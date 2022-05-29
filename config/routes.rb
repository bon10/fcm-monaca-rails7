Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root  'users#index'
  
  #ユーザー一覧を表示
  get '/users', to: 'users#index'

  # トークンを登録更新する
  post '/token', to: 'users#token'

end
