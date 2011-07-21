require 'sequel'
require 'ostruct'
require_relative 'iarea/version'

module Iarea # :nodoc:
  DB = Sequel.sqlite(File.expand_path("../../db/iareadata.sqlite3", __FILE__)) # :nodoc:
  autoload :Area, File.expand_path('../iarea/area', __FILE__)
  autoload :Zone, File.expand_path('../iarea/zone', __FILE__)
  autoload :Prefecture, File.expand_path('../iarea/prefecture', __FILE__)
  autoload :Utils, File.expand_path('../iarea/utils', __FILE__)
end
