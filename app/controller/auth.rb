require 'warden-openid'
require 'openid/store/filesystem'

$users = {}

OPENID_FIELDS = {
  google: ["http://axschema.org/contact/email", "http://axschema.org/namePerson/last"],
  geni: ['http://geni.net/projects', 'http://geni.net/slices', 'http://geni.net/user/urn', 'http://geni.net/user/prettyname']
}

Warden::OpenID.configure do |config|
  config.required_fields = OPENID_FIELDS[:geni]
  config.user_finder do |response|
    identity_url = response.identity_url
    user_data = OpenID::AX::FetchResponse.from_success_response(response).data
    $users[identity_url] = user_data
    identity_url
  end
end

module LW
  class App < Sinatra::Base

    use Rack::OpenID

    use Warden::Manager do |manager|
      manager.default_strategies :openid
      manager.failure_app = App
    end

    post '/unauthenticated' do
      flash[:alert] = "#{warden.message}"
      redirect '/'
    end

    post '/signin' do
      warden.authenticate!
      flash[:success] = 'You signed in'
      redirect '/'
    end

    get '/signin' do
      logger.info 'hello'
      erector_tpl :signin, flash: flash
    end

    get '/signout' do
      warden.logout(:default)
      flash[:success] = 'You signed out'
      redirect '/'
    end
  end
end
