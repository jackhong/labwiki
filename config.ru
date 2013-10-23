#require 'omf-web/content/irods_repository'

# Add lib files to load path
$:.unshift "#{File.dirname(__FILE__)}/lib"
#require 'labwiki'

require "sinatra"

app_files = Dir.glob("./app/**/*.rb").sort

app_files.each do |file|
  require file
end

require "./app"

run LW::App

#LW_PORT = "#{LabWiki::Configurator[:port] || 4000}"

#use ::Rack::ShowExceptions
#use ::Rack::Session::Cookie, secret: LW_PORT, key: "labwiki.session.#{LW_PORT}"
#use ::Rack::OpenID, OpenID::Store::Filesystem.new("/tmp/openid_#{LW_PORT}")

#OMF::Web::Runner.instance.life_cycle(:pre_rackup)
#options = OMF::Web::Runner.instance.options

#use SessionInit

# These should go to a separate controller/handler file.
#map "/create_script" do
#  handler = lambda do |env|
#    req = ::Rack::Request.new(env)
#    file_ext = req.params['file_ext'].downcase
#    file_name = "#{req.params['file_name']}.#{file_ext}"
#    sub_folder = case file_ext
#                 when 'rb'
#                   'oidl'
#                 when 'md'
#                   'wiki'
#                 end
#    repo = (LabWiki::Configurator[:repositories] || {}).first
#    if repo.class == Array
#      repo = OMF::Web::ContentRepository.find_repo_for("#{repo[1][:type]}:#{repo[0]}")
#    end
#    repo ||= (OMF::Web::SessionStore[:prepare, :repos] || []).first
#
#    begin
#      if repo.class == OMF::Web::IRodsContentRepository
#        # iRods needs full path...
#        path = "#{LabWiki::Configurator[:gimi][:irods][:home]}/#{OMF::Web::SessionStore[:id, :user]}/#{LabWiki::Configurator[:gimi][:irods][:script_folder]}/#{sub_folder}/#{file_name}"
#      else
#        path = "repo/#{sub_folder}/#{file_name}"
#      end
#
#      repo.write(path, "", "Adding new script #{file_name}")
#    rescue => e
#      if e.class == RuntimeError && e.message =~ /Cannot write to file/
#        repo.write("#{sub_folder}/#{file_name}", "", "Adding new script #{file_name}")
#      else
#        puts ">>> Write new files error: #{e.message}"
#      end
#    end
#    [200, {}, "#{file_name} created"]
#  end
#  run handler
#end
#
#map "/dump" do
#  handler = lambda do |env|
#    req = ::Rack::Request.new(env)
#    omf_exp_id = req.params['domain']
#    if LabWiki::Configurator[:gimi] && LabWiki::Configurator[:gimi][:dump_script]
#      dump_cmd = File.expand_path(LabWiki::Configurator[:gimi][:dump_script])
#    else
#      return [500, {}, "Dump script not configured."]
#    end
#
#    exp = nil
#    OMF::Web::SessionStore.find_across_sessions do |content|
#      content["omf:exps"] && (exp = content["omf:exps"].find { |v| v[:id] == omf_exp_id } )
#    end
#
#    if exp
#      i_path = "#{exp[:irods_path]}/#{LabWiki::Configurator[:gimi][:irods][:measurement_folder]}" rescue "#{exp[:irods_path]}"
#
#      dump_cmd << " --domain #{omf_exp_id} --path #{i_path}"
#      EM.popen(dump_cmd)
#      [200, {}, "Dump script triggered. <br /> Using command: #{dump_cmd} <br /> Unfortunately we cannot show you the progress."]
#    else
#      [500, {}, "Cannot find experiment(task) by domain id #{omf_exp_id}"]
#    end
#  end
#  run handler
#end
#
##map "/resource/vendor/" do
##  require 'omf-web/rack/multi_file'
##  run OMF::Web::Rack::MultiFile.new(options[:static_dirs], :sub_path => 'vendor', :version => true)
##end
#
##map "/resource" do
##  require 'omf-web/rack/multi_file'
##  dirs = options[:static_dirs]
##  dirs.insert(0, "#{File.dirname(__FILE__)}/../../htdocs")
##  run OMF::Web::Rack::MultiFile.new(dirs)
##end
#
#map "/plugin" do
#  run LabWiki::PluginResourceHandler.new()
#end
#
#
#map '/_ws' do
#  begin
#    require 'omf-web/rack/websocket_handler'
#    run OMF::Web::Rack::WebsocketHandler.new # :backend => { :debug => true }
#  rescue Exception => ex
#    OMF::Base::Loggable.logger('web').error "#{ex}"
#  end
#end
#
#
#map '/_update' do
#  require 'omf-web/rack/update_handler'
#  run OMF::Web::Rack::UpdateHandler.new
#end
#
#map '/_content' do
#  require 'omf-web/rack/content_handler'
#  run OMF::Web::Rack::ContentHandler.new
#end
#
#map '/_search' do
#  run LabWiki::SearchHandler.new
#end
#
#map '/_column' do
#  run LabWiki::ColumnHandler.new
#end
#
##map "/" do
##  handler = Proc.new do |env|
##    req = ::Rack::Request.new(env)
##    case req.path_info
##    when '/'
##      [302, {'Location' => '/labwiki', "Content-Type" => ""}, ['Next window!']]
##    when '/favicon.ico'
##      [302, {'Location' => '/resource/image/favicon.ico', "Content-Type" => ""}, ['Next window!']]
##    when '/image/favicon.ico'
##      [302, {'Location' => '/resource/image/favicon.ico', "Content-Type" => ""}, ['Next window!']]
##    else
##      OMF::Base::Loggable.logger('rack').warn "Can't handle request '#{req.path_info}'"
##      [401, {"Content-Type" => ""}, "Sorry!"]
##    end
##  end
##  run handler
##end
#
##OMF::Web::Runner.instance.life_cycle(:post_rackup)
