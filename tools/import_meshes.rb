#!/usr/bin/env ruby

require 'csv'

require 'rubygems'
require 'bundler/setup'
require 'leveldb'


if ARGV.size != 2
  puts "usage #$0 [src_dir_contains_iareadata_dir] [dest_leveldb_file]"
  exit -1
end

src_path = ARGV.shift
dest_path = ARGV.shift

db = LevelDB::DB.new dest_path

Dir[File.join(src_path, "iareadata/iarea*.txt")].each do |path|
  data = CSV.open(path, "r:cp932")
  data.each do |row|
    areaid, subareaid, name, west, south, east, north, *mesh_data = row
    areacode = areaid + subareaid

    name.encode!("UTF-8")

    mesh_data.pop if mesh_data.last.nil?
    $stderr.puts "  importing meshes %s %s" % [areacode, name]
    num_meshes = mesh_data.shift(7).map(&:to_i)

    expected_num_meshes = num_meshes.inject(&:+)
    if expected_num_meshes != mesh_data.size
      raise "number of meshes mismatch: expected %d, actual %d" % [
        expected_num_meshes, mesh_data.size
      ]
    end

    # insert meshes
    mesh_data.each do |mesh|
      db['m:%s' % mesh] = areacode
    end
  end
end
