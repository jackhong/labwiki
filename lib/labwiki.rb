require 'omf_web'
require 'omf_base/lobject'
require 'omf_common/lobject'
OMF::Base::Loggable.init_log 'labwiki', :searchPath => File.join(File.dirname(__FILE__), 'labwiki')
OMF::Common::Loggable.init_log 'labwiki', :searchPath => File.join(File.dirname(__FILE__), 'labwiki')

require 'labwiki/plugin_manager'
require 'labwiki/configurator'
require 'labwiki/session_init'
require 'labwiki/rack/plugin_resource_handler'
require 'labwiki/rack/search_handler'
require 'labwiki/rack/column_handler'

# Configure the web server
#
opts = {
  :app_name => 'labwiki',
  :page_title => 'LabWiki',
  :footer_left => lambda do
    #img :src => '/resource/image/imagined_by_nicta.jpeg', :height => 24
    text 'Imagined by NICTA'
  end,
  :footer_right => 'git:labwiki',

  :theme => 'labwiki/theme',
  :port => 4000,
  :rackup => File.dirname(__FILE__) + '/labwiki/config.ru',
  #:login_required => true,
  :handlers => {
    # Should be done in a better way
    :pre_rackup => lambda {
      LabWiki::PluginManager.init
      LabWiki::Configurator.init_omf_web
    },
    # TODO Fix this
    #:pre_parse => lambda do |p|
    #  p.separator ""
    #  p.separator "LabWiki options:"
    #  p.on("--lw-config CONFIG_FILE", "File to hold LabWiki's local configurations") do |fname|
    #    LabWiki::Configurator.load_from(fname)
    #  end
    #  p.on("--lw-no-login", "If set, all sessions are automatically assigned to local account") do
    #    OMF::Web::Runner.instance.options[:no_login_required] = true
    #  end
    #  p.separator ""
    #end,
    # post_parse should return true if everything is ok
    :post_parse => lambda do
      unless LabWiki::Configurator.configured?
        OMF::Base::Loggable.logger(:opts).fatal "Missing --lw_config option"
        false
      else
        true
      end
    end
  }
}
#OMF::Web.start(opts)
