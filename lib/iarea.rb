require 'sequel'
require 'ostruct'

module Iarea
  DB = Sequel.sqlite(File.expand_path("../../db/iareadata.sqlite3", __FILE__))
  autoload :Area, File.expand_path('../iarea/area', __FILE__)
  autoload :Zone, File.expand_path('../iarea/zone', __FILE__)
  autoload :Prefecture, File.expand_path('../iarea/prefecture', __FILE__)
  autoload :Utils, File.expand_path('../iarea/utils', __FILE__)
end
