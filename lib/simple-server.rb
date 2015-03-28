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
    Path.new(settings.root) / 'sites' / uri.host / Path.new(uri.normalized_path).relative_to('/')
  end

  def normalized_host(host)
    host ||= settings.default_host
    host.gsub(/^www\./, '').gsub(/\..*?$/, '')
  end

  get '*' do
    uri = Addressable::URI.parse(params[:splat].first)
    uri.scheme = 'http'
    uri.host = normalized_host(request.host)
    uri.path += 'index.html' if uri.normalized_path[-1] == '/'
    path = path_for_uri(uri)
    if path.basename.to_s[0] == '.'
      logger.info "#{uri} => hidden file: denying"
      halt 403, 'unauthorized'
    elsif path.directory?
      logger.info "#{uri} => implicit directory: redirecting"
      return redirect "#{uri.path}/"
    elsif path.file?
      logger.info "#{uri} => direct file: #{path}"
      return send_file(path)
    elsif path.extname.empty?
      %w{.html .htm}.each do |extname|
        p = path.add_extension(extname)
        if p.file?
          logger.info "#{uri} => guessed extension #{extname}: #{p}"
          return send_file(p)
        end
      end
    end
    logger.info "#{uri} => not found"
    halt 404, 'not found'
  end

end