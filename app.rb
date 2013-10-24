module LW
  class App < Sinatra::Base
    use LW::Auth

    get "/" do
      logger.info 'hello'
      #if options[:no_login_required]
      #  identity_url = "https://localhost?id=user1"
      #  u_data = 'user1'
      #  $users[identity_url] = u_data
      #  env['warden'].set_user u_data
      #
      #  require 'labwiki/rack/top_handler'
      #  LabWiki::TopHandler.new(options).call(env)
      if warden.authenticated?
        #require 'labwiki/rack/top_handler'
        #LabWiki::TopHandler.new(options).call(env)
      else
        erector_tpl :layout, hello: 'world'
      end
    end
  end
end