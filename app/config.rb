module LW
  class App < Sinatra::Base
    configure do
      enable :sessions
      enable :logging
    end

    configure :development do
      require 'pry'

      set :public_folder, "./www"
    end

    configure :production do
    end
  end
end
