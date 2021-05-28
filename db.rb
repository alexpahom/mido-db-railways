require 'tiny_tds'
require 'pry'

class Railway

  class << self
    attr_accessor :route_details, :days
  end

  attr_reader :connection

  def initialize
    @connection = connect
  end

  def get_all_routes(route_id = 'NULL', interval = 'NULL')
    connection.execute("EXECUTE getAllRoutes #{route_id}, #{interval}")
  end

  def get_route_stations(route_id, timetable_id)
    connection.execute("EXECUTE getTimeTable #{route_id}, #{timetable_id}")
  end

  def close
    connection.close
  end

  def connect
    TinyTds::Client.new dataserver: 'DESKTOP-4I1BJOF',
                        database: 'railways',
                        appname: 'TinyTds',
                        tds_version: 5,
                        login_timeout: 60,
                        timeout: 5,
                        encoding: 'UTF-8'
  end
end
