module LW
  class App < Sinatra::Base
    helpers  do
      def warden
        env['warden']
      end

      def erector_tpl(template_name, *args)
        "LW::Template::#{template_name.to_s.camelize}".constantize.new(*args).to_pretty
      end
    end
  end
end
