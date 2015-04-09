require 'sinatra/base'
require 'addressable/uri'
require 'path'
require 'pp'

class SimpleServer < Sinatra::Base

  VERSION = '0.1'

  configure do
    enable :logging
  end

  before do
    env['rack.logger'] = Logger.new(STDERR)
  end

  def path_for_uri(uri)
    path = Path.new(settings.root) / 'sites'
    path /= (uri.normalized_host ||= settings.default_host).sub(/^(www|web).*?\./, '')
    path /= Path.new(Addressable::URI.unencode_component(uri.normalized_path)).relative_to('/')
    path /= 'index.html' if uri.normalized_path[-1] == '/'
    path
  end

  get '*' do
    begin
      uri = Addressable::URI.parse(request.url)
      uri.host = request.host
    rescue Addressable::URI::InvalidURIError => e
      logger.info "#{uri}: invalid URI (#{e.message}): denying"
      halt 400, 'invalid URI'
    end
    path = path_for_uri(uri)
    if path.basename.to_s[0] == '.'
      logger.info "#{uri} (#{path}): hidden file: denying"
      halt 403, 'unauthorized'
    elsif path.directory?
      logger.info "#{uri} (#{path}): implicit directory: redirecting"
      return redirect "#{uri.path}/"
    elsif path.file?
      logger.info "#{uri} (#{path}): direct file: serving"
      return send_file(path)
    elsif path.extname.empty?
      %w{.html .htm}.each do |extname|
        p = path.add_extension(extname)
        if p.file?
          logger.info "#{uri} (#{path}): guessed extension #{extname}: serving #{p}"
          return send_file(p)
        end
      end
    end
    logger.info "#{uri} (#{path}): not found: denying"
    halt 404, 'not found'
  end

end