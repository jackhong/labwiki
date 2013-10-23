require 'warden-openid'
require 'openid/store/filesystem'

module LW
  class Auth < Sinatra::Base
    use Warden::Manager do |manager|
      manager.default_strategies :openid
    end

    post '/unauthenticated' do
      if openid = env['warden.options'][:openid]
        # OpenID authenticate success, but user is missing (Warden::OpenID.user_finder returns nil)
        identity_url = openid[:response].identity_url
        user_data = OpenID::AX::FetchResponse.from_success_response(openid[:response]).data
        $users[identity_url] = user_data
        env['warden'].set_user identity_url
        redirect '/'
      else
        # When OpenID authenticate failure
        [401, {'Location' => '/labwiki', "Content-Type" => ""}, [
          "<p>Authentication failed. #{env['warden'].message}<p>
         <a href='/labwiki/logout'>Try again</a>
          "
        ]]
      end
    end

    post '/signin' do
      warden.authenticate!
      flash[:notice] = 'You signed in'
      redirect '/'
    end

    get '/signout' do
      warden.logout(:default)
      flash[:notice] = 'You signed out'
      redirect '/'
    end
  end
end
