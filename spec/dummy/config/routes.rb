Dummy::Application.routes.draw do
  root :to => 'dummy_front#show'
  post '/cgi_bin/webscr' => 'dummy_paypal#show'
  get '/subscribe' => 'dummy_front#subscribe'
end
