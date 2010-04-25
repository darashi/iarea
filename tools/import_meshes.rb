#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'sequel'

if ARGV.size != 2
  puts "usage #$0 [src_dir_contains_iareadata_dir] [dest_sqlite3_file]"
  exit -1
end

src_path = ARGV.shift
dest_path = ARGV.shift

db = Sequel.sqlite(dest_path)

db.drop_table :meshes if db.table_exists?(:meshes)
db.create_table :meshes do
  String :meshcode
  String :areacode
  index :meshcode
  index :areacode
end

db.drop_table :areas if db.table_exists?(:areas)
db.create_table :areas do
  String :areaid
  String :subareaid
  String :areacode
  String :name
  Integer :west
  Integer :south
  Integer :east
  Integer :north
  index :areacode
end

db.transaction do
  meshes = db[:meshes]
  areas = db[:areas]
  Dir[File.join(src_path, "iareadata/iarea*.txt")].each do |path|
    data = CSV.open(path, "r:cp932")
    data.each do |row|
      areaid, subareaid, name, west, south, east, north, *mesh_data = row
      areacode = areaid + subareaid

      name.encode!("UTF-8")
      # insert area
      area = { :areaid => areaid,
        :subareaid => subareaid,
        :areacode => areacode,
        :name => name,
        :west => west,
        :south => south,
        :east => east,
        :north => north }
      areas.insert(area)

      mesh_data.pop if mesh_data.last.nil?
      $stderr.puts "importing area %s %s" % [areacode, name]
      num_meshes = mesh_data.shift(7).map(&:to_i)

      expected_num_meshes = num_meshes.inject(&:+)
      if expected_num_meshes != mesh_data.size
        raise "number of meshes mismatch: expected %d, actual %d" % [
          expected_num_meshes, mesh_data.size
        ]
      end

      # insert meshes
      mesh_data.each do |mesh|
        meshes.insert(:meshcode => mesh, :areacode => areacode)
      end
    end
  end
end
