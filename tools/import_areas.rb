#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'sequel'

if ARGV.size != 2
  puts "usage #$0 [iarea_def.js] [dest_sqlite3_file]"
  exit -1
end

src_path = ARGV.shift
dest_path = ARGV.shift

db = Sequel.sqlite(dest_path)

db.drop_table :zones if db.table_exists?(:zones)
db.create_table :zones do
  primary_key :id
  String :name
end

db.drop_table :prefs if db.table_exists?(:prefs)
db.create_table :prefs do
  primary_key :id
  String :name
  Integer :zone_id
  index :zone_id
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
  Integer :zone_id
  Integer :pref_id
  index :areaid
  index :subareaid
  index :areacode, :unique => true
  index :zone_id
  index :pref_id
end

db.transaction do
  js = open(src_path, "r:cp932").read
  js.sub!(%r|^var IAreaDef=new function\(\)\{|, "")
  data = {}
  js.scan %r|this\.(.+?)=(.+?);|m do |key, json|
    data[key] = JSON.parse(json)
  end
  # zones
  data['zones'].each_with_index do |zone, i|
    $stderr.puts "  importing zone %d %s" % [i, zone['name']]
    db[:zones].insert(:id => i, :name => zone['name'])
  end
  # prefs
  data['prefs'].each_with_index do |pref, i|
    $stderr.puts "  importing pref %d %s" % [i, pref['name']]
    db[:prefs].insert(:id => i, :name => pref['name'], :zone_id => pref['zone'])
  end
  # areas
  data['areas'].each do |areacode, area|
    $stderr.puts "  importing area %s %s" % [areacode, area['name']]
    # insert area
    area = {
      :areaid => areacode[0..2],
      :subareaid => areacode[3..4],
      :areacode => areacode,
      :name => area['name'],
      :west => area['msWest'],
      :south => area['msSouth'],
      :east => area['msEast'],
      :north => area['msNorth'],
      :zone_id => area['zone'],
      :pref_id => area['pref']
    }
    db[:areas].insert(area)
  end
end
