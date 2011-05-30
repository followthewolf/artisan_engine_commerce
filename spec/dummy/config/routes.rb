Dummy::Application.routes.draw do
  post '/cgi_bin/webscr' => 'dummy_paypal#show'
end
