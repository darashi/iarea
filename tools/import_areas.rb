#!/usr/bin/env ruby
# coding: utf-8

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

db.drop_table :prefectures if db.table_exists?(:prefectures)
db.create_table :prefectures do
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
  Integer :prefecture_id
  index :areaid
  index :subareaid
  index :areacode, :unique => true
  index :zone_id
  index :prefecture_id
end

db.drop_table :neighbors if db.table_exists?(:neighbors)
db.create_table :neighbors do
  String :areacode
  String :neighbor_areacode
  index :areacode
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
    id = i + 1
    $stderr.puts "  importing zone %d %s" % [id, zone['name']]
    db[:zones].insert(:id => id, :name => zone['name'])
  end
  # prefs
  data['prefs'].each_with_index do |pref, i|
    id = i + 1
    $stderr.puts "  importing prefecture %d %s" % [id, pref['name']]
    db[:prefectures].insert(:id => id, :name => pref['name'], :zone_id => pref['zone'] + 1)
  end
  # areas
  data['areas'].each do |areacode, area|
    $stderr.puts "  importing area %s %s" % [areacode, area['name']]
    # insert area
    hash = {
      :areaid => areacode[0..2],
      :subareaid => areacode[3..4],
      :areacode => areacode,
      :name => area['name'],
      :west => area['msWest'],
      :south => area['msSouth'],
      :east => area['msEast'],
      :north => area['msNorth'],
      :zone_id => area['zone'] + 1,
      :prefecture_id => area['pref'] + 1
    }
    # fix .js problem
    if hash[:name] == '新宿１?２丁目'
      hash[:name] = '新宿１〜２丁目'
    end
    db[:areas].insert(hash)

    area['neighbors'].each do |neighbor|
      db[:neighbors].insert({:areacode => areacode, :neighbor_areacode => neighbor})
    end
  end
end
