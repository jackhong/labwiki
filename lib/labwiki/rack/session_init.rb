require 'omf-web/session_store'
require 'labwiki/plugin_manager'
require 'labwiki/core_ext/object'

module LabWiki

  class SessionInit < OMF::Base::LObject
    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      req = ::Rack::Request.new(env)

      # Unless request resource files, most likely to be static
      unless req.path =~ /^\/resource/
        # Session ID should be in cookie, but if cookies don't work (iBook widgets) we try
        # to carry them in the parameters.
        #
        # see OMF::Web::SessionStore
        req.session['sid'] ||= req.params['sid'] || "s#{(rand * 10000000).to_i}_#{(rand * 10000000).to_i}"
        Thread.current["sessionID"] = req.session['sid'] # needed for Session Store

        # Unless visiting public/unprotected pages
        unless req.path =~ /^\/(login|logout|unauthenticated)/
          if env['warden'].authenticated?
            unless LabWiki::Authentication.know_this_user?(env['warden'].user)
              req.session.clear
              if req.xhr?
                return [401, {}, ['Session lost, re-authenticate.']]
              else
                return [302, {'Location' => '/', "Content-Type" => ""}, ['Session lost, re-authenticate.']]
              end
            end
          else
            if LabWiki::Authentication.none?
              # No login hack, set a default user
              env['warden'].set_user "https://localhost?id=xxx"
            else
              env['warden'].authenticate!(LabWiki::Authentication.type)
            end
            return [302, {'Location' => '/', "Content-Type" => ""}, ['Session lost, re-authenticate.']]
          end
        end

        # Trigger start session callbacks
        unless OMF::Web::SessionStore[:initialised, :session]
          LabWiki::Configurator.start_session(OMF::Web::SessionStore[:id, :user])
          LabWiki::PluginManager.init_session()
          LabWiki::LWWidget.init_session()
          OMF::Web::SessionStore[:initialised, :session] = true
        end
      end

      @app.call(env)
    end

  end
end
