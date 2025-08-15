require 'sinatra/base'
require 'addressable'
require 'path'

class SimpleServer < Sinatra::Base

  configure do
    enable :logging
    enable :multihosting
    set :host_authorization, { permitted_hosts: [] }
  end

  before do
    env['rack.logger'] = Logger.new(STDERR)
  end

  def path_for_uri(uri)
    path = Path.new(settings.root)
    path /= (uri.normalized_host ||= settings.default_host).sub(/^(www|web|test|dev).*?\./, '') if settings.multihosting
    path /= Path.new(Addressable::URI.unencode_component(uri.normalized_path)).relative_to('/')
    path /= 'index.html' if uri.normalized_path.end_with?('/')
    path
  end

  def parse_request(request)
    begin
      uri = Addressable::URI.parse(request.url)
    rescue Addressable::URI::InvalidURIError => e
      logger.info "#{uri}: invalid URI (#{e.message}): denying"
      halt 400, 'invalid URI'
    end
    uri.host = request.host
    uri
  end

  get '*' do
    uri = parse_request(request)
    path = path_for_uri(uri)
    if path.basename.to_s[0] == '.'
      logger.info "#{uri} (#{path}): hidden file: denying"
      halt 403, 'unauthorized'
    elsif path.directory?
      logger.info "#{uri} (#{path}): implicit directory: redirecting"
      return redirect "#{uri.path}/"
    elsif (redirect_path = path.add_extension('.redirect')).exist?
      redirect_uri, redirect_code = redirect_path.read.split(/\s+/, 2)
      redirect_code = redirect_code.to_i unless redirect_code.to_s.empty?
      logger.info "#{uri} (#{path}): redirecting via #{redirect_code} to #{redirect_uri}"
      return redirect redirect_uri, redirect_code
    elsif path.file?
      logger.info "#{uri} (#{path}): direct file: serving"
      return send_file(path)
    else
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