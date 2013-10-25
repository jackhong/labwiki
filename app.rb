require "sinatra/base"
require 'rack-flash'
require 'erector'
require 'active_support'

module LW
  class App < Sinatra::Base
    use Rack::Flash

    get '/' do
      #if options[:no_login_required]
      #  identity_url = "https://localhost?id=user1"
      #  u_data = 'user1'
      #  $users[identity_url] = u_data
      #  env['warden'].set_user u_data
      #
      #  require 'labwiki/rack/top_handler'
      #  LabWiki::TopHandler.new(options).call(env)
      if warden.authenticated?
        erector_tpl :layout, flash: flash
        #require 'labwiki/rack/top_handler'
        #LabWiki::TopHandler.new(options).call(env)
      else
        redirect '/signin'
      end
    end
  end
end
