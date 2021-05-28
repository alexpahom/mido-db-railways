require 'compass'
require 'sinatra/base'
require 'haml'
require 'tiny_tds'
require 'pry'
require_relative 'db'

class Application < Sinatra::Base

  configure do
    Compass.add_project_configuration("#{File.expand_path('.')}/compass.config")
  end

  helpers do
    JS_ESCAPE_MAP = {
      '\\'    => '\\\\',
      "</"    => '<\/',
      "\r\n"  => '\n',
      "\n"    => '\n',
      "\r"    => '\n',
      '"'     => '\\"',
      "'"     => "\\'"
    }

    def escape_javascript(javascript)
      javascript = javascript.to_s
      if javascript.empty?
        ""
      else
        javascript.gsub(/(\\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"'])/u) { |match| JS_ESCAPE_MAP[match] }
      end
    end
    alias_method :j, :escape_javascript

    def int_2_time(int_minutes)
      minutes = (int_minutes / 60).to_s.rjust(2, '0')
      seconds = (int_minutes % 60).to_s.rjust(2, '0')
      "#{minutes}:#{seconds}"
    end

    def extract_route_details(db_response)
      db_response.each(symbolize_keys: true).map do |hash|
        hash.select { |key, _| %i(departure arrival route_id).include? key }
      end.uniq
    end

    def extract_days(db_response)
      db_response.each(symbolize_keys: true).map { |hash| hash[:days] }.uniq
    end

    get '/css/:name.css' do
      content_type 'text/css'
      sass :"#{params[:name]}"
    end

    get '/' do
      db = Railway.new
      response = db.get_all_routes
      Railway.route_details = extract_route_details response
      Railway.days = extract_days response

      @routes = response.each(symbolize_keys: true)
      db.close
      haml :index, layout: :layout
    end

    get '/search' do
      db = Railway.new
      response = db.get_all_routes params['route_id'], params['days']

      @routes = response.each(symbolize_keys: true)
      db.close
      haml :index, layout: :layout
    end

    get '/routes/:route_id/:timetable_id' do |route_id, timetable_id|
      db = Railway.new
      response = db.get_route_stations route_id, timetable_id
      @stations = response.each(symbolize_keys: true)
      db.close
      haml :stations, layout: :layout
    end
  end

  run!
end