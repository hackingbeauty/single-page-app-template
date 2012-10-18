require 'bundler/setup'
Bundler.require

class Application < Sinatra::Base
  get '/assets/:file' do
    env['PATH_INFO'].gsub!("/assets","")
    asset_handler.call(env)
  end

  get '/' do
    haml :index
  end

  private
  def project_root
    @project_root ||= File.expand_path File.dirname(__FILE__)
  end

  def asset_handler
    @asset_handler ||= create_asset_handler
  end

  def create_asset_handler
    handler = Sprockets::Environment.new(project_root)
    handler.cache = Sprockets::Cache::FileStore.new("/tmp")
    handler.append_path(File.join(project_root, 'src/javascripts'))
    handler.append_path(File.join(project_root, 'src/stylesheets'))
    handler
  end
end

run Application
