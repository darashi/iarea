require 'json'
require 'msgpack'
require 'ostruct'
require_relative 'iarea/version'

module Iarea # :nodoc:
  DB = MessagePack::unpack(File.read(File.expand_path("../../db/meta.msgpack", __FILE__), :encoding => Encoding::ASCII_8BIT)) # :nodoc:
  MESH = MessagePack::unpack(File.read(File.expand_path("../../db/mesh.msgpack", __FILE__), :encoding => Encoding::ASCII_8BIT)) # :nodoc:
  autoload :Area, File.expand_path('../iarea/area', __FILE__)
  autoload :Zone, File.expand_path('../iarea/zone', __FILE__)
  autoload :Prefecture, File.expand_path('../iarea/prefecture', __FILE__)
  autoload :Utils, File.expand_path('../iarea/utils', __FILE__)
end
