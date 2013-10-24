module LW
  class App < Sinatra::Base
    configure do
      enable :sessions
      enable :logging
    end

    configure :development do
      set :public_folder, "./asset"
    end

    configure :production do
    end
  end
end
